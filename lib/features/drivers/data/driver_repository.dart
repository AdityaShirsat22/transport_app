import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/driver_status.dart';
import '../domain/driver_model.dart';

abstract class DriverRepository {
  List<Driver> getAll();
  Driver? getById(String id);
  void add(Driver driver);
  void update(Driver driver);
  void updateStatus(String driverId, DriverStatus status, {String? vehicleId, String? vehicleNumber, bool clearVehicle = false});
  void delete(String id);
  Future<void> reloadFromDatabase();
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

class ProductionDriverRepository implements DriverRepository {
  final AppDatabase _db;
  final List<Driver> _drivers = [];
  final List<void Function()> _listeners = [];
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionDriverRepository(this._db) {
    _init();
  }

  @override
  void addListener(void Function() listener) => _listeners.add(listener);

  @override
  void removeListener(void Function() listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final l in List<void Function()>.from(_listeners)) {
      l();
    }
  }

  Future<void> _init() async {
    try {
      await reloadFromDatabase();
    } catch (_) {
      // Safe fallback
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  @override
  Future<void> reloadFromDatabase() async {
    try {
      final rows = await (_db.select(_db.localDrivers)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (rows.isNotEmpty) {
        _drivers.clear();
        for (final row in rows) {
          _drivers.add(
            Driver(
              id: row.id,
              name: row.name,
              mobileNumber: row.mobileNumber,
              status: DriverStatus.fromCode(row.status),
              currentVehicleId: row.currentVehicleId,
              currentVehicleNumber: row.currentVehicleNumber,
              isActive: row.isActive,
              createdAt: row.createdAt,
            ),
          );
        }
      }
      _notifyListeners();
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  List<Driver> getAll() => List.unmodifiable(_drivers);

  @override
  Driver? getById(String id) {
    try {
      return _drivers.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Driver driver) {
    _drivers.insert(0, driver);
    _persistToDb(driver);
    _enqueueSync(driver, 'CREATE');
    _notifyListeners();
  }

  @override
  void update(Driver driver) {
    final index = _drivers.indexWhere((d) => d.id == driver.id);
    if (index != -1) {
      _drivers[index] = driver;
      _persistToDb(driver);
      _enqueueSync(driver, 'UPDATE');
      _notifyListeners();
    }
  }

  @override
  void updateStatus(String driverId, DriverStatus status, {String? vehicleId, String? vehicleNumber, bool clearVehicle = false}) {
    final index = _drivers.indexWhere((d) => d.id == driverId);
    if (index != -1) {
      final shouldClear = clearVehicle || (status == DriverStatus.available && vehicleId == null);
      final updated = _drivers[index].copyWith(
        status: status,
        currentVehicleId: vehicleId,
        currentVehicleNumber: vehicleNumber,
        clearCurrentVehicle: shouldClear,
      );
      _drivers[index] = updated;
      _persistToDb(updated);
      _enqueueSync(updated, 'UPDATE');
      _notifyListeners();
    }
  }

  @override
  void delete(String id) {
    final index = _drivers.indexWhere((d) => d.id == id);
    if (index != -1) {
      _drivers.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
      _notifyListeners();
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localDrivers)..where((t) => t.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-drv-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'driver',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(Driver d) async {
    try {
      await _db.into(_db.localDrivers).insertOnConflictUpdate(
            LocalDriversCompanion(
              id: Value(d.id),
              name: Value(d.name),
              mobileNumber: Value(d.mobileNumber),
              status: Value(d.status.code),
              currentVehicleId: Value(d.currentVehicleId),
              currentVehicleNumber: Value(d.currentVehicleNumber),
              isActive: Value(d.isActive),
              createdAt: Value(d.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(Driver d, String op) {
    _db.enqueueSync(
      id: 'sync-drv-${DateTime.now().millisecondsSinceEpoch}-${d.id}',
      entityType: 'driver',
      entityId: d.id,
      operation: op,
      payload: jsonEncode({
        'id': d.id,
        'name': d.name,
        'mobile_number': d.mobileNumber,
        'status': d.status.code,
        'current_vehicle_id': d.currentVehicleId,
        'current_vehicle_number': d.currentVehicleNumber,
        'is_active': d.isActive,
        'created_at': d.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionDriverRepository(db);
});
