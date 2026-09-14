import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/drivers/data/driver_repository.dart';
import '../../features/drivers/domain/driver_model.dart';
import '../../features/vehicles/data/vehicle_repository.dart';
import '../../features/vehicles/domain/vehicle_model.dart';
import '../enums/driver_status.dart';
import '../enums/vehicle_status.dart';

class AssignmentResult {
  final bool isSuccess;
  final Vehicle? vehicle;
  final Driver? driver;
  final String? failureReason;

  const AssignmentResult({
    required this.isSuccess,
    this.vehicle,
    this.driver,
    this.failureReason,
  });
}

class AssignmentService {
  final VehicleRepository _vehicleRepo;
  final DriverRepository _driverRepo;

  AssignmentService(this._vehicleRepo, this._driverRepo);

  /// Find available vehicle matching container size
  Vehicle? findAvailableVehicle(String containerSizeCode) {
    final vehicles = _vehicleRepo.getAll();
    for (final v in vehicles) {
      if (v.isAvailable && v.canCarry(containerSizeCode)) {
        return v;
      }
    }
    return null;
  }

  /// Find available active driver
  Driver? findAvailableDriver() {
    final drivers = _driverRepo.getAll();
    for (final d in drivers) {
      if (d.isAvailable) {
        return d;
      }
    }
    return null;
  }

  /// Deterministic auto-assign vehicle and driver
  AssignmentResult attemptAutoAssignment(String containerSizeCode) {
    final vehicle = findAvailableVehicle(containerSizeCode);
    if (vehicle == null) {
      return const AssignmentResult(
        isSuccess: false,
        failureReason: 'No suitable vehicle is currently available. Manager attention required.',
      );
    }

    final driver = findAvailableDriver();
    if (driver == null) {
      return const AssignmentResult(
        isSuccess: false,
        failureReason: 'Suitable vehicle found, but no available driver found.',
      );
    }

    // Mark both as ON_TRIP
    _vehicleRepo.updateStatus(
      vehicle.id,
      VehicleStatus.onTrip,
      driverId: driver.id,
      driverName: driver.name,
    );
    _driverRepo.updateStatus(
      driver.id,
      DriverStatus.onTrip,
      vehicleId: vehicle.id,
      vehicleNumber: vehicle.vehicleNumber,
    );

    return AssignmentResult(
      isSuccess: true,
      vehicle: _vehicleRepo.getById(vehicle.id),
      driver: _driverRepo.getById(driver.id),
    );
  }

  /// Release a vehicle back to AVAILABLE
  void releaseVehicle(String? vehicleId) {
    if (vehicleId == null) return;
    _vehicleRepo.updateStatus(vehicleId, VehicleStatus.available, driverId: null, driverName: null);
  }

  /// Release a driver back to AVAILABLE
  void releaseDriver(String? driverId) {
    if (driverId == null) return;
    _driverRepo.updateStatus(driverId, DriverStatus.available, vehicleId: null, vehicleNumber: null);
  }

  /// Reassign vehicle
  Vehicle? reassignVehicle({
    required String? oldVehicleId,
    required String newVehicleId,
    required String? driverId,
    required String? driverName,
  }) {
    if (oldVehicleId != null) {
      releaseVehicle(oldVehicleId);
    }

    _vehicleRepo.updateStatus(
      newVehicleId,
      VehicleStatus.onTrip,
      driverId: driverId,
      driverName: driverName,
    );

    return _vehicleRepo.getById(newVehicleId);
  }

  /// Reassign driver
  Driver? reassignDriver({
    required String? oldDriverId,
    required String newDriverId,
    required String? vehicleId,
    required String? vehicleNumber,
  }) {
    if (oldDriverId != null) {
      releaseDriver(oldDriverId);
    }

    _driverRepo.updateStatus(
      newDriverId,
      DriverStatus.onTrip,
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
    );

    return _driverRepo.getById(newDriverId);
  }
}

final assignmentServiceProvider = Provider<AssignmentService>((ref) {
  final vehicleRepo = ref.watch(vehicleRepositoryProvider);
  final driverRepo = ref.watch(driverRepositoryProvider);
  return AssignmentService(vehicleRepo, driverRepo);
});
