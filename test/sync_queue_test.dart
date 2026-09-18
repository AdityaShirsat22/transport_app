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
  });
}
