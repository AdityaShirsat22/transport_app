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

  const SyncState({
    this.isOnline = true,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.lastSyncedAt,
    this.errorMessage,
  });

  SyncState copyWith({
    bool? isOnline,
    bool? isSyncing,
    int? pendingCount,
    DateTime? lastSyncedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
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
    final online = await _connectivity.checkOnline();
    final queue = await _db.getPendingSyncQueue();
    state = state.copyWith(isOnline: online, pendingCount: queue.length);

    _connSub = _connectivity.onConnectivityChanged.listen((online) {
      state = state.copyWith(isOnline: online);
      if (online) {
        syncPending();
      }
    });
  }

  /// Sync all pending items from local queue to Supabase
  Future<void> syncPending() async {
    if (state.isSyncing) return;

    final client = _client;
    final queue = await _db.getPendingSyncQueue();
    state = state.copyWith(pendingCount: queue.length);

    if (queue.isEmpty) return;

    state = state.copyWith(isSyncing: true, clearError: true);

    if (client == null) {
      // Offline / standalone mode: mark as synced locally
      for (final item in queue) {
        await _db.updateSyncQueueStatus(item.id, 'SYNCED');
      }
      final remaining = await _db.getPendingSyncQueue();
      state = state.copyWith(
        isSyncing: false,
        pendingCount: remaining.length,
        lastSyncedAt: DateTime.now(),
      );
      return;
    }

    try {
      for (final item in queue) {
        await _db.updateSyncQueueStatus(item.id, 'SYNCING');
        try {
          final payload = jsonDecode(item.payload) as Map<String, dynamic>;
          final tableName = _resolveSupabaseTable(item.entityType);

          if (item.operation == 'DELETE') {
            await client.from(tableName).delete().eq('id', item.entityId);
          } else {
            await client.from(tableName).upsert(payload);
          }

          await _db.deleteSyncQueueItem(item.id);
        } catch (err) {
          await _db.updateSyncQueueStatus(item.id, 'FAILED', error: err.toString());
        }
      }

      final remaining = await _db.getPendingSyncQueue();
      state = state.copyWith(
        isSyncing: false,
        pendingCount: remaining.length,
        lastSyncedAt: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Device Recovery / Initial Sync: Download all cloud data into local Drift DB
  Future<int> restoreFromCloud() async {
    final client = _client;
    if (client == null) return 0;

    state = state.copyWith(isSyncing: true, clearError: true);
    int totalRestored = 0;

    try {
      // 1. Vehicles
      final vehicles = await client.from('vehicles').select();
      for (final v in vehicles) {
        await _db.into(_db.localVehicles).insertOnConflictUpdate(
              LocalVehiclesCompanion(
                id: Value(v['id']),
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

      // 2. Drivers
      final drivers = await client.from('drivers').select();
      for (final d in drivers) {
        await _db.into(_db.localDrivers).insertOnConflictUpdate(
              LocalDriversCompanion(
                id: Value(d['id']),
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

      // 3. Parties
      final parties = await client.from('parties').select();
      for (final p in parties) {
        await _db.into(_db.localParties).insertOnConflictUpdate(
              LocalPartiesCompanion(
                id: Value(p['id']),
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

      // 4. Shipping Lines
      final lines = await client.from('shipping_lines').select();
      for (final s in lines) {
        await _db.into(_db.localShippingLines).insertOnConflictUpdate(
              LocalShippingLinesCompanion(
                id: Value(s['id']),
                name: Value(s['name']),
                code: Value(s['code']),
                isActive: Value(s['is_active'] ?? true),
                createdAt: Value(DateTime.parse(s['created_at'])),
                updatedAt: Value(DateTime.parse(s['updated_at'])),
              ),
            );
        totalRestored++;
      }

      // 5. Locations
      final locs = await client.from('locations').select();
      for (final l in locs) {
        await _db.into(_db.localLocations).insertOnConflictUpdate(
              LocalLocationsCompanion(
                id: Value(l['id']),
                name: Value(l['name']),
                locationType: Value(l['location_type']),
                isActive: Value(l['is_active'] ?? true),
                createdAt: Value(DateTime.parse(l['created_at'])),
                updatedAt: Value(DateTime.parse(l['updated_at'])),
              ),
            );
        totalRestored++;
      }

      // 6. Ports/CFS
      final ports = await client.from('ports_cfs').select();
      for (final pc in ports) {
        await _db.into(_db.localPortsCfs).insertOnConflictUpdate(
              LocalPortsCfsCompanion(
                id: Value(pc['id']),
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

      // 7. Transports
      final transports = await client.from('transports').select();
      for (final t in transports) {
        await _db.into(_db.localTransports).insertOnConflictUpdate(
              LocalTransportsCompanion(
                id: Value(t['id']),
                transportNumber: Value(t['transport_number']),
                bookingNumber: Value(t['booking_number']),
                containerNumber: Value(t['container_number']),
                sealNumber: Value(t['seal_number']),
                containerSize: Value(t['container_size']),
                shipmentType: Value(t['shipment_type']),
                partyId: Value(t['party_id']),
                partyName: Value(t['party_name']),
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
                createdAt: Value(DateTime.parse(t['created_at'])),
                updatedAt: Value(DateTime.parse(t['updated_at'])),
              ),
            );
        totalRestored++;
      }

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
