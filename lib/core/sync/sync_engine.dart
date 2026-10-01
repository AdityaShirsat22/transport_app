import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';
import '../database/app_database.dart';
import '../services/connectivity_service.dart';

class SyncState {
  final bool isOnline;
  final bool isSyncing;
  final int pendingCount;
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final bool hasCompletedStartupSync;

  const SyncState({
    this.isOnline = true,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.lastSyncedAt,
    this.errorMessage,
    this.hasCompletedStartupSync = false,
  });

  SyncState copyWith({
    bool? isOnline,
    bool? isSyncing,
    int? pendingCount,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearError = false,
    bool? hasCompletedStartupSync,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasCompletedStartupSync: hasCompletedStartupSync ?? this.hasCompletedStartupSync,
    );
  }
}

class SyncEngineNotifier extends StateNotifier<SyncState> {
  final AppDatabase _db;
  final ConnectivityService _connectivity;
  StreamSubscription<bool>? _connSub;

  SyncEngineNotifier(this._db, this._connectivity) : super(const SyncState()) {
    _init();
  }

  SupabaseClient? get _client {
    if (EnvConfig.isSupabaseConfigured) {
      try {
        return Supabase.instance.client;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> _init() async {
    try {
      final online = await _connectivity.checkOnline();
      final queue = await _db.getPendingSyncQueue();
      if (!mounted) return;
      state = state.copyWith(isOnline: online, pendingCount: queue.length);

      _connSub = _connectivity.onConnectivityChanged.listen((online) {
        if (!mounted) return;
        state = state.copyWith(isOnline: online);
        if (online) {
          syncPending();
        }
      });
    } catch (_) {}
  }

  /// Called by ViewModels immediately after writing any data.
  /// When online, drains the queue right away so data reaches Supabase
  /// without the user needing to press "Sync Now".
  /// When offline, the item stays queued and will be sent once reconnected.
  Future<void> triggerAutoSync() async {
    if (!mounted) return;
    if (!state.isOnline) return; // stay queued, will sync on reconnect
    if (state.isSyncing) return; // already in progress, new item will be swept
    await syncPending();
  }

  /// Sync all pending items from local queue to Supabase
  Future<void> syncPending() async {
    if (!mounted) return;
    if (state.isSyncing) return;

    final client = _client;
    final List queue;
    try {
      queue = await _db.getPendingSyncQueue();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    state = state.copyWith(pendingCount: queue.length);

    if (queue.isEmpty) return;

    state = state.copyWith(isSyncing: true, clearError: true);

    if (client == null) {
      // Offline / standalone mode: mark as synced locally
      try {
        for (final item in queue) {
          await _db.updateSyncQueueStatus(item.id, 'SYNCED');
        }
        final remaining = await _db.getPendingSyncQueue();
        if (!mounted) return;
        state = state.copyWith(
          isSyncing: false,
          pendingCount: remaining.length,
          lastSyncedAt: DateTime.now(),
        );
      } catch (_) {}
      return;
    }

    try {
      for (final item in queue) {
        try {
          final tableName = _resolveSupabaseTable(item.entityType);
          final rawPayload = jsonDecode(item.payload) as Map<String, dynamic>;
          final payload = _sanitizePayload(tableName, rawPayload);

          if (item.operation == 'CREATE' || item.operation == 'UPDATE') {
            await client.from(tableName).upsert(payload);
          } else if (item.operation == 'DELETE') {
            await client.from(tableName).delete().match({'id': item.entityId});
          }
          await _db.updateSyncQueueStatus(item.id, 'SYNCED');
        } catch (itemError) {
          await _db.updateSyncQueueStatus(item.id, 'FAILED');
        }
      }

      final remaining = await _db.getPendingSyncQueue();
      if (!mounted) return;
      state = state.copyWith(
        isSyncing: false,
        pendingCount: remaining.length,
        lastSyncedAt: DateTime.now(),
        clearError: remaining.isEmpty,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Bi-directional synchronization:
  /// 1. Flushes any pending local changes/deletions to Supabase
  /// 2. Pulls fresh cloud records into SQLite and prunes deleted records
  Future<int> syncAll() async {
    await syncPending();
    return await restoreFromCloud();
  }

  /// Automatic startup sync: called once on app launch when online.
  /// Fetches all cloud data into local SQLite so the UI always shows current data on restart.
  Future<void> startupSync() async {
    final client = _client;
    if (client == null) {
      // Not connected to Supabase — mark done so the shell doesn't wait forever
      state = state.copyWith(hasCompletedStartupSync: true);
      return;
    }

    final online = await _connectivity.checkOnline();
    if (!online) {
      // Offline — use cached SQLite data; mark done
      state = state.copyWith(isOnline: false, hasCompletedStartupSync: true);
      return;
    }

    // Online + Supabase configured: refresh local DB from cloud
    await syncAll();
    state = state.copyWith(hasCompletedStartupSync: true);
  }

  /// Device Recovery / Initial Sync: Download all cloud data into local Drift DB
  Future<int> restoreFromCloud() async {
    final client = _client;
    if (client == null) return 0;

    state = state.copyWith(isSyncing: true, clearError: true);
    int totalRestored = 0;

    try {
      // Get pending sync items so we don't delete locally created items that haven't pushed yet
      final pendingQueue = await _db.getPendingSyncQueue();
      final pendingVehicles = pendingQueue
          .where((q) => q.entityType == 'vehicle' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingDrivers = pendingQueue
          .where((q) => q.entityType == 'driver' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingParties = pendingQueue
          .where((q) => q.entityType == 'party' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingLines = pendingQueue
          .where((q) => q.entityType == 'shipping_line' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingLocations = pendingQueue
          .where((q) => q.entityType == 'location' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingPorts = pendingQueue
          .where((q) => q.entityType == 'port_cfs' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingTransports = pendingQueue
          .where((q) => q.entityType == 'transport' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();
      final pendingAllocs = pendingQueue
          .where((q) => q.entityType == 'transport_allocation' && q.operation != 'DELETE')
          .map((q) => q.entityId)
          .toSet();

      // 1. Vehicles
      final vehicles = await client.from('vehicles').select();
      final cloudVehicleIds = <String>{};
      for (final v in vehicles) {
        final id = v['id'] as String;
        cloudVehicleIds.add(id);
        await _db.into(_db.localVehicles).insertOnConflictUpdate(
              LocalVehiclesCompanion(
                id: Value(id),
                vehicleNumber: Value(v['vehicle_number']),
                vehicleType: Value(v['vehicle_type']),
                capacity: Value(v['capacity']),
                status: Value(v['status']),
                assignedDriverId: Value(v['assigned_driver_id']),
                assignedDriverName: Value(v['assigned_driver_name']),
                isActive: Value(v['is_active'] ?? true),
                createdAt: Value(DateTime.parse(v['created_at'])),
                updatedAt: Value(DateTime.parse(v['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepVehicleIds = {...cloudVehicleIds, ...pendingVehicles};
      if (keepVehicleIds.isEmpty) {
        await _db.delete(_db.localVehicles).go();
      } else {
        await (_db.delete(_db.localVehicles)..where((t) => t.id.isNotIn(keepVehicleIds))).go();
      }

      // 2. Drivers
      final drivers = await client.from('drivers').select();
      final cloudDriverIds = <String>{};
      for (final d in drivers) {
        final id = d['id'] as String;
        cloudDriverIds.add(id);
        await _db.into(_db.localDrivers).insertOnConflictUpdate(
              LocalDriversCompanion(
                id: Value(id),
                name: Value(d['name']),
                mobileNumber: Value(d['mobile_number']),
                status: Value(d['status']),
                currentVehicleId: Value(d['current_vehicle_id']),
                currentVehicleNumber: Value(d['current_vehicle_number']),
                isActive: Value(d['is_active'] ?? true),
                createdAt: Value(DateTime.parse(d['created_at'])),
                updatedAt: Value(DateTime.parse(d['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepDriverIds = {...cloudDriverIds, ...pendingDrivers};
      if (keepDriverIds.isEmpty) {
        await _db.delete(_db.localDrivers).go();
      } else {
        await (_db.delete(_db.localDrivers)..where((t) => t.id.isNotIn(keepDriverIds))).go();
      }

      // 3. Parties
      final parties = await client.from('parties').select();
      final cloudPartyIds = <String>{};
      for (final p in parties) {
        final id = p['id'] as String;
        cloudPartyIds.add(id);
        await _db.into(_db.localParties).insertOnConflictUpdate(
              LocalPartiesCompanion(
                id: Value(id),
                partyName: Value(p['party_name']),
                customerMobile: Value(p['customer_mobile']),
                email: Value(p['email'] ?? ''),
                city: Value(p['city'] ?? ''),
                isActive: Value(p['is_active'] ?? true),
                createdAt: Value(DateTime.parse(p['created_at'])),
                updatedAt: Value(DateTime.parse(p['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepPartyIds = {...cloudPartyIds, ...pendingParties};
      if (keepPartyIds.isEmpty) {
        await _db.delete(_db.localParties).go();
      } else {
        await (_db.delete(_db.localParties)..where((t) => t.id.isNotIn(keepPartyIds))).go();
      }

      // 4. Shipping Lines
      final lines = await client.from('shipping_lines').select();
      final cloudLineIds = <String>{};
      for (final s in lines) {
        final id = s['id'] as String;
        cloudLineIds.add(id);
        await _db.into(_db.localShippingLines).insertOnConflictUpdate(
              LocalShippingLinesCompanion(
                id: Value(id),
                name: Value(s['name']),
                code: Value(s['code']),
                isActive: Value(s['is_active'] ?? true),
                createdAt: Value(DateTime.parse(s['created_at'])),
                updatedAt: Value(DateTime.parse(s['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepLineIds = {...cloudLineIds, ...pendingLines};
      if (keepLineIds.isEmpty) {
        await _db.delete(_db.localShippingLines).go();
      } else {
        await (_db.delete(_db.localShippingLines)..where((t) => t.id.isNotIn(keepLineIds))).go();
      }

      // 5. Locations
      final locs = await client.from('locations').select();
      final cloudLocIds = <String>{};
      for (final l in locs) {
        final id = l['id'] as String;
        cloudLocIds.add(id);
        await _db.into(_db.localLocations).insertOnConflictUpdate(
              LocalLocationsCompanion(
                id: Value(id),
                name: Value(l['name']),
                locationType: Value(l['location_type']),
                isActive: Value(l['is_active'] ?? true),
                createdAt: Value(DateTime.parse(l['created_at'])),
                updatedAt: Value(DateTime.parse(l['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepLocIds = {...cloudLocIds, ...pendingLocations};
      if (keepLocIds.isEmpty) {
        await _db.delete(_db.localLocations).go();
      } else {
        await (_db.delete(_db.localLocations)..where((t) => t.id.isNotIn(keepLocIds))).go();
      }

      // 6. Ports/CFS
      final ports = await client.from('ports_cfs').select();
      final cloudPortIds = <String>{};
      for (final pc in ports) {
        final id = pc['id'] as String;
        cloudPortIds.add(id);
        await _db.into(_db.localPortsCfs).insertOnConflictUpdate(
              LocalPortsCfsCompanion(
                id: Value(id),
                name: Value(pc['name']),
                type: Value(pc['type']),
                location: Value(pc['location']),
                isActive: Value(pc['is_active'] ?? true),
                createdAt: Value(DateTime.parse(pc['created_at'])),
                updatedAt: Value(DateTime.parse(pc['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepPortIds = {...cloudPortIds, ...pendingPorts};
      if (keepPortIds.isEmpty) {
        await _db.delete(_db.localPortsCfs).go();
      } else {
        await (_db.delete(_db.localPortsCfs)..where((t) => t.id.isNotIn(keepPortIds))).go();
      }

      // 7. Transports
      final transports = await client.from('transports').select();
      final cloudTransportIds = <String>{};
      for (final t in transports) {
        final id = t['id'] as String;
        cloudTransportIds.add(id);
        await _db.into(_db.localTransports).insertOnConflictUpdate(
              LocalTransportsCompanion(
                id: Value(id),
                transportNumber: Value(t['transport_number']),
                bookingNumber: Value(t['booking_number']),
                containerNumber: Value(t['container_number']),
                sealNumber: Value(t['seal_number']),
                containerSize: Value(t['container_size']),
                shipmentType: Value(t['shipment_type']),
                partyId: Value(t['party_id']),
                partyName: Value(t['party_name']),
                partyMobile: Value(t['party_mobile']),
                bookingPartyId: Value(t['booking_party_id']),
                bookingPartyName: Value(t['booking_party_name']),
                shippingLineId: Value(t['shipping_line_id']),
                shippingLineName: Value(t['shipping_line_name']),
                fromLocationId: Value(t['from_location_id']),
                fromLocationName: Value(t['from_location_name']),
                toLocationId: Value(t['to_location_id']),
                toLocationName: Value(t['to_location_name']),
                portCfsId: Value(t['port_cfs_id']),
                portCfsName: Value(t['port_cfs_name']),
                vehicleId: Value(t['vehicle_id']),
                vehicleNumber: Value(t['vehicle_number']),
                driverId: Value(t['driver_id']),
                driverName: Value(t['driver_name']),
                driverMobile: Value(t['driver_mobile']),
                status: Value(t['status']),
                exceptionReason: Value(t['exception_reason']),
                completedAt: Value(t['completed_at'] != null ? DateTime.parse(t['completed_at']) : null),
                createdAt: Value(DateTime.parse(t['created_at'])),
                updatedAt: Value(DateTime.parse(t['updated_at'])),
              ),
            );
        totalRestored++;
      }
      final keepTransportIds = {...cloudTransportIds, ...pendingTransports};
      if (keepTransportIds.isEmpty) {
        await _db.delete(_db.localTransports).go();
      } else {
        await (_db.delete(_db.localTransports)..where((t) => t.id.isNotIn(keepTransportIds))).go();
      }

      // 8. POD Documents
      try {
        final pods = await client.from('pod_documents').select();
        for (final p in pods) {
          await _db.into(_db.localPodDocuments).insertOnConflictUpdate(
                LocalPodDocumentsCompanion(
                  id: Value(p['id']),
                  transportId: Value(p['transport_id']),
                  fileName: Value(p['file_name']),
                  storagePath: Value(p['storage_path']),
                  fileType: Value(p['file_type']),
                  fileSize: Value(BigInt.from(p['file_size'] ?? 0)),
                  uploadedBy: const Value('Super Admin'),
                  uploadedAt: Value(DateTime.parse(p['uploaded_at'])),
                  fileUrl: const Value(null),
                ),
              );
          totalRestored++;
        }
      } catch (_) {}

      // 9. Activity Logs
      try {
        final logs = await client
            .from('activity_logs')
            .select()
            .order('created_at', ascending: false);
        for (final a in logs) {
          await _db.into(_db.localActivityLogs).insertOnConflictUpdate(
                LocalActivityLogsCompanion(
                  id: Value(a['id'] as String),
                  transportId: Value(a['transport_id'] as String?),
                  userId: Value(a['user_id'] as String?),
                  action: Value((a['action'] ?? a['title'] ?? '') as String),
                  description: Value((a['description'] ?? '') as String),
                  createdAt: Value(DateTime.parse(
                      (a['created_at'] ?? a['timestamp']) as String)),
                ),
              );
          totalRestored++;
        }
      } catch (_) {}

      // 10. Notification Logs
      try {
        final notifs = await client
            .from('notification_logs')
            .select()
            .order('sent_at', ascending: false);
        for (final n in notifs) {
          await _db.into(_db.localNotificationLogs).insertOnConflictUpdate(
                LocalNotificationLogsCompanion(
                  id: Value(n['id'] as String),
                  transportId: Value((n['transport_id'] ?? '') as String),
                  recipientName: Value((n['recipient_name'] ?? '') as String),
                  recipientMobile: Value(
                      (n['recipient_mobile'] ?? n['recipient_phone'] ?? '') as String),
                  channel: Value((n['channel'] ?? '') as String),
                  messageBody: Value(
                      (n['message_body'] ?? n['message'] ?? '') as String),
                  status: Value((n['status'] ?? '') as String),
                  sentAt: Value(DateTime.parse(n['sent_at'] as String)),
                ),
              );
          totalRestored++;
        }
      } catch (_) {}

      // 11. Transport Allocations
      try {
        final allocs = await client.from('transport_allocations').select();
        final cloudAllocIds = <String>{};
        for (final a in allocs) {
          final id = a['id'] as String;
          cloudAllocIds.add(id);
          await _db.into(_db.localTransportAllocations).insertOnConflictUpdate(
                LocalTransportAllocationsCompanion(
                  id: Value(id),
                  transportId: Value(a['transport_id'] as String),
                  slotIndex: Value((a['slot_index'] as num).toInt()),
                  vehicleId: Value(a['vehicle_id'] as String),
                  vehicleNumber: Value(a['vehicle_number'] as String),
                  driverId: Value(a['driver_id'] as String?),
                  driverName: Value(a['driver_name'] as String?),
                  driverMobile: Value(a['driver_mobile'] as String?),
                  containerNumber: Value(a['container_number'] as String?),
                  sealNumber: Value(a['seal_number'] as String?),
                  assignedAt: Value(DateTime.parse(a['assigned_at'] as String)),
                ),
              );
          totalRestored++;
        }
        final keepAllocIds = {...cloudAllocIds, ...pendingAllocs};
        if (keepAllocIds.isEmpty) {
          await _db.delete(_db.localTransportAllocations).go();
        } else {
          await (_db.delete(_db.localTransportAllocations)..where((t) => t.id.isNotIn(keepAllocIds))).go();
        }
      } catch (_) {}

      state = state.copyWith(
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
      );
      return totalRestored;
    } catch (e) {
      state = state.copyWith(isSyncing: false, errorMessage: e.toString());
      return totalRestored;
    }
  }

  Map<String, dynamic> _sanitizePayload(String tableName, Map<String, dynamic> payload) {
    final clean = Map<String, dynamic>.from(payload);
    if (tableName == 'transports') {
      clean.remove('party_mobile');
      clean.remove('allocations');
    } else if (tableName == 'vehicle_assignments') {
      clean.remove('assigned_by');
      clean.remove('is_active');
    } else if (tableName == 'driver_assignments') {
      clean.remove('assigned_by');
      clean.remove('is_active');
    } else if (tableName == 'transport_status_history') {
      if (clean.containsKey('status') && !clean.containsKey('to_status')) {
        clean['to_status'] = clean.remove('status');
      }
      if (clean.containsKey('remarks') && !clean.containsKey('reason')) {
        clean['reason'] = clean.remove('remarks');
      }
      if (clean.containsKey('created_at') && !clean.containsKey('changed_at')) {
        clean['changed_at'] = clean.remove('created_at');
      }
    } else if (tableName == 'activity_logs') {
      clean.remove('user_id');
      if (clean.containsKey('action') && !clean.containsKey('title')) {
        clean['title'] = clean.remove('action');
      }
      if (clean.containsKey('created_at') && !clean.containsKey('timestamp')) {
        clean['timestamp'] = clean.remove('created_at');
      }
    } else if (tableName == 'notification_logs') {
      clean.remove('recipient_name');
      if (clean.containsKey('recipient_mobile') && !clean.containsKey('recipient_phone')) {
        clean['recipient_phone'] = clean.remove('recipient_mobile');
      }
      if (clean.containsKey('message_body') && !clean.containsKey('message')) {
        clean['message'] = clean.remove('message_body');
      }
    } else if (tableName == 'pod_documents') {
      clean.remove('file_url');
      clean.remove('uploaded_by');
    }
    return clean;
  }

  /// Purge all pending/failed queue items in case of unresolvable sync blocks
  Future<void> clearSyncQueue() async {
    await _db.delete(_db.localSyncQueue).go();
    state = state.copyWith(pendingCount: 0, clearError: true);
  }

  String _resolveSupabaseTable(String entityType) {
    switch (entityType) {
      case 'vehicle':
        return 'vehicles';
      case 'driver':
        return 'drivers';
      case 'party':
        return 'parties';
      case 'shipping_line':
        return 'shipping_lines';
      case 'location':
        return 'locations';
      case 'port_cfs':
        return 'ports_cfs';
      case 'transport':
        return 'transports';
      case 'transport_allocation':
        return 'transport_allocations';
      case 'status_history':
        return 'transport_status_history';
      case 'vehicle_assignment':
        return 'vehicle_assignments';
      case 'driver_assignment':
        return 'driver_assignments';
      case 'notification_log':
        return 'notification_logs';
      case 'pod_document':
        return 'pod_documents';
      case 'activity_log':
        return 'activity_logs';
      default:
        return entityType;
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    super.dispose();
  }
}

final syncEngineProvider = StateNotifierProvider<SyncEngineNotifier, SyncState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final conn = ref.watch(connectivityServiceProvider);
  return SyncEngineNotifier(db, conn);
});
