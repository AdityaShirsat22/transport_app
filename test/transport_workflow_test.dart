import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/core/enums/container_size.dart';
import 'package:transport_app/core/enums/driver_status.dart';
import 'package:transport_app/core/enums/shipment_type.dart';
import 'package:transport_app/core/enums/transport_status.dart';
import 'package:transport_app/core/enums/vehicle_status.dart';
import 'package:transport_app/features/drivers/data/driver_repository.dart';
import 'package:transport_app/features/drivers/domain/driver_model.dart';
import 'package:transport_app/features/transport/data/transport_repository.dart';
import 'package:transport_app/features/transport/presentation/transport_view_model.dart';
import 'package:transport_app/features/vehicles/data/vehicle_repository.dart';
import 'package:transport_app/features/vehicles/domain/vehicle_model.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    // Trigger repo initialization
    final vRepo = container.read(vehicleRepositoryProvider);
    final dRepo = container.read(driverRepositoryProvider);
    final tRepo = container.read(transportRepositoryProvider);
    await vRepo.reloadFromDatabase();
    await dRepo.reloadFromDatabase();
    await tRepo.reloadFromDatabase();

    final now = DateTime(2026, 1, 1);
    vRepo.add(
      Vehicle(
        id: 'test-wf-veh-1',
        vehicleNumber: 'MH-12-AB-9999',
        vehicleType: 'Trailer 40FT',
        capacity: '40 FT',
        status: VehicleStatus.available,
        createdAt: now,
      ),
    );
    dRepo.add(
      Driver(
        id: 'test-wf-drv-1',
        name: 'Ganesh Shinde',
        mobileNumber: '9820099887',
        status: DriverStatus.available,
        createdAt: now,
      ),
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('Transport Workflow End-to-End Tests', () {
    test('Create Booking -> Manual Assignment -> POD Upload -> Complete -> Resources Released', () async {
      final vm = container.read(transportViewModelProvider.notifier);

      final outcome = await vm.createBooking(
        containerSize: ContainerSize.size40Ft,
        shipmentType: ShipmentType.export,
        containerNumber: 'TEST9912345',
        sealNumber: 'SL-99991',
        partyId: 'pty-1',
        partyName: 'ABC Logistics',
        partyMobile: '9822001122',
        bookingPartyId: 'pty-1',
        bookingPartyName: 'ABC Logistics',
        shippingLineId: 'shp-1',
        shippingLineName: 'MSC',
        bookingNumber: 'BK-TEST-001',
        fromLocationId: 'loc-1',
        fromLocationName: 'Pune Factory',
        toLocationId: 'loc-2',
        toLocationName: 'JNPT Port',
        portCfsId: 'pc-1',
        portCfsName: 'JNPT CFS',
        vehicleId: 'test-wf-veh-1',
        vehicleNumber: 'MH-12-AB-9999',
        driverId: 'test-wf-drv-1',
        driverName: 'Ganesh Shinde',
        driverMobile: '9820099887',
      );

      expect(outcome.wasAssigned, isTrue);
      final transportId = outcome.transport.id;
      final assignedVehId = outcome.transport.vehicleId!;
      final assignedDrvId = outcome.transport.driverId!;

      // Cannot be completed yet (no POD)
      final current = vm.getTransportById(transportId);
      expect(current!.canBeCompleted, isFalse);

      // Upload POD
      vm.uploadPod(
        transportId: transportId,
        fileName: 'POD_TEST_SIGNED.pdf',
        fileType: 'PDF',
        fileSize: 256000,
      );

      final withPod = vm.getTransportById(transportId);
      expect(withPod!.status, equals(TransportStatus.podReceived));
      expect(withPod.canBeCompleted, isTrue);

      // Complete Transport
      vm.completeTransport(transportId);

      final completed = vm.getTransportById(transportId);
      expect(completed!.status, equals(TransportStatus.completed));
      expect(completed.completionDate, isNotNull);

      // Vehicle & Driver IDs recorded correctly
      expect(assignedVehId, equals('test-wf-veh-1'));
      expect(assignedDrvId, equals('test-wf-drv-1'));
    });

    test('Cancellation keeps transport record intact', () async {
      final vm = container.read(transportViewModelProvider.notifier);

      final outcome = await vm.createBooking(
        containerSize: ContainerSize.size20Ft,
        shipmentType: ShipmentType.import,
        containerNumber: 'CNTR2233445',
        sealNumber: 'SL-77665',
        partyId: 'pty-1',
        partyName: 'ABC Logistics',
        partyMobile: '9822001122',
        bookingPartyId: 'pty-1',
        bookingPartyName: 'ABC Logistics',
        shippingLineId: 'shp-1',
        shippingLineName: 'Maersk',
        bookingNumber: 'BK-CANCEL-001',
        fromLocationId: 'loc-1',
        fromLocationName: 'Mumbai CFS',
        toLocationId: 'loc-2',
        toLocationName: 'Nashik Plant',
        portCfsId: 'pc-1',
        portCfsName: 'Mumbai Port',
        vehicleId: 'test-wf-veh-1',
        vehicleNumber: 'MH-12-AB-9999',
        driverId: 'test-wf-drv-1',
        driverName: 'Ganesh Shinde',
        driverMobile: '9820099887',
      );

      final transportId = outcome.transport.id;

      // Cancel transport
      vm.updateStatus(transportId, TransportStatus.cancelled, exceptionReason: 'Customer requested cancellation');

      final cancelled = vm.getTransportById(transportId);
      expect(cancelled!.status, equals(TransportStatus.cancelled));
      expect(cancelled.vehicleId, equals('test-wf-veh-1'));
      expect(cancelled.driverId, equals('test-wf-drv-1'));
    });

    test('Create Booking with optional container number and custom seal number left blank', () async {
      final vm = container.read(transportViewModelProvider.notifier);

      final outcome = await vm.createBooking(
        containerSize: ContainerSize.size40Ft,
        shipmentType: ShipmentType.export,
        containerNumber: '',
        sealNumber: '',
        partyId: 'pty-test',
        partyName: 'XYZ Exporters',
        partyMobile: '9822003344',
        bookingPartyId: 'pty-test',
        bookingPartyName: 'XYZ Exporters',
        shippingLineId: 'shp-1',
        shippingLineName: 'Maersk',
        bookingNumber: 'BK-BLANK-001',
        fromLocationId: 'loc-1',
        fromLocationName: 'Factory',
        toLocationId: 'loc-2',
        toLocationName: 'Port',
        portCfsId: 'pc-1',
        portCfsName: 'CFS 1',
        vehicleId: 'test-wf-veh-1',
        vehicleNumber: 'MH-12-AB-9999',
        driverId: 'test-wf-drv-1',
        driverName: 'Ganesh Shinde',
        driverMobile: '9820099887',
      );

      expect(outcome.transport.id, isNotEmpty);
      expect(outcome.transport.containerNumber, isEmpty);
      expect(outcome.transport.sealNumber, isEmpty);
      expect(outcome.transport.bookingNumber, equals('BK-BLANK-001'));
      expect(outcome.wasAssigned, isTrue);
    });

    test('Delete Transport Booking releases vehicle & driver and removes from list', () async {
      final vm = container.read(transportViewModelProvider.notifier);
      final vRepo = container.read(vehicleRepositoryProvider);
      final dRepo = container.read(driverRepositoryProvider);

      final outcome = await vm.createBooking(
        containerSize: ContainerSize.size40Ft,
        shipmentType: ShipmentType.export,
        containerNumber: 'DELT1234567',
        sealNumber: 'SL-DEL-1',
        partyId: 'pty-1',
        partyName: 'ABC Logistics',
        partyMobile: '9822001122',
        bookingPartyId: 'pty-1',
        bookingPartyName: 'ABC Logistics',
        shippingLineId: 'shp-1',
        shippingLineName: 'MSC',
        bookingNumber: 'BK-DELETE-001',
        fromLocationId: 'loc-1',
        fromLocationName: 'Pune Factory',
        toLocationId: 'loc-2',
        toLocationName: 'JNPT Port',
        portCfsId: 'pc-1',
        portCfsName: 'JNPT CFS',
        vehicleId: 'test-wf-veh-1',
        vehicleNumber: 'MH-12-AB-9999',
        driverId: 'test-wf-drv-1',
        driverName: 'Ganesh Shinde',
        driverMobile: '9820099887',
      );

      final transportId = outcome.transport.id;
      expect(container.read(transportViewModelProvider).transports.any((t) => t.id == transportId), isTrue);
      expect(vRepo.getById('test-wf-veh-1')!.status, equals(VehicleStatus.onTrip));
      expect(dRepo.getById('test-wf-drv-1')!.status, equals(DriverStatus.onTrip));

      // Now Delete Transport Operation
      vm.deleteTransport(transportId);

      // Verify removed from list
      expect(container.read(transportViewModelProvider).transports.any((t) => t.id == transportId), isFalse);

      // Verify vehicle and driver released back to available
      expect(vRepo.getById('test-wf-veh-1')!.status, equals(VehicleStatus.available));
      expect(dRepo.getById('test-wf-drv-1')!.status, equals(DriverStatus.available));
    });
  });
}
