import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/container_size.dart';
import '../../../core/enums/shipment_type.dart';
import '../../../core/enums/transport_status.dart';
import '../../../core/services/assignment_service.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/utils/id_generator.dart';
import '../data/transport_repository.dart';
import '../domain/activity_log.dart';
import '../domain/notification_log.dart';
import '../domain/pod_document.dart';
import '../domain/transport_allocation.dart';
import '../domain/transport_model.dart';
import '../../drivers/presentation/driver_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';

class TransportState {
  final List<Transport> transports;
  final List<ActivityLog> activityLogs;
  final List<NotificationLog> notificationLogs;
  final String searchQuery;
  final TransportStatus? statusFilter;
  final ShipmentType? shipmentTypeFilter;
  final ContainerSize? containerSizeFilter;
  final String? partyFilter;
  final String? vehicleFilter;
  final DateTime? dateFilter;
  final bool isLoading;
  final String? errorMessage;

  const TransportState({
    this.transports = const [],
    this.activityLogs = const [],
    this.notificationLogs = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.shipmentTypeFilter,
    this.containerSizeFilter,
    this.partyFilter,
    this.vehicleFilter,
    this.dateFilter,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Returns activity logs for a specific transport, sorted newest first.
  List<ActivityLog> getActivityLogsFor(String transportId) {
    return activityLogs
        .where((log) => log.transportId == transportId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Returns notification logs for a specific transport, sorted newest first.
  List<NotificationLog> getNotificationLogsFor(String transportId) {
    return notificationLogs
        .where((n) => n.transportId == transportId)
        .toList()
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
  }

  List<Transport> get filteredTransports {
    return transports.where((t) {
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchId = t.id.toLowerCase().contains(q);
        final matchBk = t.bookingNumber.toLowerCase().contains(q);
        final matchCntr = t.containerNumber.toLowerCase().contains(q);
        final matchParty = t.partyName.toLowerCase().contains(q);
        final matchVeh = t.vehicleNumber?.toLowerCase().contains(q) ?? false;
        final matchDrv = t.driverName?.toLowerCase().contains(q) ?? false;
        if (!matchId && !matchBk && !matchCntr && !matchParty && !matchVeh && !matchDrv) {
          return false;
        }
      }
      if (statusFilter != null && t.status != statusFilter) {
        return false;
      }
      if (shipmentTypeFilter != null && t.shipmentType != shipmentTypeFilter) {
        return false;
      }
      if (containerSizeFilter != null && t.containerSize != containerSizeFilter) {
        return false;
      }
      if (partyFilter != null && partyFilter!.isNotEmpty && t.partyId != partyFilter && t.partyName != partyFilter) {
        return false;
      }
      if (vehicleFilter != null && vehicleFilter!.isNotEmpty && t.vehicleNumber != vehicleFilter && t.vehicleId != vehicleFilter) {
        return false;
      }
      if (dateFilter != null) {
        final sameDay = t.createdAt.year == dateFilter!.year &&
            t.createdAt.month == dateFilter!.month &&
            t.createdAt.day == dateFilter!.day;
        if (!sameDay) return false;
      }
      return true;
    }).toList();
  }

  TransportState copyWith({
    List<Transport>? transports,
    List<ActivityLog>? activityLogs,
    List<NotificationLog>? notificationLogs,
    String? searchQuery,
    TransportStatus? statusFilter,
    ShipmentType? shipmentTypeFilter,
    ContainerSize? containerSizeFilter,
    String? partyFilter,
    String? vehicleFilter,
    DateTime? dateFilter,
    bool? isLoading,
    String? errorMessage,
    bool clearStatusFilter = false,
    bool clearShipmentTypeFilter = false,
    bool clearContainerSizeFilter = false,
    bool clearPartyFilter = false,
    bool clearVehicleFilter = false,
    bool clearDateFilter = false,
  }) {
    return TransportState(
      transports: transports ?? this.transports,
      activityLogs: activityLogs ?? this.activityLogs,
      notificationLogs: notificationLogs ?? this.notificationLogs,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      shipmentTypeFilter: clearShipmentTypeFilter ? null : (shipmentTypeFilter ?? this.shipmentTypeFilter),
      containerSizeFilter: clearContainerSizeFilter ? null : (containerSizeFilter ?? this.containerSizeFilter),
      partyFilter: clearPartyFilter ? null : (partyFilter ?? this.partyFilter),
      vehicleFilter: clearVehicleFilter ? null : (vehicleFilter ?? this.vehicleFilter),
      dateFilter: clearDateFilter ? null : (dateFilter ?? this.dateFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BookingCreationOutcome {
  final Transport transport;
  final bool wasAssigned;
  final String? failureReason;
  final NotificationLog? notificationLog;

  const BookingCreationOutcome({
    required this.transport,
    required this.wasAssigned,
    this.failureReason,
    this.notificationLog,
  });
}

class TransportViewModel extends StateNotifier<TransportState> {
  final TransportRepository _repo;
  final AssignmentService _assignmentService;
  final void Function() _autoSync;
  final void Function()? onFleetChanged;

  TransportViewModel(
    this._repo,
    this._assignmentService,
    this._autoSync, {
    this.onFleetChanged,
  }) : super(const TransportState()) {
    _refreshState();
    if (_repo is ProductionTransportRepository) {
      _repo.initialized.then((_) {
        if (mounted) _refreshState();
      });
    }
  }

  void _refreshState() {
    final all = _repo.getAll();
    IdGenerator.syncTransportCounter(all.map((t) => t.id));
    state = state.copyWith(
      transports: all,
      activityLogs: List<ActivityLog>.from(_repo.getAllActivityLogs()),
      notificationLogs: List<NotificationLog>.from(_repo.getAllNotificationLogs()),
    );
  }

  void loadTransports() {
    _refreshState();
  }

  void setSearchQuery(String query) => state = state.copyWith(searchQuery: query);
  void setStatusFilter(TransportStatus? status) =>
      state = status == null ? state.copyWith(clearStatusFilter: true) : state.copyWith(statusFilter: status);
  void setShipmentTypeFilter(ShipmentType? type) =>
      state = type == null ? state.copyWith(clearShipmentTypeFilter: true) : state.copyWith(shipmentTypeFilter: type);
  void setContainerSizeFilter(ContainerSize? size) =>
      state = size == null ? state.copyWith(clearContainerSizeFilter: true) : state.copyWith(containerSizeFilter: size);
  void setPartyFilter(String? party) =>
      state = party == null ? state.copyWith(clearPartyFilter: true) : state.copyWith(partyFilter: party);
  void setVehicleFilter(String? vehicle) =>
      state = vehicle == null ? state.copyWith(clearVehicleFilter: true) : state.copyWith(vehicleFilter: vehicle);
  void setDateFilter(DateTime? date) =>
      state = date == null ? state.copyWith(clearDateFilter: true) : state.copyWith(dateFilter: date);

  Transport? getTransportById(String id) => _repo.getById(id);

  /// Create booking — vehicle/driver assignment is optional (supplied as slots).
  /// Pass an empty list to create a booking without any assigned fleet.
  Future<BookingCreationOutcome> createBooking({
    required ContainerSize containerSize,
    required ShipmentType shipmentType,
    required String containerNumber,
    required String sealNumber,
    required String partyId,
    required String partyName,
    required String partyMobile,
    required String bookingPartyId,
    required String bookingPartyName,
    required String shippingLineId,
    required String shippingLineName,
    required String bookingNumber,
    required String fromLocationId,
    required String fromLocationName,
    required String toLocationId,
    required String toLocationName,
    required String portCfsId,
    required String portCfsName,
    List<TransportAllocation> allocations = const [],
    String? vehicleId,
    String? vehicleNumber,
    String? driverId,
    String? driverName,
    String? driverMobile,
  }) async {
    final now = DateTime.now();
    IdGenerator.syncTransportCounter(_repo.getAll().map((t) => t.id));
    final transportId = IdGenerator.generateTransportId();

    // Map allocations to bind to this transport ID
    final resolvedAllocations = allocations.map((a) {
      return a.copyWith(transportId: transportId);
    }).toList();

    if (resolvedAllocations.isEmpty && vehicleId != null && vehicleNumber != null) {
      resolvedAllocations.add(
        TransportAllocation(
          id: 'alloc-${now.millisecondsSinceEpoch}-0',
          transportId: transportId,
          slotIndex: 0,
          vehicleId: vehicleId,
          vehicleNumber: vehicleNumber,
          driverId: driverId,
          driverName: driverName,
          driverMobile: driverMobile,
          assignedAt: now,
        ),
      );
    }

    // Status: NEW if no allocations, DRIVER_ASSIGNED if any allotted
    final initialStatus = resolvedAllocations.isNotEmpty
        ? TransportStatus.driverAssigned
        : TransportStatus.bookingCreated;

    // Create the transport WITHOUT pre-embedding allocations.
    // We add allocations one-by-one via _repo.addAllocation below,
    // which correctly handles both in-memory update AND DB persistence for
    // every slot. Pre-embedding caused the alreadyPresent guard in addAllocation
    // to skip DB writes for slots 1+.
    final transport = Transport(
      id: transportId,
      bookingNumber: bookingNumber,
      containerNumber: containerNumber.trim().toUpperCase(),
      sealNumber: sealNumber.trim().toUpperCase(),
      containerSize: containerSize,
      shipmentType: shipmentType,
      partyId: partyId,
      partyName: partyName,
      partyMobile: partyMobile,
      bookingPartyId: bookingPartyId,
      bookingPartyName: bookingPartyName,
      shippingLineId: shippingLineId,
      shippingLineName: shippingLineName,
      fromLocationId: fromLocationId,
      fromLocationName: fromLocationName,
      toLocationId: toLocationId,
      toLocationName: toLocationName,
      portCfsId: portCfsId,
      portCfsName: portCfsName,
      allocations: const [], // intentionally empty; slots added below
      status: initialStatus,
      createdAt: now,
      updatedAt: now,
    );

    _repo.add(transport);

    // Persist each allocation and mark vehicles/drivers ON_TRIP.
    // addAllocation appends to in-memory AND writes to DB for every slot.
    for (final alloc in resolvedAllocations) {
      await _repo.addAllocation(alloc);
      _assignmentService.assignSpecific(
        vehicleId: alloc.vehicleId,
        vehicleNumber: alloc.vehicleNumber,
        driverId: alloc.driverId,
        driverName: alloc.driverName,
        transportId: transportId,
      );
    }

    // Audit logs
    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${now.millisecondsSinceEpoch}-1',
        transportId: transport.id,
        title: 'Booking Created',
        description:
            'Booking $bookingNumber registered${containerNumber.isNotEmpty ? " for container $containerNumber" : ""}',
        timestamp: now,
      ),
    );
    for (final alloc in resolvedAllocations) {
      _repo.addActivityLog(
        ActivityLog(
          id: 'act-${now.millisecondsSinceEpoch}-alloc-${alloc.slotIndex}',
          transportId: transport.id,
          title: 'Vehicle & Driver Assigned (Slot ${alloc.slotIndex + 1})',
          description:
              'Vehicle ${alloc.vehicleNumber}${alloc.driverName != null ? " \u2022 Driver ${alloc.driverName}" : ""}',
          timestamp: now,
        ),
      );
    }

    loadTransports();
    onFleetChanged?.call();
    _autoSync();

    // Return the transport with its final allocations as they now exist in memory
    final persisted = _repo.getById(transportId) ?? transport;
    return BookingCreationOutcome(
      transport: persisted,
      wasAssigned: resolvedAllocations.isNotEmpty,
      notificationLog: null,
    );
  }

  /// Add a new vehicle+driver allocation slot to an existing transport.
  Future<void> addAllocationToTransport({
    required String transportId,
    required String vehicleId,
    required String vehicleNumber,
    String? driverId,
    String? driverName,
    String? driverMobile,
  }) async {
    final transport = _repo.getById(transportId);
    if (transport == null) return;
    if (transport.allocations.length >= 5) return; // max 5 slots

    final slotIndex = transport.allocations.length;
    final allocation = TransportAllocation(
      id: 'alloc-${DateTime.now().millisecondsSinceEpoch}-$transportId-$slotIndex',
      transportId: transportId,
      slotIndex: slotIndex,
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
      driverId: driverId,
      driverName: driverName,
      driverMobile: driverMobile,
      assignedAt: DateTime.now(),
    );

    await _repo.addAllocation(allocation);

    _assignmentService.assignSpecific(
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
      driverId: driverId,
      driverName: driverName,
      transportId: transportId,
    );

    // Update status to DRIVER_ASSIGNED if it was just BOOKING_CREATED
    if (transport.status == TransportStatus.bookingCreated) {
      _repo.updateStatus(transportId, TransportStatus.driverAssigned);
    }

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Vehicle & Driver Assigned (Slot ${slotIndex + 1})',
        description:
            'Vehicle $vehicleNumber${driverName != null ? " • Driver $driverName" : ""}',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    onFleetChanged?.call();
    _autoSync();
  }

  /// Remove a vehicle+driver allocation slot from a transport.
  Future<void> removeAllocationFromTransport({
    required String transportId,
    required String allocationId,
    required String vehicleId,
    String? driverId,
  }) async {
    await _repo.removeAllocation(allocationId);

    // Release vehicle and driver back to AVAILABLE
    _assignmentService.releaseVehicle(vehicleId, transportId: transportId);
    if (driverId != null && driverId.isNotEmpty) {
      _assignmentService.releaseDriver(driverId, transportId: transportId);
    }

    // If no allocations remain, revert to BOOKING_CREATED
    final updated = _repo.getById(transportId);
    if (updated != null && updated.allocations.isEmpty &&
        updated.status == TransportStatus.driverAssigned) {
      _repo.updateStatus(transportId, TransportStatus.bookingCreated);
    }

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Allocation Removed',
        description: 'Vehicle $vehicleId slot removed. Resources released to AVAILABLE.',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    onFleetChanged?.call();
    _autoSync();
  }

  /// Update status sequentially or with an exception
  void updateStatus(String transportId, TransportStatus newStatus, {String? exceptionReason}) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    _repo.updateStatus(transportId, newStatus, exceptionReason: exceptionReason);

    // If cancelled, release vehicle and driver
    if (newStatus == TransportStatus.cancelled) {
      for (final alloc in current.allocations) {
        _assignmentService.releaseVehicle(alloc.vehicleId, transportId: transportId);
        if (alloc.driverId != null && alloc.driverId!.isNotEmpty) {
          _assignmentService.releaseDriver(alloc.driverId, transportId: transportId);
        }
      }
      if (current.vehicleId != null) {
        _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
      }
      if (current.driverId != null) {
        _assignmentService.releaseDriver(current.driverId, transportId: transportId);
      }
      onFleetChanged?.call();
    }

    // If vehicle breakdown, release vehicle so it can be serviced
    if (newStatus == TransportStatus.vehicleBreakdown) {
      for (final alloc in current.allocations) {
        _assignmentService.releaseVehicle(alloc.vehicleId, transportId: transportId);
      }
      if (current.vehicleId != null) {
        _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
      }
      onFleetChanged?.call();
    }

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Status Updated: ${newStatus.label}',
        description: exceptionReason != null && exceptionReason.isNotEmpty
            ? 'Reason: $exceptionReason'
            : 'Transport transitioned to ${newStatus.label}',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    _autoSync();
  }

  /// Upload POD
  void uploadPod({
    required String transportId,
    required String fileName,
    required String fileType,
    required int fileSize,
  }) {
    final pod = PodDocument(
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      uploadedAt: DateTime.now(),
    );

    _repo.uploadPod(transportId, pod);

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'POD Uploaded',
        description: 'Proof of Delivery document $fileName attached. Ready for completion.',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    _autoSync();
  }

  /// Delete POD
  void deletePod(String transportId) {
    _repo.deletePod(transportId);
    loadTransports();
    _autoSync();
  }

  /// Complete transport & release resources
  void completeTransport(String transportId) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    _repo.completeTransport(transportId);

    // Release vehicle & driver back to AVAILABLE for all allocations
    for (final alloc in current.allocations) {
      _assignmentService.releaseVehicle(alloc.vehicleId, transportId: transportId);
      if (alloc.driverId != null && alloc.driverId!.isNotEmpty) {
        _assignmentService.releaseDriver(alloc.driverId, transportId: transportId);
      }
    }
    if (current.vehicleId != null) {
      _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
    }
    if (current.driverId != null) {
      _assignmentService.releaseDriver(current.driverId, transportId: transportId);
    }

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Transport Completed',
        description: 'Trip finished successfully. All assigned vehicles and drivers marked AVAILABLE.',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    onFleetChanged?.call();
    _autoSync();
  }

  /// Reassign vehicle manually
  void reassignVehicle(String transportId, String newVehicleId) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    final newVeh = _assignmentService.reassignVehicle(
      transportId: transportId,
      oldVehicleId: current.vehicleId,
      newVehicleId: newVehicleId,
      driverId: current.driverId,
      driverName: current.driverName,
    );

    if (newVeh != null) {
      final updated = current.copyWith(
        vehicleId: newVeh.id,
        vehicleNumber: newVeh.vehicleNumber,
        status: current.status == TransportStatus.vehiclePending || current.status == TransportStatus.vehicleBreakdown
            ? TransportStatus.vehicleAssigned
            : current.status,
        clearException: true,
      );
      _repo.update(updated);

      _repo.addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'Vehicle Reassigned',
          description: 'Replaced with ${newVeh.vehicleNumber} (${newVeh.vehicleType})',
          timestamp: DateTime.now(),
        ),
      );

      loadTransports();
      onFleetChanged?.call();
      _autoSync();
    }
  }

