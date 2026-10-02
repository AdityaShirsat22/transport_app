import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
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
  Timer? _periodicSyncTimer;
  bool _needsResync = false;

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

      // Background heartbeat auto-sync: automatically sweeps any queued/pending changes
      // every 15 seconds without requiring any manual user interaction.
      _periodicSyncTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (!mounted) return;
        if (state.pendingCount > 0 && state.isOnline && !state.isSyncing) {
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
    if (state.isSyncing) {
      // Flag that another action was performed while syncing, so syncPending
      // will sweep this new item before completing.
      _needsResync = true;
      return;
    }
    // Brief delay to ensure any concurrent async drift inserts (e.g. enqueueSync) have flushed to SQLite
    await Future.delayed(const Duration(milliseconds: 100));
    await syncPending();
  }

  /// Sync all pending items from local queue to Supabase
  Future<void> syncPending() async {
    if (!mounted) return;
    if (state.isSyncing) {
      _needsResync = true;
      return;
    }

    final client = _client;
    final List initialQueue;
    try {
      initialQueue = await _db.getPendingSyncQueue();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    state = state.copyWith(pendingCount: initialQueue.length);

    if (initialQueue.isEmpty) return;

    state = state.copyWith(isSyncing: true, clearError: true);

    if (client == null) {
      // Offline / standalone mode: mark as synced locally
      try {
        for (final item in initialQueue) {
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

    final attemptedItemIds = <String>{};

    try {
      while (true) {
        final currentQueue = await _db.getPendingSyncQueue();
        final itemsToProcess = currentQueue.where((i) => !attemptedItemIds.contains(i.id)).toList();

        if (itemsToProcess.isEmpty) {
          if (_needsResync) {
            _needsResync = false;
            // Short delay to ensure SQLite insert has finished flushing
            await Future.delayed(const Duration(milliseconds: 150));
            final freshQueue = await _db.getPendingSyncQueue();
            final newItems = freshQueue.where((i) => !attemptedItemIds.contains(i.id)).toList();
            if (newItems.isNotEmpty) {
              continue;
            }
          }
          break;
        }

        _needsResync = false;
        if (mounted) {
          state = state.copyWith(pendingCount: itemsToProcess.length);
        }

        for (final item in itemsToProcess) {
          attemptedItemIds.add(item.id);
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
            debugPrint('⚠️ Sync item failed [${item.entityType}] id=${item.id}: $itemError');
            await _db.updateSyncQueueStatus(item.id, 'FAILED', error: itemError.toString());
          }
        }
      }

      // Sweep and push all local allocations to Supabase so that allocations stored
      // in SQLite are automatically pushed to the cloud database.
      try {
        final localAllocs = await _db.select(_db.localTransportAllocations).get();
        for (final a in localAllocs) {
          final rawPayload = {
            'id': a.id,
            'transport_id': a.transportId,
            'slot_index': a.slotIndex,
            'vehicle_id': a.vehicleId,
            'vehicle_number': a.vehicleNumber,
            'driver_id': a.driverId,
            'driver_name': a.driverName,
            'driver_mobile': a.driverMobile,
            'container_number': a.containerNumber ?? '',
            'seal_number': a.sealNumber ?? '',
            'assigned_at': a.assignedAt.toUtc().toIso8601String(),
          };
          final payload = _sanitizePayload('transport_allocations', rawPayload);
          await client.from('transport_allocations').upsert(payload);
        }
      } catch (e) {
        debugPrint('⚠️ Sweep local allocations to cloud: $e');
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
      debugPrint('⚠️ syncPending error: $e');
      if (!mounted) return;
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.toString(),
      );
    } finally {
      if (mounted && state.isSyncing) {
        state = state.copyWith(isSyncing: false);
      }
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
        // Only prune local allocations if cloud returned data.
        // If cloudAllocIds is empty (e.g. cloud query empty or RLS restricted),
        // preserve local allocations so multi-slot data is never wiped.
        if (cloudAllocIds.isNotEmpty) {
          final keepAllocIds = {...cloudAllocIds, ...pendingAllocs};
          await (_db.delete(_db.localTransportAllocations)..where((t) => t.id.isNotIn(keepAllocIds))).go();
        }
      } catch (_) {}

      // 12. Vehicle Assignments
      try {
        final vAssigns = await client.from('vehicle_assignments').select();
        for (final va in vAssigns) {
          final releasedAtStr = va['released_at'] as String?;
          await _db.into(_db.localVehicleAssignments).insertOnConflictUpdate(
                LocalVehicleAssignmentsCompanion(
                  id: Value(va['id'] as String),
                  transportId: Value(va['transport_id'] as String),
                  vehicleId: Value(va['vehicle_id'] as String),
                  assignedAt: Value(DateTime.parse(va['assigned_at'] as String)),
                  assignedBy: Value((va['assigned_by'] ?? 'Super Admin') as String),
                  releasedAt: Value(releasedAtStr != null ? DateTime.parse(releasedAtStr) : null),
                  isActive: Value((va['is_active'] ?? true) as bool),
                ),
              );
          totalRestored++;
        }
      } catch (_) {}

      // 13. Driver Assignments
      try {
        final dAssigns = await client.from('driver_assignments').select();
        for (final da in dAssigns) {
          final releasedAtStr = da['released_at'] as String?;
          await _db.into(_db.localDriverAssignments).insertOnConflictUpdate(
                LocalDriverAssignmentsCompanion(
                  id: Value(da['id'] as String),
                  transportId: Value(da['transport_id'] as String),
                  driverId: Value(da['driver_id'] as String),
                  assignedAt: Value(DateTime.parse(da['assigned_at'] as String)),
                  assignedBy: Value((da['assigned_by'] ?? 'Super Admin') as String),
                  releasedAt: Value(releasedAtStr != null ? DateTime.parse(releasedAtStr) : null),
                  isActive: Value((da['is_active'] ?? true) as bool),
                ),
              );
          totalRestored++;
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
      clean.remove('staffing_date');

      // Convert any empty strings to null for UUID / foreign key columns
      for (final key in [
        'driver_id',
        'vehicle_id',
        'party_id',
        'booking_party_id',
        'shipping_line_id',
        'from_location_id',
        'to_location_id',
        'port_cfs_id',
      ]) {
        if (clean[key] == '') clean[key] = null;
      }
      // Guarantee container_number and seal_number are not null for strict DB schemas
      clean['container_number'] ??= '';
      clean['seal_number'] ??= '';
    } else if (tableName == 'transport_allocations') {
      // created_at is server-managed; removing it prevents upsert conflicts
      clean.remove('created_at');
      if (clean['driver_id'] == '') clean['driver_id'] = null;
      if (clean['vehicle_id'] == '') clean['vehicle_id'] = null;
    } else if (tableName == 'pod_documents') {
      clean.remove('file_url');
      clean.remove('uploaded_by');
    } else if (tableName == 'activity_logs') {
      if (clean.containsKey('action')) {
        clean['title'] = clean.remove('action');
      }
      if (clean.containsKey('created_at')) {
        clean['timestamp'] = clean.remove('created_at');
      }
    } else if (tableName == 'transport_status_history') {
      if (clean.containsKey('status')) {
        clean['to_status'] = clean.remove('status');
      }
      if (clean.containsKey('remarks')) {
        clean['reason'] = clean.remove('remarks');
      }
      if (clean.containsKey('created_at')) {
        clean['changed_at'] = clean.remove('created_at');
      }
      clean.putIfAbsent('from_status', () => null);
    } else if (tableName == 'notification_logs') {
      clean.remove('recipient_name');
      clean.remove('created_at');
      clean.remove('party_id');
      if (clean.containsKey('recipient_mobile')) {
        clean['recipient_phone'] = clean.remove('recipient_mobile');
      }
      if (clean.containsKey('message_body')) {
        clean['message'] = clean.remove('message_body');
      }
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
    _periodicSyncTimer?.cancel();
    super.dispose();
  }
}

final syncEngineProvider = StateNotifierProvider<SyncEngineNotifier, SyncState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final conn = ref.watch(connectivityServiceProvider);
  return SyncEngineNotifier(db, conn);
});
