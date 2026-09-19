import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Offline Sync Queue Tests', () {
    test('Enqueue mutation and retrieve pending items in chronological order', () async {
      await db.enqueueSync(
        id: 'sync-1',
        entityType: 'vehicle',
        entityId: 'veh-1',
        operation: 'CREATE',
        payload: '{"id": "veh-1", "vehicle_number": "MH12AB1234"}',
      );

      await db.enqueueSync(
        id: 'sync-2',
        entityType: 'driver',
        entityId: 'drv-1',
        operation: 'UPDATE',
        payload: '{"id": "drv-1", "name": "Ramesh Kumar"}',
      );

      final pending = await db.getPendingSyncQueue();
      expect(pending.length, equals(2));
      expect(pending[0].entityType, equals('vehicle'));
      expect(pending[1].entityType, equals('driver'));
      expect(pending[0].syncStatus, equals('PENDING'));
    });

    test('Update sync status and retry count on failure', () async {
      await db.enqueueSync(
        id: 'sync-test-fail',
        entityType: 'transport',
        entityId: 'tr-1',
        operation: 'CREATE',
        payload: '{"id": "tr-1"}',
      );

      // Mark as failed
      await db.updateSyncQueueStatus('sync-test-fail', 'FAILED', error: 'Network timeout');

      final items = await db.getPendingSyncQueue();
      expect(items.length, equals(1));
      expect(items.first.syncStatus, equals('FAILED'));
      expect(items.first.retryCount, equals(1));
      expect(items.first.lastError, equals('Network timeout'));
    });

    test('Delete sync queue item when cloud synchronization succeeds', () async {
      await db.enqueueSync(
        id: 'sync-success',
        entityType: 'party',
        entityId: 'pty-1',
        operation: 'CREATE',
        payload: '{"id": "pty-1"}',
      );

      var items = await db.getPendingSyncQueue();
      expect(items.length, equals(1));

      // Successfully synced
      await db.deleteSyncQueueItem('sync-success');

      items = await db.getPendingSyncQueue();
      expect(items, isEmpty);
    });

    test('Transport persistence and migration handles party_mobile column gracefully', () async {
      final now = DateTime.now();
      await db.into(db.localTransports).insertOnConflictUpdate(
            LocalTransportsCompanion(
              id: const Value('test-tr-mig'),
              transportNumber: const Value('test-tr-mig'),
              bookingNumber: const Value('BK-TEST'),
              containerNumber: const Value('CONT-1'),
              sealNumber: const Value('SEAL-1'),
              containerSize: const Value('40 FT'),
              shipmentType: const Value('EXPORT'),
              partyId: const Value('p-1'),
              partyName: const Value('Party 1'),
              partyMobile: const Value('9876543210'),
              bookingPartyId: const Value('p-1'),
              bookingPartyName: const Value('Party 1'),
              shippingLineId: const Value('s-1'),
              shippingLineName: const Value('Line 1'),
              fromLocationId: const Value('loc-1'),
              fromLocationName: const Value('From 1'),
              toLocationId: const Value('loc-2'),
              toLocationName: const Value('To 2'),
              portCfsId: const Value('port-1'),
              portCfsName: const Value('Port 1'),
              status: const Value('COMPLETED'),
              completedAt: Value(now),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      final row = await (db.select(db.localTransports)..where((t) => t.id.equals('test-tr-mig'))).getSingle();
      expect(row.status, equals('COMPLETED'));
      expect(row.partyMobile, equals('9876543210'));
      expect(row.completedAt, isNotNull);
    });
  });
}
