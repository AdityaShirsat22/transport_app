import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/driver_status.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/driver_model.dart';

abstract class DriverRepository {
  List<Driver> getAll();
  Driver? getById(String id);
  void add(Driver driver);
  void update(Driver driver);
  void updateStatus(String driverId, DriverStatus status, {String? vehicleId, String? vehicleNumber});
  void delete(String id);
}

class MockDriverRepository implements DriverRepository {
  final List<Driver> _drivers = [];

  MockDriverRepository() {
    _drivers.addAll(DemoSeedData.getDrivers());
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
    _drivers.add(driver);
  }

  @override
  void update(Driver driver) {
    final index = _drivers.indexWhere((d) => d.id == driver.id);
    if (index != -1) {
      _drivers[index] = driver;
    }
  }

  @override
  void updateStatus(String driverId, DriverStatus status, {String? vehicleId, String? vehicleNumber}) {
    final index = _drivers.indexWhere((d) => d.id == driverId);
    if (index != -1) {
      final current = _drivers[index];
      _drivers[index] = current.copyWith(
        status: status,
        currentVehicleId: vehicleId,
        currentVehicleNumber: vehicleNumber,
      );
    }
  }

  @override
  void delete(String id) {
    _drivers.removeWhere((d) => d.id == id);
  }
}

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return MockDriverRepository();
});
