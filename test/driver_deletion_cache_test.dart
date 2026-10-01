import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/core/enums/driver_status.dart';
import 'package:transport_app/features/drivers/data/driver_repository.dart';
import 'package:transport_app/features/drivers/domain/driver_model.dart';
import 'package:transport_app/features/drivers/presentation/driver_view_model.dart';

void main() {
  late AppDatabase db;
  late ProductionDriverRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ProductionDriverRepository(db);
    await repo.initialized;
  });

  tearDown(() async {
    await db.close();
  });

  group('Driver Deletion & Cache Refresh Tests', () {
    test('Deleting a driver removes it from in-memory cache, Drift SQLite, and enqueues DELETE sync', () async {
      final driver = Driver(
        id: 'drv-test-1',
        name: 'Ramesh Patel',
        mobileNumber: '9876543210',
        status: DriverStatus.available,
        createdAt: DateTime(2026, 1, 1),
      );

      repo.add(driver);
      expect(repo.getAll().length, equals(1));

      // Verify row exists in SQLite
      final rowsBefore = await db.select(db.localDrivers).get();
      expect(rowsBefore.length, equals(1));
      expect(rowsBefore.first.id, equals('drv-test-1'));

      // Perform deletion
      await repo.delete('drv-test-1');

      // Verify removed from in-memory cache
      expect(repo.getAll(), isEmpty);
      expect(repo.getById('drv-test-1'), isNull);

      // Verify removed from SQLite
      final rowsAfter = await db.select(db.localDrivers).get();
      expect(rowsAfter, isEmpty);

      // Verify DELETE sync queue item was enqueued
      final queue = await db.getPendingSyncQueue();
      expect(queue.any((q) => q.entityId == 'drv-test-1' && q.operation == 'DELETE'), isTrue);
    });

    test('reloadFromDatabase empties in-memory cache when all drivers are deleted from SQLite', () async {
      final driver1 = Driver(
        id: 'drv-1',
        name: 'Driver One',
        mobileNumber: '9999911111',
        status: DriverStatus.available,
        createdAt: DateTime(2026, 1, 1),
      );
      repo.add(driver1);
      expect(repo.getAll().length, equals(1));

      // Simulate external/cloud deletion in database (e.g., deleted in DB console or cloud sync)
      await (db.delete(db.localDrivers)..where((t) => t.id.equals('drv-1'))).go();

      // Refresh / reload from database
      await repo.reloadFromDatabase();

      // In-memory cache must now be empty (not retaining stale driver)
      expect(repo.getAll(), isEmpty);
    });

    test('DriverViewModel deleteDriver updates state and syncs deletion', () async {
      bool autoSyncCalled = false;
      final vm = DriverViewModel(repo, () {
        autoSyncCalled = true;
      });

      final driver = Driver(
        id: 'drv-vm-1',
        name: 'Suresh Kumar',
        mobileNumber: '9888877777',
        status: DriverStatus.available,
        createdAt: DateTime(2026, 1, 1),
      );
      repo.add(driver);
      vm.loadDrivers();
      expect(vm.state.drivers.length, equals(1));

      // Delete via view model
      final success = await vm.deleteDriver('drv-vm-1');
      expect(success, isTrue);
      expect(vm.state.drivers, isEmpty);
      expect(autoSyncCalled, isTrue);

      // In-memory repo and SQLite are both cleared
      expect(repo.getAll(), isEmpty);
      final dbRows = await db.select(db.localDrivers).get();
      expect(dbRows, isEmpty);

      vm.dispose();
    });
  });
}
