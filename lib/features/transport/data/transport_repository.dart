import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/container_size.dart';
import '../../../core/enums/shipment_type.dart';
import '../../../core/enums/transport_status.dart';
import '../domain/activity_log.dart';
import '../domain/notification_log.dart';
import '../domain/pod_document.dart';
import '../domain/transport_allocation.dart';
import '../domain/transport_model.dart';

abstract class TransportRepository {
  List<Transport> getAll();
  Transport? getById(String id);
  Transport? getByBookingNumber(String bookingNumber);
  Transport? getActiveByContainerNumber(String containerNumber);
  void add(Transport transport);
  void update(Transport transport);
  void updateStatus(String transportId, TransportStatus newStatus, {String? exceptionReason, String? remarks, String changedBy = 'Super Admin'});
  void uploadPod(String transportId, PodDocument pod);
  void deletePod(String transportId);
  void completeTransport(String transportId);
  void delete(String id);

  // Activity logs
  List<ActivityLog> getAllActivityLogs();
  List<ActivityLog> getActivityLogs(String transportId);
  void addActivityLog(ActivityLog log);

  // Notifications
  List<NotificationLog> getAllNotificationLogs();
  List<NotificationLog> getNotificationLogs(String transportId);
  void addNotificationLog(NotificationLog log);

  // Assignments history
  Future<void> recordVehicleAssignment({required String transportId, required String vehicleId, String assignedBy = 'Super Admin'});
  Future<void> releaseVehicleAssignment({required String transportId, required String vehicleId});
  Future<void> recordDriverAssignment({required String transportId, required String driverId, String assignedBy = 'Super Admin'});
  Future<void> releaseDriverAssignment({required String transportId, required String driverId});

  // Allocations (multi-vehicle/driver per booking)
  Future<void> addAllocation(TransportAllocation allocation);
  Future<void> removeAllocation(String allocationId);

  Future<void> reloadFromDatabase();
}

