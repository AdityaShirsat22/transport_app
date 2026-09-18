import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/drivers/data/driver_repository.dart';
import '../../features/drivers/domain/driver_model.dart';
import '../../features/transport/data/transport_repository.dart';
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
  final TransportRepository _transportRepo;

  AssignmentService(this._vehicleRepo, this._driverRepo, this._transportRepo);

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
  AssignmentResult attemptAutoAssignment(
    String containerSizeCode, {
    String? transportId,
  }) {
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

    // Record assignments in history if transportId provided
    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.recordVehicleAssignment(transportId: transportId, vehicleId: vehicle.id);
      _transportRepo.recordDriverAssignment(transportId: transportId, driverId: driver.id);
    }

    return AssignmentResult(
      isSuccess: true,
      vehicle: _vehicleRepo.getById(vehicle.id),
      driver: _driverRepo.getById(driver.id),
    );
  }

  /// Explicitly assign specific vehicle and driver (manual assignment)
  AssignmentResult assignSpecific({
    required String vehicleId,
    required String vehicleNumber,
    required String driverId,
    required String driverName,
    String? transportId,
  }) {
    _vehicleRepo.updateStatus(
      vehicleId,
      VehicleStatus.onTrip,
      driverId: driverId,
      driverName: driverName,
    );
    _driverRepo.updateStatus(
      driverId,
      DriverStatus.onTrip,
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
    );

    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.recordVehicleAssignment(transportId: transportId, vehicleId: vehicleId);
      _transportRepo.recordDriverAssignment(transportId: transportId, driverId: driverId);
    }

    return AssignmentResult(
      isSuccess: true,
      vehicle: _vehicleRepo.getById(vehicleId),
      driver: _driverRepo.getById(driverId),
    );
  }

  /// Release a vehicle back to AVAILABLE
  void releaseVehicle(String? vehicleId, {String? transportId}) {
    if (vehicleId == null) return;
    _vehicleRepo.updateStatus(vehicleId, VehicleStatus.available, driverId: null, driverName: null);
    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.releaseVehicleAssignment(transportId: transportId, vehicleId: vehicleId);
    }
  }

  /// Release a driver back to AVAILABLE
  void releaseDriver(String? driverId, {String? transportId}) {
    if (driverId == null) return;
    _driverRepo.updateStatus(driverId, DriverStatus.available, vehicleId: null, vehicleNumber: null);
    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.releaseDriverAssignment(transportId: transportId, driverId: driverId);
    }
  }

  /// Reassign vehicle
  Vehicle? reassignVehicle({
    required String? transportId,
    required String? oldVehicleId,
    required String newVehicleId,
    required String? driverId,
    required String? driverName,
  }) {
    if (oldVehicleId != null) {
      releaseVehicle(oldVehicleId, transportId: transportId);
    }

    _vehicleRepo.updateStatus(
      newVehicleId,
      VehicleStatus.onTrip,
      driverId: driverId,
      driverName: driverName,
    );

    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.recordVehicleAssignment(transportId: transportId, vehicleId: newVehicleId);
    }

    return _vehicleRepo.getById(newVehicleId);
  }

  /// Reassign driver
  Driver? reassignDriver({
    required String? transportId,
    required String? oldDriverId,
    required String newDriverId,
    required String? vehicleId,
    required String? vehicleNumber,
  }) {
    if (oldDriverId != null) {
      releaseDriver(oldDriverId, transportId: transportId);
    }

    _driverRepo.updateStatus(
      newDriverId,
      DriverStatus.onTrip,
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
    );

    if (transportId != null && transportId.isNotEmpty) {
      _transportRepo.recordDriverAssignment(transportId: transportId, driverId: newDriverId);
    }

    return _driverRepo.getById(newDriverId);
  }
}

final assignmentServiceProvider = Provider<AssignmentService>((ref) {
  final vehicleRepo = ref.watch(vehicleRepositoryProvider);
  final driverRepo = ref.watch(driverRepositoryProvider);
  final transportRepo = ref.watch(transportRepositoryProvider);
  return AssignmentService(vehicleRepo, driverRepo, transportRepo);
});
