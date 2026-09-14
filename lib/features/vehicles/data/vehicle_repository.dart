import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/vehicle_status.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/vehicle_model.dart';

abstract class VehicleRepository {
  List<Vehicle> getAll();
  Vehicle? getById(String id);
  Vehicle? getByNumber(String vehicleNumber);
  void add(Vehicle vehicle);
  void update(Vehicle vehicle);
  void updateStatus(String vehicleId, VehicleStatus status, {String? driverId, String? driverName});
  void delete(String id);
}

class MockVehicleRepository implements VehicleRepository {
  final List<Vehicle> _vehicles = [];

  MockVehicleRepository() {
    _vehicles.addAll(DemoSeedData.getVehicles());
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
    _vehicles.add(vehicle);
  }

  @override
  void update(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
    }
  }

  @override
  void updateStatus(String vehicleId, VehicleStatus status, {String? driverId, String? driverName}) {
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final current = _vehicles[index];
      _vehicles[index] = current.copyWith(
        status: status,
        assignedDriverId: driverId,
        assignedDriverName: driverName,
      );
    }
  }

  @override
  void delete(String id) {
    _vehicles.removeWhere((v) => v.id == id);
  }
}

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return MockVehicleRepository();
});
