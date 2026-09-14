import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/transport_status.dart';
import '../../parties/presentation/party_view_model.dart';
import '../../transport/presentation/transport_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';
import '../domain/report_models.dart';

class ReportFilterState {
  final String searchQuery;
  final TransportStatus? statusFilter;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilterState({
    this.searchQuery = '',
    this.statusFilter,
    this.startDate,
    this.endDate,
  });

  ReportFilterState copyWith({
    String? searchQuery,
    TransportStatus? statusFilter,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStatusFilter = false,
    bool clearDateRange = false,
  }) {
    return ReportFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      startDate: clearDateRange ? null : (startDate ?? this.startDate),
      endDate: clearDateRange ? null : (endDate ?? this.endDate),
    );
  }
}

class ReportFilterNotifier extends StateNotifier<ReportFilterState> {
  ReportFilterNotifier() : super(const ReportFilterState());

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setStatusFilter(TransportStatus? s) =>
      state = s == null ? state.copyWith(clearStatusFilter: true) : state.copyWith(statusFilter: s);
  void setDateRange(DateTime? start, DateTime? end) =>
      state = (start == null && end == null)
          ? state.copyWith(clearDateRange: true)
          : state.copyWith(startDate: start, endDate: end);
}

final reportFilterProvider =
    StateNotifierProvider<ReportFilterNotifier, ReportFilterState>((ref) {
  return ReportFilterNotifier();
});

// Daily Transport Report Provider
final dailyTransportReportProvider = Provider<List<DailyTransportReportItem>>((ref) {
  final transportState = ref.watch(transportViewModelProvider);
  final filter = ref.watch(reportFilterProvider);

  return transportState.transports.where((t) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final match = t.id.toLowerCase().contains(q) ||
          t.bookingNumber.toLowerCase().contains(q) ||
          t.containerNumber.toLowerCase().contains(q) ||
          t.partyName.toLowerCase().contains(q) ||
          (t.vehicleNumber?.toLowerCase().contains(q) ?? false);
      if (!match) return false;
    }
    if (filter.statusFilter != null && t.status != filter.statusFilter) {
      return false;
    }
    if (filter.startDate != null && t.createdAt.isBefore(filter.startDate!)) {
      return false;
    }
    if (filter.endDate != null && t.createdAt.isAfter(filter.endDate!.add(const Duration(days: 1)))) {
      return false;
    }
    return true;
  }).map((t) {
    return DailyTransportReportItem(
      date: t.createdAt,
      transportId: t.id,
      bookingNumber: t.bookingNumber,
      containerNumber: t.containerNumber,
      customer: t.partyName,
      vehicle: t.vehicleNumber ?? 'Pending',
      driver: t.driverName ?? 'Pending',
      fromLocation: t.fromLocationName,
      toLocation: t.toLocationName,
      status: t.status,
    );
  }).toList();
});

// Trip Report Provider
final tripReportProvider = Provider<List<TripReportItem>>((ref) {
  final transportState = ref.watch(transportViewModelProvider);
  final filter = ref.watch(reportFilterProvider);

  return transportState.transports.where((t) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final match = t.id.toLowerCase().contains(q) ||
          (t.vehicleNumber?.toLowerCase().contains(q) ?? false) ||
          (t.driverName?.toLowerCase().contains(q) ?? false);
      if (!match) return false;
    }
    if (filter.statusFilter != null && t.status != filter.statusFilter) {
      return false;
    }
    return true;
  }).map((t) {
    return TripReportItem(
      transportId: t.id,
      vehicle: t.vehicleNumber ?? 'Not Assigned',
      driver: t.driverName ?? 'Not Assigned',
      route: '${t.fromLocationName} → ${t.toLocationName}',
      startDate: t.createdAt,
      completionDate: t.completionDate,
      status: t.status,
    );
  }).toList();
});

// Vehicle Report Provider
final vehicleReportProvider = Provider<List<VehicleReportItem>>((ref) {
  final vehicleState = ref.watch(vehicleViewModelProvider);
  final transportState = ref.watch(transportViewModelProvider);
  final filter = ref.watch(reportFilterProvider);

  return vehicleState.vehicles.where((v) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      return v.vehicleNumber.toLowerCase().contains(q) || v.vehicleType.toLowerCase().contains(q);
    }
    return true;
  }).map((v) {
    final trips = transportState.transports.where((t) => t.vehicleId == v.id || t.vehicleNumber == v.vehicleNumber).toList();
    final total = trips.length;
    final completed = trips.where((t) => t.status == TransportStatus.completed).length;
    final cancelled = trips.where((t) => t.status == TransportStatus.cancelled).length;
    final active = total - completed - cancelled;

    return VehicleReportItem(
      vehicleNumber: v.vehicleNumber,
      vehicleType: v.vehicleType,
      capacity: v.capacity,
      totalTrips: total,
      activeTrips: active,
      completedTrips: completed,
      cancelledTrips: cancelled,
      currentStatus: v.status,
    );
  }).toList();
});

// Customer Report Provider
final customerReportProvider = Provider<List<CustomerReportItem>>((ref) {
  final partyState = ref.watch(partyViewModelProvider);
  final filter = ref.watch(reportFilterProvider);

  return partyState.parties.where((p) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      return p.party.name.toLowerCase().contains(q) || p.party.city.toLowerCase().contains(q);
    }
    return true;
  }).map((p) {
    return CustomerReportItem(
      customerName: p.party.name,
      mobileNumber: p.party.mobileNumber,
      totalTrips: p.totalTrips,
      completedTrips: p.completedTrips,
      pendingTrips: p.activeTrips,
      cancelledTrips: p.cancelledTrips,
    );
  }).toList();
});
