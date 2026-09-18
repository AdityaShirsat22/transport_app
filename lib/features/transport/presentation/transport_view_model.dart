import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/container_size.dart';
import '../../../core/enums/shipment_type.dart';
import '../../../core/enums/transport_status.dart';
import '../../../core/services/assignment_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/id_generator.dart';
import '../data/transport_repository.dart';
import '../domain/activity_log.dart';
import '../domain/notification_log.dart';
import '../domain/pod_document.dart';
import '../domain/transport_model.dart';

class TransportState {
  final List<Transport> transports;
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
  final NotificationService _notificationService;
  TransportViewModel(
    this._repo,
    this._assignmentService,
    this._notificationService,
  ) : super(const TransportState()) {
    state = state.copyWith(transports: _repo.getAll());
  }

  void loadTransports() {
    state = state.copyWith(transports: _repo.getAll());
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
  List<ActivityLog> getActivityLogs(String transportId) => _repo.getActivityLogs(transportId);
  List<NotificationLog> getNotificationLogs(String transportId) => _repo.getNotificationLogs(transportId);

  /// Create booking with manually selected vehicle and driver
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
    required String vehicleId,
    required String vehicleNumber,
    required String driverId,
    required String driverName,
    required String driverMobile,
  }) async {
    final now = DateTime.now();
    final transportId = IdGenerator.generateTransportId();

    // Create transport with manually provided vehicle & driver
    final transport = Transport(
      id: transportId,
      bookingNumber: bookingNumber,
      containerNumber: containerNumber.trim().toUpperCase(),
      sealNumber: sealNumber.trim().toUpperCase(),
      containerSize: containerSize,
      shipmentType: shipmentType,
      partyId: partyId,
      partyName: partyName,
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
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
      driverId: driverId,
      driverName: driverName,
      driverMobile: driverMobile,
      status: TransportStatus.driverAssigned,
      createdAt: now,
      updatedAt: now,
    );

    _repo.add(transport);

    _assignmentService.assignSpecific(
      vehicleId: vehicleId,
      vehicleNumber: vehicleNumber,
      driverId: driverId,
      driverName: driverName,
      transportId: transportId,
    );

    // Audit logs
    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}-1',
        transportId: transport.id,
        title: 'Booking Created',
        description:
            'Booking $bookingNumber registered${containerNumber.isNotEmpty ? " for container $containerNumber" : ""}',
        timestamp: now,
      ),
    );
    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}-2',
        transportId: transport.id,
        title: 'Vehicle Assigned',
        description: 'Vehicle $vehicleNumber assigned manually',
        timestamp: now,
      ),
    );
    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}-3',
        transportId: transport.id,
        title: 'Driver Assigned',
        description: 'Driver $driverName ($driverMobile) assigned manually',
        timestamp: now,
      ),
    );

    loadTransports();

    return BookingCreationOutcome(
      transport: transport,
      wasAssigned: true,
      notificationLog: null,
    );
  }

  /// Update status sequentially or with an exception
  void updateStatus(String transportId, TransportStatus newStatus, {String? exceptionReason}) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    _repo.updateStatus(transportId, newStatus, exceptionReason: exceptionReason);

    // If cancelled, release vehicle and driver
    if (newStatus == TransportStatus.cancelled) {
      _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
      _assignmentService.releaseDriver(current.driverId, transportId: transportId);
    }

    // If vehicle breakdown, release vehicle so it can be serviced
    if (newStatus == TransportStatus.vehicleBreakdown) {
      _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
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
  }

  /// Complete transport & release resources
  void completeTransport(String transportId) {
    final current = _repo.getById(transportId);
    if (current == null) return;

    _repo.completeTransport(transportId);

    // Release vehicle & driver back to AVAILABLE
    _assignmentService.releaseVehicle(current.vehicleId, transportId: transportId);
    _assignmentService.releaseDriver(current.driverId, transportId: transportId);

    _repo.addActivityLog(
      ActivityLog(
        id: 'act-${DateTime.now().millisecondsSinceEpoch}',
        transportId: transportId,
        title: 'Transport Completed',
        description: 'Trip finished successfully. Vehicle ${current.vehicleNumber ?? ''} & Driver ${current.driverName ?? ''} marked AVAILABLE.',
        timestamp: DateTime.now(),
      ),
    );

    loadTransports();
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
    }
  }

  /// Delete a transport operation
  void deleteTransport(String id) {
    final current = _repo.getById(id);
    if (current != null) {
      if (current.vehicleId != null) {
        _assignmentService.releaseVehicle(current.vehicleId, transportId: id);
      }
      if (current.driverId != null) {
        _assignmentService.releaseDriver(current.driverId, transportId: id);
      }
    }
    _repo.delete(id);
    loadTransports();
  }
}

final transportViewModelProvider =
    StateNotifierProvider<TransportViewModel, TransportState>((ref) {
  final repo = ref.watch(transportRepositoryProvider);
  final assignmentService = ref.watch(assignmentServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return TransportViewModel(
    repo,
    assignmentService,
    notificationService,
  );
});
