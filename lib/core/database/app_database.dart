import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/local_activity_logs.dart';
import 'tables/local_driver_assignments.dart';
import 'tables/local_drivers.dart';
import 'tables/local_locations.dart';
import 'tables/local_notification_logs.dart';
import 'tables/local_parties.dart';
import 'tables/local_pod_documents.dart';
import 'tables/local_ports_cfs.dart';
import 'tables/local_shipping_lines.dart';
import 'tables/local_sync_queue.dart';
import 'tables/local_transport_allocations.dart';
import 'tables/local_transport_status_history.dart';
import 'tables/local_transports.dart';
import 'tables/local_vehicle_assignments.dart';
import 'tables/local_vehicles.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  LocalVehicles,
  LocalDrivers,
  LocalParties,
  LocalShippingLines,
  LocalLocations,
  LocalPortsCfs,
  LocalTransports,
  LocalTransportStatusHistory,
  LocalVehicleAssignments,
  LocalDriverAssignments,
  LocalNotificationLogs,
  LocalPodDocuments,
  LocalActivityLogs,
  LocalSyncQueue,
  LocalTransportAllocations,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = OFF;');
          // v1 migration: add party_mobile column if missing
          try {
            await customStatement('ALTER TABLE local_transports ADD COLUMN party_mobile TEXT;');
          } catch (_) {}
          // v3 migration: create allocations table if not yet created
          try {
            await customStatement(
              'CREATE TABLE IF NOT EXISTS local_transport_allocations '
              '(id TEXT NOT NULL PRIMARY KEY, transport_id TEXT NOT NULL, '
              'slot_index INTEGER NOT NULL, vehicle_id TEXT NOT NULL, '
              'vehicle_number TEXT NOT NULL, driver_id TEXT, driver_name TEXT, '
              'driver_mobile TEXT, assigned_at INTEGER NOT NULL);',
            );
          } catch (_) {}
          // v3 / v4 migration: backfill slot-0 allocations from legacy transport columns.
          // For transports that have vehicle_id set but no row in local_transport_allocations,
          // create a synthetic slot-0 allocation so those transports show their assigned
          // vehicle/driver in the Fleet & Crew card.
          // NOTE: Only slot-0 can be recovered here because slots 1+ were only stored
          // in the allocations table (which is what we are repairing). Any slot 1+
          // records that were lost due to the silent-catch bug cannot be recovered
          // from the DB — they must be re-assigned manually from Transport Details.
          try {
            await customStatement(
              'INSERT OR IGNORE INTO local_transport_allocations '
              '(id, transport_id, slot_index, vehicle_id, vehicle_number, '
              'driver_id, driver_name, driver_mobile, assigned_at) '
              'SELECT "alloc-" || id, id, 0, vehicle_id, vehicle_number, '
              'driver_id, driver_name, driver_mobile, created_at '
              'FROM local_transports WHERE vehicle_id IS NOT NULL AND vehicle_id != \'\';',
            );
          } catch (_) {}
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'freightops.sqlite'));
      final marker = File(p.join(dbFolder.path, '.fresh_v1_cleared'));

      // One-time purge of any previously cached demo seed data
      if (!marker.existsSync()) {
        try {
          if (file.existsSync()) file.deleteSync();
          final wal = File(p.join(dbFolder.path, 'freightops.sqlite-wal'));
          if (wal.existsSync()) wal.deleteSync();
          final shm = File(p.join(dbFolder.path, 'freightops.sqlite-shm'));
          if (shm.existsSync()) shm.deleteSync();
          marker.writeAsStringSync('cleared');
        } catch (_) {
          // Ignore if permission or file locks
        }
      }

      return NativeDatabase.createInBackground(file);
    });
  }

  // ===========================================================================
  // SYNC QUEUE OPERATIONS
  // ===========================================================================
  Future<void> enqueueSync({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
  }) async {
    try {
      await into(localSyncQueue).insertOnConflictUpdate(
        LocalSyncQueueCompanion.insert(
          id: id,
          entityType: entityType,
          entityId: entityId,
          operation: operation,
          payload: payload,
          createdAt: DateTime.now(),
          syncStatus: const Value('PENDING'),
        ),
      );
    } catch (_) {
      // Safe fallback if database is closing or in lightweight test mode
    }
  }

  Future<List<LocalSyncQueueData>> getPendingSyncQueue() async {
    return (select(localSyncQueue)
          ..where((t) => t.syncStatus.isIn(['PENDING', 'FAILED']))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> updateSyncQueueStatus(
    String id,
    String status, {
    String? error,
  }) async {
    final existing = await (select(localSyncQueue)..where((t) => t.id.equals(id))).getSingleOrNull();
    final retry = (existing?.retryCount ?? 0) + (status == 'FAILED' ? 1 : 0);

    await (update(localSyncQueue)..where((t) => t.id.equals(id))).write(
      LocalSyncQueueCompanion(
        syncStatus: Value(status),
        retryCount: Value(retry),
        lastError: Value(error),
      ),
    );
  }

  Future<void> deleteSyncQueueItem(String id) async {
    await (delete(localSyncQueue)..where((t) => t.id.equals(id))).go();
  }

  // ===========================================================================
  // CONCURRENCY GUARDS: ACTIVE ASSIGNMENT CHECKS
  // ===========================================================================
  Future<bool> isVehicleActivelyAssigned(String vehicleId) async {
    final count = await (select(localVehicleAssignments)
          ..where((t) => t.vehicleId.equals(vehicleId) & t.isActive.equals(true)))
        .get();
    return count.isNotEmpty;
  }

  Future<bool> isDriverActivelyAssigned(String driverId) async {
    final count = await (select(localDriverAssignments)
          ..where((t) => t.driverId.equals(driverId) & t.isActive.equals(true)))
        .get();
    return count.isNotEmpty;
  }

  // ===========================================================================
  // DATABASE PURGE / RESET FOR DEVICE RESTORE
  // ===========================================================================
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(localTransports).go();
      await delete(localTransportStatusHistory).go();
      await delete(localVehicleAssignments).go();
      await delete(localDriverAssignments).go();
      await delete(localNotificationLogs).go();
      await delete(localPodDocuments).go();
      await delete(localActivityLogs).go();
      await delete(localVehicles).go();
      await delete(localDrivers).go();
      await delete(localParties).go();
      await delete(localShippingLines).go();
      await delete(localLocations).go();
      await delete(localPortsCfs).go();
      await delete(localSyncQueue).go();
    });
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
