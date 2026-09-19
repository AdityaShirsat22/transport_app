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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

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
          try {
            await customStatement('ALTER TABLE local_transports ADD COLUMN party_mobile TEXT;');
          } catch (_) {
            // Column already exists or table not yet created
          }
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
