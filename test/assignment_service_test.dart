import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/core/enums/container_size.dart';
import 'package:transport_app/core/enums/driver_status.dart';
import 'package:transport_app/core/enums/vehicle_status.dart';
import 'package:transport_app/core/services/assignment_service.dart';
import 'package:transport_app/features/drivers/data/driver_repository.dart';
import 'package:transport_app/features/drivers/domain/driver_model.dart';
import 'package:transport_app/features/transport/data/transport_repository.dart';
import 'package:transport_app/features/vehicles/data/vehicle_repository.dart';
import 'package:transport_app/features/vehicles/domain/vehicle_model.dart';

void main() {
  late AppDatabase db;
  late ProductionVehicleRepository vehicleRepo;
  late ProductionDriverRepository driverRepo;
  late ProductionTransportRepository transportRepo;
  late AssignmentService service;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vehicleRepo = ProductionVehicleRepository(db);
    driverRepo = ProductionDriverRepository(db);
    transportRepo = ProductionTransportRepository(db);
    service = AssignmentService(vehicleRepo, driverRepo, transportRepo);

    // Wait for async init of repos
    await vehicleRepo.initialized;
    await driverRepo.initialized;
    await transportRepo.initialized;

    final now = DateTime(2026, 1, 1);
    vehicleRepo.add(
      Vehicle(
        id: 'test-veh-1',
        vehicleNumber: 'MH-12-AB-1001',
        vehicleType: 'Trailer 40FT',
        capacity: '40 FT',
        status: VehicleStatus.available,
        createdAt: now,
      ),
    );
    vehicleRepo.add(
      Vehicle(
        id: 'test-veh-2',
        vehicleNumber: 'MH-12-AB-1002',
        vehicleType: 'Trailer 40FT',
        capacity: '40 FT',
        status: VehicleStatus.available,
        createdAt: now,
      ),
    );
    vehicleRepo.add(
      Vehicle(
        id: 'test-veh-3',
        vehicleNumber: 'MH-12-AB-1003',
        vehicleType: 'Truck 20FT',
        capacity: '20 FT',
        status: VehicleStatus.available,
        createdAt: now,
      ),
    );
    driverRepo.add(
      Driver(
        id: 'test-drv-1',
        name: 'Ramesh Kumar',
        mobileNumber: '9820011223',
        status: DriverStatus.available,
        createdAt: now,
      ),
    );
    driverRepo.add(
      Driver(
        id: 'test-drv-2',
        name: 'Suresh Patil',
        mobileNumber: '9820044556',
        status: DriverStatus.available,
        createdAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('AssignmentService Tests', () {
    test('Vehicle capacity matching: 40 FT container requires 40 FT vehicle', () {
      final vehicle = service.findAvailableVehicle(ContainerSize.size40Ft.code);
      expect(vehicle, isNotNull);
      expect(vehicle!.capacity, equals('40 FT'));
      expect(vehicle.isAvailable, isTrue);
    });

    test('Vehicle capacity matching: 20 FT container can use 20 FT or 40 FT vehicle', () {
      final vehicle = service.findAvailableVehicle(ContainerSize.size20Ft.code);
      expect(vehicle, isNotNull);
      expect(vehicle!.isAvailable, isTrue);
      expect(vehicle.canCarry('20 FT'), isTrue);
    });

    test('Auto-assignment marks vehicle and driver ON_TRIP, releasing returns to AVAILABLE', () {
      const transportId = 'test-tr-101';
      final result = service.attemptAutoAssignment(
        ContainerSize.size40Ft.code,
        transportId: transportId,
      );

      expect(result.isSuccess, isTrue);
      expect(result.vehicle, isNotNull);
      expect(result.driver, isNotNull);

      // Verify status in repository
      final updatedVeh = vehicleRepo.getById(result.vehicle!.id);
      final updatedDrv = driverRepo.getById(result.driver!.id);
      expect(updatedVeh!.status, equals(VehicleStatus.onTrip));
      expect(updatedDrv!.status, equals(DriverStatus.onTrip));

      // Release resources
      service.releaseVehicle(result.vehicle!.id, transportId: transportId);
      service.releaseDriver(result.driver!.id, transportId: transportId);

      final releasedVeh = vehicleRepo.getById(result.vehicle!.id);
      final releasedDrv = driverRepo.getById(result.driver!.id);
      expect(releasedVeh!.status, equals(VehicleStatus.available));
      expect(releasedDrv!.status, equals(DriverStatus.available));
    });

    test('Returns failure when all suitable vehicles are unavailable', () {
      // Mark all vehicles on trip
      for (final v in vehicleRepo.getAll()) {
        vehicleRepo.updateStatus(v.id, VehicleStatus.onTrip);
      }

      final result = service.attemptAutoAssignment(ContainerSize.size40Ft.code);
      expect(result.isSuccess, isFalse);
      expect(result.failureReason, contains('No suitable vehicle'));
    });

    test('Reassign vehicle releases old vehicle and assigns new vehicle', () {
      const transportId = 'test-tr-102';
      final result = service.attemptAutoAssignment(ContainerSize.size40Ft.code, transportId: transportId);
      final oldVehId = result.vehicle!.id;

      // Find another available vehicle
      final newVeh = vehicleRepo.getAll().firstWhere(
            (v) => v.id != oldVehId && v.isAvailable,
          );

      final reassigned = service.reassignVehicle(
        transportId: transportId,
        oldVehicleId: oldVehId,
        newVehicleId: newVeh.id,
        driverId: result.driver!.id,
        driverName: result.driver!.name,
      );

      expect(reassigned, isNotNull);
      expect(reassigned!.id, equals(newVeh.id));

      // Old vehicle should be available again
      expect(vehicleRepo.getById(oldVehId)!.status, equals(VehicleStatus.available));
      // New vehicle should be on trip
      expect(vehicleRepo.getById(newVeh.id)!.status, equals(VehicleStatus.onTrip));
    });
  });
}