  /// Reassign driver manually
  void reassignDriver(String transportId, String newDriverId) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    final newDrv = _assignmentService.reassignDriver(
      transportId: transportId,
      oldDriverId: current.driverId,
      newDriverId: newDriverId,
      vehicleId: current.vehicleId,
      vehicleNumber: current.vehicleNumber,
    );

    if (newDrv != null) {
      final updated = current.copyWith(
        driverId: newDrv.id,
        driverName: newDrv.name,
        driverMobile: newDrv.mobileNumber,
      );
      _repo.update(updated);

      _repo.addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'Driver Reassigned',
          description: 'Assigned to ${newDrv.name} (${newDrv.mobileNumber})',
          timestamp: DateTime.now(),
        ),
      );

      loadTransports();
      onFleetChanged?.call();
      _autoSync();
    }
  }

  /// Update container number and seal number after booking
  void updateContainerAndSeal({
    required String transportId,
    required String containerNumber,
    required String sealNumber,
  }) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    final updated = current.copyWith(
      containerNumber: containerNumber.trim().toUpperCase(),
      sealNumber: sealNumber.trim().toUpperCase(),
    );
    _repo.update(updated);

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Container Details Updated',
        description:
            'Container No: ${containerNumber.trim().toUpperCase().isNotEmpty ? containerNumber.trim().toUpperCase() : "—"}  •  Seal No: ${sealNumber.trim().toUpperCase().isNotEmpty ? sealNumber.trim().toUpperCase() : "—"}',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
    _autoSync();
  }

  /// Delete a transport operation
  void deleteTransport(String id) {
    final current = _repo.getById(id);
    if (current != null) {
      for (final alloc in current.allocations) {
        _assignmentService.releaseVehicle(alloc.vehicleId, transportId: id);
        if (alloc.driverId != null && alloc.driverId!.isNotEmpty) {
          _assignmentService.releaseDriver(alloc.driverId, transportId: id);
        }
      }
      if (current.vehicleId != null) {
        _assignmentService.releaseVehicle(current.vehicleId, transportId: id);
      }
      if (current.driverId != null) {
        _assignmentService.releaseDriver(current.driverId, transportId: id);
      }
    }
    _repo.delete(id);
    loadTransports();
    onFleetChanged?.call();
    _autoSync();
  }
}

final transportViewModelProvider =
    StateNotifierProvider<TransportViewModel, TransportState>((ref) {
  final repo = ref.watch(transportRepositoryProvider);
  final assignmentService = ref.watch(assignmentServiceProvider);
  final sync = ref.read(syncEngineProvider.notifier);
  return TransportViewModel(
    repo,
    assignmentService,
    () => sync.triggerAutoSync(),
    onFleetChanged: () {
      ref.read(vehicleViewModelProvider.notifier).loadVehicles();
      ref.read(driverViewModelProvider.notifier).loadDrivers();
    },
  );
});
