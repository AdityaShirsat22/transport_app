class DashboardStats {
  final int totalTransport;
  final int todaysTrips;
  final int vehiclePending;
  final int assigned;
  final int inTransit;
  final int completed;

  // Vehicle counts
  final int vehiclesAvailable;
  final int vehiclesOnTrip;
  final int vehiclesMaintenance;
  final int vehiclesInactive;

  const DashboardStats({
    required this.totalTransport,
    required this.todaysTrips,
    required this.vehiclePending,
    required this.assigned,
    required this.inTransit,
    required this.completed,
    required this.vehiclesAvailable,
    required this.vehiclesOnTrip,
    required this.vehiclesMaintenance,
    required this.vehiclesInactive,
  });
}