class ProductionTransportRepository implements TransportRepository {
  final AppDatabase _db;
  final List<Transport> _transports = [];
  final List<ActivityLog> _activityLogs = [];
  final List<NotificationLog> _notificationLogs = [];
  // In-memory allocation list keyed by transportId
  final Map<String, List<TransportAllocation>> _allocationsMap = {};
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionTransportRepository(this._db) {
    _init();
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
      final tRows = await (_db.select(_db.localTransports)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      final pRows = await _db.select(_db.localPodDocuments).get();
      final podMap = <String, PodDocument>{};
      for (final p in pRows) {
        podMap[p.transportId] = PodDocument(
          fileName: p.fileName,
          fileType: p.fileType,
          fileSize: p.fileSize.toInt(),
          uploadedBy: p.uploadedBy,
          uploadedAt: p.uploadedAt,
          fileUrl: p.fileUrl,
        );
      }

      if (tRows.isNotEmpty) {
        // Load all allocations grouped by transportId
        _allocationsMap.clear();
        try {
          final allocRows = await (_db.select(_db.localTransportAllocations)
                ..orderBy([(a) => OrderingTerm.asc(a.slotIndex)]))
              .get();
          for (final a in allocRows) {
            _allocationsMap.putIfAbsent(a.transportId, () => []).add(
              TransportAllocation(
                id: a.id,
                transportId: a.transportId,
                slotIndex: a.slotIndex,
                vehicleId: a.vehicleId,
                vehicleNumber: a.vehicleNumber,
                driverId: a.driverId,
                driverName: a.driverName,
                driverMobile: a.driverMobile,
                assignedAt: a.assignedAt,
              ),
            );
          }
        } catch (_) {}

        _transports.clear();
        for (final row in tRows) {
          _transports.add(
            Transport(
              id: row.id,
              bookingNumber: row.bookingNumber,
              containerNumber: row.containerNumber,
              sealNumber: row.sealNumber,
              containerSize: ContainerSize.fromCode(row.containerSize),
              shipmentType: ShipmentType.fromCode(row.shipmentType),
              partyId: row.partyId,
              partyName: row.partyName,
              partyMobile: row.partyMobile,
              bookingPartyId: row.bookingPartyId,
              bookingPartyName: row.bookingPartyName,
              shippingLineId: row.shippingLineId,
              shippingLineName: row.shippingLineName,
              fromLocationId: row.fromLocationId,
              fromLocationName: row.fromLocationName,
              toLocationId: row.toLocationId,
              toLocationName: row.toLocationName,
              portCfsId: row.portCfsId,
              portCfsName: row.portCfsName,
              allocations: _allocationsMap[row.id] ?? const [],
              status: TransportStatus.fromCode(row.status),
              exceptionReason: row.exceptionReason,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
              completionDate: row.completedAt,
              pod: podMap[row.id],
            ),
          );
        }
      }

      // Load activity logs
      final aRows = await (_db.select(_db.localActivityLogs)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
      if (aRows.isNotEmpty) {
        _activityLogs.clear();
        for (final a in aRows) {
          _activityLogs.add(
            ActivityLog(
              id: a.id,
              transportId: a.transportId ?? '',
              title: a.action,
              description: a.description,
              performedBy: a.userId ?? 'Super Admin',
              timestamp: a.createdAt,
            ),
          );
        }
      }

      // Load notification logs
      final nRows = await (_db.select(_db.localNotificationLogs)
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
          .get();
      if (nRows.isNotEmpty) {
        _notificationLogs.clear();
        for (final n in nRows) {
          _notificationLogs.add(
            NotificationLog(
              id: n.id,
              transportId: n.transportId,
              recipientName: n.recipientName,
              recipientMobile: n.recipientMobile,
              channel: n.channel,
              messageBody: n.messageBody,
              status: n.status,
              sentAt: n.sentAt,
            ),
          );
        }
      }
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  List<Transport> getAll() => List.unmodifiable(_transports);

  @override
  Transport? getById(String id) {
    try {
      return _transports.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Transport? getByBookingNumber(String bookingNumber) {
    try {
      return _transports.firstWhere(
        (t) => t.bookingNumber.toLowerCase() == bookingNumber.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Transport? getActiveByContainerNumber(String containerNumber) {
    if (containerNumber.trim().isEmpty) return null;
    try {
      return _transports.firstWhere(
        (t) =>
            t.containerNumber.toLowerCase() == containerNumber.trim().toLowerCase() &&
            t.status.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Transport transport) {
    _transports.insert(0, transport);
    _persistTransportToDb(transport);
    _enqueueSyncTransport(transport, 'CREATE');

    // Status history
    _recordStatusHistory(transport.id, transport.status.code, 'Booking Created', 'Super Admin');
    // Note: activity log is added by the ViewModel after this call, with more detail
  }

  @override
  void update(Transport transport) {
    final index = _transports.indexWhere((t) => t.id == transport.id);
    if (index != -1) {
      _transports[index] = transport;
      _persistTransportToDb(transport);
      _enqueueSyncTransport(transport, 'UPDATE');
    }
  }

  @override
  void updateStatus(
    String transportId,
    TransportStatus newStatus, {
    String? exceptionReason,
    String? remarks,
    String changedBy = 'Super Admin',
  }) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      final now = DateTime.now();
      final updated = current.copyWith(
        status: newStatus,
        updatedAt: now,
        exceptionReason: exceptionReason,
      );
      _transports[index] = updated;
      _persistTransportToDb(updated);
      _enqueueSyncTransport(updated, 'UPDATE');

      _recordStatusHistory(transportId, newStatus.code, remarks ?? newStatus.label, changedBy);

      addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'Status Updated: ${newStatus.label}',
          description: remarks ?? 'Transport status changed to ${newStatus.label}',
          timestamp: now,
        ),
      );
    }
  }

  @override
  void uploadPod(String transportId, PodDocument pod) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      final now = DateTime.now();
      final updated = current.copyWith(
        pod: pod,
        updatedAt: now,
      );
      _transports[index] = updated;
      _persistTransportToDb(updated);
      _enqueueSyncTransport(updated, 'UPDATE');

      // Persist POD metadata
      _persistPodToDb(transportId, pod);

      _recordStatusHistory(transportId, current.status.code, 'POD document attached: ${pod.fileName}', pod.uploadedBy);

      addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'POD Attached',
          description: 'Proof of Delivery ${pod.fileName} attached manually',
          timestamp: now,
        ),
      );
    }
  }

  @override
  void deletePod(String transportId) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      final currentPodName = current.pod?.fileName ?? 'POD Document';
      final now = DateTime.now();

      final updated = current.copyWith(
        clearPod: true,
        updatedAt: now,
      );
      _transports[index] = updated;
      _persistTransportToDb(updated);
      _enqueueSyncTransport(updated, 'UPDATE');

      _deletePodFromDb(transportId);

      _recordStatusHistory(transportId, current.status.code, 'POD removed ($currentPodName)', 'Super Admin');

      addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'POD Deleted',
          description: 'Proof of Delivery ($currentPodName) was removed.',
          timestamp: now,
        ),
      );
    }
  }

  @override
  void completeTransport(String transportId) {
    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      final now = DateTime.now();
      final updated = current.copyWith(
        status: TransportStatus.completed,
        completionDate: now,
        updatedAt: now,
      );
      _transports[index] = updated;
      _persistTransportToDb(updated);
      _enqueueSyncTransport(updated, 'UPDATE');

      if (current.vehicleId != null) {
        releaseVehicleAssignment(transportId: transportId, vehicleId: current.vehicleId!);
      }
      if (current.driverId != null) {
        releaseDriverAssignment(transportId: transportId, driverId: current.driverId!);
      }

      _recordStatusHistory(transportId, 'COMPLETED', 'Transport successfully completed', 'Super Admin');

      addActivityLog(
        ActivityLog(
          id: 'act-${DateTime.now().millisecondsSinceEpoch}',
          transportId: transportId,
          title: 'Transport Completed',
          description: 'Shipment delivered and verified. Assigned vehicle and driver released.',
          timestamp: now,
        ),
      );
    }
  }

  @override
  void delete(String id) {
    final index = _transports.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _transports[index];
      for (final alloc in current.allocations) {
        releaseVehicleAssignment(transportId: id, vehicleId: alloc.vehicleId);
        if (alloc.driverId != null) {
          releaseDriverAssignment(transportId: id, driverId: alloc.driverId!);
        }
      }
      if (current.vehicleId != null) {
        releaseVehicleAssignment(transportId: id, vehicleId: current.vehicleId!);
      }
      if (current.driverId != null) {
        releaseDriverAssignment(transportId: id, driverId: current.driverId!);
      }
      _transports.removeAt(index);
      _deleteTransportFromDb(id);
      _enqueueSyncTransportDelete(id);
    }
  }

  Future<void> _deleteTransportFromDb(String id) async {
    try {
      await (_db.delete(_db.localTransports)..where((t) => t.id.equals(id))).go();
      await (_db.delete(_db.localTransportStatusHistory)..where((t) => t.transportId.equals(id))).go();
      await (_db.delete(_db.localVehicleAssignments)..where((t) => t.transportId.equals(id))).go();
      await (_db.delete(_db.localDriverAssignments)..where((t) => t.transportId.equals(id))).go();
      await (_db.delete(_db.localNotificationLogs)..where((t) => t.transportId.equals(id))).go();
      await (_db.delete(_db.localPodDocuments)..where((t) => t.transportId.equals(id))).go();
      await (_db.delete(_db.localActivityLogs)..where((t) => t.transportId.equals(id))).go();
      try {
        await (_db.delete(_db.localTransportAllocations)..where((t) => t.transportId.equals(id))).go();
      } catch (_) {}
    } catch (_) {}
  }

  void _enqueueSyncTransportDelete(String id) {
    _db.enqueueSync(
      id: 'sync-trp-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'transport',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  // ---------------------------------------------------------------------------
  // ALLOCATION METHODS
  // ---------------------------------------------------------------------------

  @override
  Future<void> addAllocation(TransportAllocation allocation) async {
    // Update in-memory transport
    final index = _transports.indexWhere((t) => t.id == allocation.transportId);
    if (index != -1) {
      final current = _transports[index];
      final alreadyPresent = current.allocations.any((a) => a.id == allocation.id);
      if (!alreadyPresent) {
        final updated = current.copyWith(
          allocations: [...current.allocations, allocation],
        );
        _transports[index] = updated;
        // Keep legacy single-vehicle columns in sync with slot-0
        _persistTransportToDb(updated);
      }
    }
    // Persist allocation row
    await _persistAllocationToDb(allocation);
    _enqueueSyncAllocation(allocation);
  }

  @override
  Future<void> removeAllocation(String allocationId) async {
    // Find which transport owns this allocation
    String? transportId;
    for (final t in _transports) {
      if (t.allocations.any((a) => a.id == allocationId)) {
        transportId = t.id;
        break;
      }
    }
    if (transportId == null) return;

    final index = _transports.indexWhere((t) => t.id == transportId);
    if (index != -1) {
      final current = _transports[index];
      final newAllocs = current.allocations.where((a) => a.id != allocationId).toList();
      // Re-index slots
      final reindexed = newAllocs.asMap().entries.map((e) {
        final a = e.value;
        return TransportAllocation(
          id: a.id,
          transportId: a.transportId,
          slotIndex: e.key,
          vehicleId: a.vehicleId,
          vehicleNumber: a.vehicleNumber,
          driverId: a.driverId,
          driverName: a.driverName,
          driverMobile: a.driverMobile,
          assignedAt: a.assignedAt,
        );
      }).toList();
      final updated = current.copyWith(allocations: reindexed);
      _transports[index] = updated;
      _persistTransportToDb(updated);
    }
    // Delete allocation row from DB
    try {
      await (_db.delete(_db.localTransportAllocations)..where((t) => t.id.equals(allocationId))).go();
    } catch (_) {}
    // Enqueue sync delete for allocation
    _db.enqueueSync(
      id: 'sync-alloc-del-${DateTime.now().millisecondsSinceEpoch}',
      entityType: 'transport_allocation',
      entityId: allocationId,
      operation: 'DELETE',
      payload: jsonEncode({'id': allocationId}),
    );
  }

  Future<void> _persistAllocationToDb(TransportAllocation a) async {
    try {
      await _db.into(_db.localTransportAllocations).insertOnConflictUpdate(
        LocalTransportAllocationsCompanion(
          id: Value(a.id),
          transportId: Value(a.transportId),
          slotIndex: Value(a.slotIndex),
          vehicleId: Value(a.vehicleId),
          vehicleNumber: Value(a.vehicleNumber),
          driverId: Value(a.driverId),
          driverName: Value(a.driverName),
          driverMobile: Value(a.driverMobile),
          assignedAt: Value(a.assignedAt),
        ),
      );
    } catch (_) {}
  }

  void _enqueueSyncAllocation(TransportAllocation a) {
    _db.enqueueSync(
      id: 'sync-alloc-${a.id}',
      entityType: 'transport_allocation',
      entityId: a.id,
      operation: 'CREATE',
      payload: jsonEncode(a.toJson()),
    );
  }

  @override
  List<ActivityLog> getAllActivityLogs() => List.unmodifiable(_activityLogs);

  @override
  List<ActivityLog> getActivityLogs(String transportId) {
    return _activityLogs.where((log) => log.transportId == transportId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  void addActivityLog(ActivityLog log) {
    _activityLogs.insert(0, log);
    _persistActivityLogToDb(log);
    _enqueueSyncActivityLog(log);
  }

  @override
  List<NotificationLog> getAllNotificationLogs() => List.unmodifiable(_notificationLogs);

  @override
  List<NotificationLog> getNotificationLogs(String transportId) {
    return _notificationLogs.where((n) => n.transportId == transportId).toList()
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
  }

  @override
  void addNotificationLog(NotificationLog log) {
    _notificationLogs.insert(0, log);
    _persistNotificationLogToDb(log);
    _enqueueSyncNotificationLog(log);
  }

  @override
  Future<void> recordVehicleAssignment({
    required String transportId,
    required String vehicleId,
    String assignedBy = 'Super Admin',
  }) async {
    try {
      final id = 'va-${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      await _db.into(_db.localVehicleAssignments).insertOnConflictUpdate(
            LocalVehicleAssignmentsCompanion(
              id: Value(id),
              transportId: Value(transportId),
              vehicleId: Value(vehicleId),
              assignedAt: Value(now),
              assignedBy: Value(assignedBy),
              isActive: const Value(true),
            ),
          );

      _db.enqueueSync(
        id: 'sync-$id',
        entityType: 'vehicle_assignment',
        entityId: id,
        operation: 'CREATE',
        payload: jsonEncode({
          'id': id,
          'transport_id': transportId,
          'vehicle_id': vehicleId,
          'assigned_at': now.toIso8601String(),
        }),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  Future<void> releaseVehicleAssignment({
    required String transportId,
    required String vehicleId,
  }) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.localVehicleAssignments)
            ..where((t) => t.transportId.equals(transportId) & t.vehicleId.equals(vehicleId) & t.isActive.equals(true)))
          .write(
        LocalVehicleAssignmentsCompanion(
          isActive: const Value(false),
          releasedAt: Value(now),
        ),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  Future<void> recordDriverAssignment({
    required String transportId,
    required String driverId,
    String assignedBy = 'Super Admin',
  }) async {
    try {
      final id = 'da-${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      await _db.into(_db.localDriverAssignments).insertOnConflictUpdate(
            LocalDriverAssignmentsCompanion(
              id: Value(id),
              transportId: Value(transportId),
              driverId: Value(driverId),
              assignedAt: Value(now),
              assignedBy: Value(assignedBy),
              isActive: const Value(true),
            ),
          );

      _db.enqueueSync(
        id: 'sync-$id',
        entityType: 'driver_assignment',
        entityId: id,
        operation: 'CREATE',
        payload: jsonEncode({
          'id': id,
          'transport_id': transportId,
          'driver_id': driverId,
          'assigned_at': now.toIso8601String(),
        }),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  @override
  Future<void> releaseDriverAssignment({
    required String transportId,
    required String driverId,
  }) async {
    try {
      final now = DateTime.now();
      await (_db.update(_db.localDriverAssignments)
            ..where((t) => t.transportId.equals(transportId) & t.driverId.equals(driverId) & t.isActive.equals(true)))
          .write(
        LocalDriverAssignmentsCompanion(
          isActive: const Value(false),
          releasedAt: Value(now),
        ),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  Future<void> _persistTransportToDb(Transport t) async {
    try {
      await _db.into(_db.localTransports).insertOnConflictUpdate(
            LocalTransportsCompanion(
              id: Value(t.id),
              transportNumber: Value(t.id),
              bookingNumber: Value(t.bookingNumber),
              containerNumber: Value(t.containerNumber),
              sealNumber: Value(t.sealNumber),
              containerSize: Value(t.containerSize.code),
              shipmentType: Value(t.shipmentType.code),
              partyId: Value(t.partyId),
              partyName: Value(t.partyName),
              partyMobile: Value(t.partyMobile),
              bookingPartyId: Value(t.bookingPartyId),
              bookingPartyName: Value(t.bookingPartyName),
              shippingLineId: Value(t.shippingLineId),
              shippingLineName: Value(t.shippingLineName),
              fromLocationId: Value(t.fromLocationId),
              fromLocationName: Value(t.fromLocationName),
              toLocationId: Value(t.toLocationId),
              toLocationName: Value(t.toLocationName),
              portCfsId: Value(t.portCfsId),
              portCfsName: Value(t.portCfsName),
              vehicleId: Value(t.vehicleId),
              vehicleNumber: Value(t.vehicleNumber),
              driverId: Value(t.driverId),
              driverName: Value(t.driverName),
              driverMobile: Value(t.driverMobile),
              status: Value(t.status.code),
              exceptionReason: Value(t.exceptionReason),
              completedAt: Value(t.completionDate),
              createdAt: Value(t.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      try {
        // Fallback without partyMobile in case legacy device DB hasn't migrated yet
        await _db.into(_db.localTransports).insertOnConflictUpdate(
              LocalTransportsCompanion(
                id: Value(t.id),
                transportNumber: Value(t.id),
                bookingNumber: Value(t.bookingNumber),
                containerNumber: Value(t.containerNumber),
                sealNumber: Value(t.sealNumber),
                containerSize: Value(t.containerSize.code),
                shipmentType: Value(t.shipmentType.code),
                partyId: Value(t.partyId),
                partyName: Value(t.partyName),
                bookingPartyId: Value(t.bookingPartyId),
                bookingPartyName: Value(t.bookingPartyName),
                shippingLineId: Value(t.shippingLineId),
                shippingLineName: Value(t.shippingLineName),
                fromLocationId: Value(t.fromLocationId),
                fromLocationName: Value(t.fromLocationName),
                toLocationId: Value(t.toLocationId),
                toLocationName: Value(t.toLocationName),
                portCfsId: Value(t.portCfsId),
                portCfsName: Value(t.portCfsName),
                vehicleId: Value(t.vehicleId),
                vehicleNumber: Value(t.vehicleNumber),
                driverId: Value(t.driverId),
                driverName: Value(t.driverName),
                driverMobile: Value(t.driverMobile),
                status: Value(t.status.code),
                exceptionReason: Value(t.exceptionReason),
                completedAt: Value(t.completionDate),
                createdAt: Value(t.createdAt),
                updatedAt: Value(DateTime.now()),
              ),
            );
      } catch (_) {}
    }
  }

  void _enqueueSyncTransport(Transport t, String op) {
    _db.enqueueSync(
      id: 'sync-trn-${DateTime.now().millisecondsSinceEpoch}-${t.id}',
      entityType: 'transport',
      entityId: t.id,
      operation: op,
      payload: jsonEncode({
        'id': t.id,
        'transport_number': t.id,
        'booking_number': t.bookingNumber,
        'container_number': t.containerNumber,
        'seal_number': t.sealNumber,
        'container_size': t.containerSize.code,
        'shipment_type': t.shipmentType.code,
        'party_id': t.partyId,
        'party_name': t.partyName,
        'booking_party_id': t.bookingPartyId,
        'booking_party_name': t.bookingPartyName,
        'shipping_line_id': t.shippingLineId,
        'shipping_line_name': t.shippingLineName,
        'from_location_id': t.fromLocationId,
        'from_location_name': t.fromLocationName,
        'to_location_id': t.toLocationId,
        'to_location_name': t.toLocationName,
        'port_cfs_id': t.portCfsId,
        'port_cfs_name': t.portCfsName,
        'vehicle_id': t.vehicleId,
        'vehicle_number': t.vehicleNumber,
        'driver_id': t.driverId,
        'driver_name': t.driverName,
        'driver_mobile': t.driverMobile,
        'status': t.status.code,
        'exception_reason': t.exceptionReason,
        'completed_at': t.completionDate?.toIso8601String(),
        'created_at': t.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }

  void _recordStatusHistory(String transportId, String status, String? remarks, String changedBy) {
    try {
      final id = 'h-${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      _db.into(_db.localTransportStatusHistory).insertOnConflictUpdate(
            LocalTransportStatusHistoryCompanion(
              id: Value(id),
              transportId: Value(transportId),
              status: Value(status),
              remarks: Value(remarks),
              changedBy: Value(changedBy),
              createdAt: Value(now),
            ),
          );

      _db.enqueueSync(
        id: 'sync-$id',
        entityType: 'status_history',
        entityId: id,
        operation: 'CREATE',
        payload: jsonEncode({
          'id': id,
          'transport_id': transportId,
          'from_status': null,
          'to_status': status,
          'reason': remarks,
          'changed_by': changedBy,
          'changed_at': now.toIso8601String(),
        }),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  Future<void> _persistPodToDb(String transportId, PodDocument pod) async {
    try {
      final id = 'pod-${DateTime.now().millisecondsSinceEpoch}';
      await _db.into(_db.localPodDocuments).insertOnConflictUpdate(
            LocalPodDocumentsCompanion(
              id: Value(id),
              transportId: Value(transportId),
              fileName: Value(pod.fileName),
              storagePath: Value('pods/$transportId/${pod.fileName}'),
              fileType: Value(pod.fileType),
              fileSize: Value(BigInt.from(pod.fileSize)),
              uploadedBy: Value(pod.uploadedBy),
              uploadedAt: Value(pod.uploadedAt),
              fileUrl: Value(pod.fileUrl),
            ),
          );

      _db.enqueueSync(
        id: 'sync-$id',
        entityType: 'pod_document',
        entityId: id,
        operation: 'CREATE',
        payload: jsonEncode({
          'id': id,
          'transport_id': transportId,
          'file_name': pod.fileName,
          'storage_path': 'pods/$transportId/${pod.fileName}',
          'file_type': pod.fileType,
          'file_size': pod.fileSize,
          'uploaded_at': pod.uploadedAt.toIso8601String(),
        }),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  Future<void> _deletePodFromDb(String transportId) async {
    try {
      await (_db.delete(_db.localPodDocuments)..where((tbl) => tbl.transportId.equals(transportId))).go();

      _db.enqueueSync(
        id: 'sync-del-pod-${DateTime.now().millisecondsSinceEpoch}',
        entityType: 'pod_document',
        entityId: transportId,
        operation: 'DELETE',
        payload: jsonEncode({
          'transport_id': transportId,
        }),
      );
    } catch (_) {
      // Safe fallback
    }
  }

  Future<void> _persistActivityLogToDb(ActivityLog a) async {
    try {
      await _db.into(_db.localActivityLogs).insertOnConflictUpdate(
            LocalActivityLogsCompanion(
              id: Value(a.id),
              transportId: Value(a.transportId),
              userId: Value(a.performedBy),
              action: Value(a.title),
              description: Value(a.description),
              createdAt: Value(a.timestamp),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSyncActivityLog(ActivityLog a) {
    _db.enqueueSync(
      id: 'sync-act-${a.id}',
      entityType: 'activity_log',
      entityId: a.id,
      operation: 'CREATE',
      payload: jsonEncode({
        'id': a.id,
        'transport_id': a.transportId,
        'title': a.title,
        'description': a.description,
        'timestamp': a.timestamp.toIso8601String(),
      }),
    );
  }

  Future<void> _persistNotificationLogToDb(NotificationLog n) async {
    try {
      await _db.into(_db.localNotificationLogs).insertOnConflictUpdate(
            LocalNotificationLogsCompanion(
              id: Value(n.id),
              transportId: Value(n.transportId),
              recipientName: Value(n.recipientName),
              recipientMobile: Value(n.recipientMobile),
              channel: Value(n.channel),
              messageBody: Value(n.messageBody),
              status: Value(n.status),
              sentAt: Value(n.sentAt),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSyncNotificationLog(NotificationLog n) {
    _db.enqueueSync(
      id: 'sync-notif-${n.id}',
      entityType: 'notification_log',
      entityId: n.id,
      operation: 'CREATE',
      payload: jsonEncode({
        'id': n.id,
        'transport_id': n.transportId,
        'channel': n.channel,
        'recipient_phone': n.recipientMobile,
        'message': n.messageBody,
        'status': n.status,
        'sent_at': n.sentAt.toIso8601String(),
      }),
    );
  }
}

final transportRepositoryProvider = Provider<TransportRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionTransportRepository(db);
});
