import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transport_app/app/app.dart';
import 'package:transport_app/core/enums/container_size.dart';
import 'package:transport_app/core/enums/driver_status.dart';
import 'package:transport_app/core/enums/shipment_type.dart';
import 'package:transport_app/core/enums/transport_status.dart';
import 'package:transport_app/core/enums/vehicle_status.dart';
import 'package:transport_app/core/services/assignment_service.dart';
import 'package:transport_app/features/drivers/data/driver_repository.dart';
import 'package:transport_app/features/transport/presentation/transport_view_model.dart';
import 'package:transport_app/features/vehicles/data/vehicle_repository.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Deterministic AssignmentService Tests', () {
    test('Vehicle capacity matching: 40 FT container requires 40 FT vehicle', () {
      final vehicleRepo = MockVehicleRepository();
      final driverRepo = MockDriverRepository();
      final service = AssignmentService(vehicleRepo, driverRepo);

      final vehicle = service.findAvailableVehicle(ContainerSize.size40Ft.code);
      expect(vehicle, isNotNull);
      expect(vehicle!.capacity, equals('40 FT'));
      expect(vehicle.isAvailable, isTrue);
    });

    test('Auto-assignment marks vehicle and driver ON_TRIP, releasing returns to AVAILABLE', () {
      final vehicleRepo = MockVehicleRepository();
      final driverRepo = MockDriverRepository();
      final service = AssignmentService(vehicleRepo, driverRepo);

      final result = service.attemptAutoAssignment(ContainerSize.size40Ft.code);
      expect(result.isSuccess, isTrue);
      expect(result.vehicle, isNotNull);
      expect(result.driver, isNotNull);

      // Verify updated status in repository
      final updatedVeh = vehicleRepo.getById(result.vehicle!.id);
      final updatedDrv = driverRepo.getById(result.driver!.id);
      expect(updatedVeh!.status, equals(VehicleStatus.onTrip));
      expect(updatedDrv!.status, equals(DriverStatus.onTrip));

      // Release resources
      service.releaseVehicle(result.vehicle!.id);
      service.releaseDriver(result.driver!.id);

      final releasedVeh = vehicleRepo.getById(result.vehicle!.id);
      final releasedDrv = driverRepo.getById(result.driver!.id);
      expect(releasedVeh!.status, equals(VehicleStatus.available));
      expect(releasedDrv!.status, equals(DriverStatus.available));
    });

    test('Pending scenario: returns failure when all matching vehicles are busy', () {
      final vehicleRepo = MockVehicleRepository();
      final driverRepo = MockDriverRepository();
      final service = AssignmentService(vehicleRepo, driverRepo);

      // Make all 40 FT vehicles busy
      for (final v in vehicleRepo.getAll()) {
        if (v.capacity == '40 FT') {
          vehicleRepo.updateStatus(v.id, VehicleStatus.onTrip);
        }
      }

      final result = service.attemptAutoAssignment(ContainerSize.size40Ft.code);
      expect(result.isSuccess, isFalse);
      expect(result.failureReason, contains('No suitable vehicle'));
    });
  });

  group('Transport End-to-End Workflow Tests', () {
    test('Create Booking -> Auto-Assign -> Complete -> Resources Released', () async {
      final container = ProviderContainer();
      final vm = container.read(transportViewModelProvider.notifier);

      final outcome = await vm.createBooking(
        containerSize: ContainerSize.size40Ft,
        shipmentType: ShipmentType.export,
        containerNumber: 'TEST1234567',
        sealNumber: 'SL-99999',
        partyId: 'pty-1',
        partyName: 'ABC Logistics Pvt Ltd',
        partyMobile: '9822001122',
        bookingPartyId: 'pty-1',
        bookingPartyName: 'ABC Logistics Pvt Ltd',
        shippingLineId: 'shp-1',
        shippingLineName: 'MSC',
        bookingNumber: 'BKTEST-001',
        fromLocationId: 'loc-1',
        fromLocationName: 'Pune',
        toLocationId: 'loc-4',
        toLocationName: 'JNPT',
        portCfsId: 'pc-1',
        portCfsName: 'JNPT Port',
      );

      expect(outcome.wasAssigned, isTrue);
      expect(outcome.transport.status, equals(TransportStatus.driverAssigned));
      final assignedVehId = outcome.transport.vehicleId!;
      final assignedDrvId = outcome.transport.driverId!;

      // Verify vehicle is on trip
      final vehRepo = container.read(vehicleRepositoryProvider);
      final drvRepo = container.read(driverRepositoryProvider);
      expect(vehRepo.getById(assignedVehId)!.status, equals(VehicleStatus.onTrip));
      expect(drvRepo.getById(assignedDrvId)!.status, equals(DriverStatus.onTrip));

      // Upload POD
      vm.uploadPod(
        transportId: outcome.transport.id,
        fileName: 'POD_TEST_SIGNED.pdf',
        fileType: 'PDF',
        fileSize: 400000,
      );
      expect(vm.getTransportById(outcome.transport.id)!.status, equals(TransportStatus.podReceived));
      expect(vm.getTransportById(outcome.transport.id)!.canBeCompleted, isTrue);

      // Complete Transport
      vm.completeTransport(outcome.transport.id);
      expect(vm.getTransportById(outcome.transport.id)!.status, equals(TransportStatus.completed));

      // Vehicle and Driver should now be released back to AVAILABLE!
      expect(vehRepo.getById(assignedVehId)!.status, equals(VehicleStatus.available));
      expect(drvRepo.getById(assignedDrvId)!.status, equals(DriverStatus.available));
    });
  });

  group('Widget Tests', () {
    testWidgets('TransportApp loads and shows FreightOps brand and Operations Dashboard', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: TransportApp(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('FreightOps'), findsWidgets);
      expect(find.text('Operations Dashboard'), findsOneWidget);
      expect(find.text('Total Transport'), findsOneWidget);
      expect(find.text('Fleet Availability Dashboard'), findsOneWidget);
    });
  });
}
