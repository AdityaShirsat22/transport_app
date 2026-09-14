import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/transport_status.dart';
import '../../../core/enums/vehicle_status.dart';
import '../../../core/utils/date_formatter.dart';
import '../../transport/presentation/transport_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';
import '../domain/dashboard_stats.dart';

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final transportState = ref.watch(transportViewModelProvider);
  final vehicleState = ref.watch(vehicleViewModelProvider);

  final transports = transportState.transports;
  final vehicles = vehicleState.vehicles;

  final totalTransport = transports.length;
  final todaysTrips = transports.where((t) => DateFormatter.isToday(t.createdAt)).length;
  final vehiclePending = transports.where((t) => t.status == TransportStatus.vehiclePending).length;
  final assigned = transports.where((t) =>
      t.status == TransportStatus.vehicleAssigned ||
      t.status == TransportStatus.driverAssigned).length;
  final inTransit = transports.where((t) =>
      t.status == TransportStatus.inTransit ||
      t.status == TransportStatus.containerPickedUp ||
      t.status == TransportStatus.vehicleReported ||
      t.status == TransportStatus.atPortCfs).length;
  final completed = transports.where((t) => t.status == TransportStatus.completed).length;

  final vehiclesAvailable = vehicles.where((v) => v.status == VehicleStatus.available).length;
  final vehiclesOnTrip = vehicles.where((v) => v.status == VehicleStatus.onTrip).length;
  final vehiclesMaintenance = vehicles.where((v) => v.status == VehicleStatus.maintenance).length;
  final vehiclesInactive = vehicles.where((v) => v.status == VehicleStatus.inactive).length;

  return DashboardStats(
    totalTransport: totalTransport,
    todaysTrips: todaysTrips,
    vehiclePending: vehiclePending,
    assigned: assigned,
    inTransit: inTransit,
    completed: completed,
    vehiclesAvailable: vehiclesAvailable,
    vehiclesOnTrip: vehiclesOnTrip,
    vehiclesMaintenance: vehiclesMaintenance,
    vehiclesInactive: vehiclesInactive,
  );
});
