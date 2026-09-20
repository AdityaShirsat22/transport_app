import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/vehicle_status.dart';
import '../domain/vehicle_model.dart';

abstract class VehicleRepository {
  List<Vehicle> getAll();
  Vehicle? getById(String id);
  Vehicle? getByNumber(String vehicleNumber);
  void add(Vehicle vehicle);
  void update(Vehicle vehicle);
  void updateStatus(String vehicleId, VehicleStatus status, {String? driverId, String? driverName, bool clearDriver = false});
  void delete(String id);
  Future<void> reloadFromDatabase();
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

class ProductionVehicleRepository implements VehicleRepository {
  final AppDatabase _db;
  final List<Vehicle> _vehicles = [];
  final List<void Function()> _listeners = [];
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionVehicleRepository(this._db) {
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
      final rows = await (_db.select(_db.localVehicles)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (rows.isNotEmpty) {
        _vehicles.clear();
        for (final row in rows) {
          _vehicles.add(
            Vehicle(
              id: row.id,
              vehicleNumber: row.vehicleNumber,
              vehicleType: row.vehicleType,
              capacity: row.capacity,
              status: VehicleStatus.fromCode(row.status),
              assignedDriverId: row.assignedDriverId,
              assignedDriverName: row.assignedDriverName,
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
  List<Vehicle> getAll() => List.unmodifiable(_vehicles);

  @override
  Vehicle? getById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Vehicle? getByNumber(String vehicleNumber) {
    try {
      return _vehicles.firstWhere(
        (v) => v.vehicleNumber.toLowerCase() == vehicleNumber.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Vehicle vehicle) {
    _vehicles.insert(0, vehicle);
    _persistToDb(vehicle);
    _enqueueSync(vehicle, 'CREATE');
    _notifyListeners();
  }

  @override
  void update(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      _persistToDb(vehicle);
      _enqueueSync(vehicle, 'UPDATE');
      _notifyListeners();
    }
  }

  @override
  void updateStatus(String vehicleId, VehicleStatus status, {String? driverId, String? driverName, bool clearDriver = false}) {
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final shouldClear = clearDriver || (status == VehicleStatus.available && driverId == null);
      final updated = _vehicles[index].copyWith(
        status: status,
        assignedDriverId: driverId,
        assignedDriverName: driverName,
        clearAssignedDriver: shouldClear,
      );
      _vehicles[index] = updated;
      _persistToDb(updated);
      _enqueueSync(updated, 'UPDATE');
      _notifyListeners();
    }
  }

  @override
  void delete(String id) {
    final index = _vehicles.indexWhere((v) => v.id == id);
    if (index != -1) {
      _vehicles.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
      _notifyListeners();
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localVehicles)..where((v) => v.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-veh-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'vehicle',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(Vehicle v) async {
    try {
      await _db.into(_db.localVehicles).insertOnConflictUpdate(
            LocalVehiclesCompanion(
              id: Value(v.id),
              vehicleNumber: Value(v.vehicleNumber),
              vehicleType: Value(v.vehicleType),
              capacity: Value(v.capacity),
              status: Value(v.status.code),
              assignedDriverId: Value(v.assignedDriverId),
              assignedDriverName: Value(v.assignedDriverName),
              isActive: Value(v.isActive),
              createdAt: Value(v.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(Vehicle v, String op) {
    _db.enqueueSync(
      id: 'sync-veh-${DateTime.now().millisecondsSinceEpoch}-${v.id}',
      entityType: 'vehicle',
      entityId: v.id,
      operation: op,
      payload: jsonEncode({
        'id': v.id,
        'vehicle_number': v.vehicleNumber,
        'vehicle_type': v.vehicleType,
        'capacity': v.capacity,
        'status': v.status.code,
        'assigned_driver_id': v.assignedDriverId,
        'assigned_driver_name': v.assignedDriverName,
        'is_active': v.isActive,
        'created_at': v.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionVehicleRepository(db);
});
