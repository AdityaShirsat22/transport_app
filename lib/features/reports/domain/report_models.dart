import '../../../core/enums/transport_status.dart';
import '../../../core/enums/vehicle_status.dart';

class DailyTransportReportItem {
  final DateTime date;
  final String transportId;
  final String bookingNumber;
  final String containerNumber;
  final String customer;
  final String vehicle;
  final String driver;
  final String fromLocation;
  final String toLocation;
  final TransportStatus status;

  const DailyTransportReportItem({
    required this.date,
    required this.transportId,
    required this.bookingNumber,
    required this.containerNumber,
    required this.customer,
    required this.vehicle,
    required this.driver,
    required this.fromLocation,
    required this.toLocation,
    required this.status,
  });
}

class TripReportItem {
  final String transportId;
  final String vehicle;
  final String driver;
  final String route;
  final DateTime startDate;
  final DateTime? completionDate;
  final TransportStatus status;

  const TripReportItem({
    required this.transportId,
    required this.vehicle,
    required this.driver,
    required this.route,
    required this.startDate,
    this.completionDate,
    required this.status,
  });
}

class VehicleReportItem {
  final String vehicleNumber;
  final String vehicleType;
  final String capacity;
  final int totalTrips;
  final int activeTrips;
  final int completedTrips;
  final int cancelledTrips;
  final VehicleStatus currentStatus;

  const VehicleReportItem({
    required this.vehicleNumber,
    required this.vehicleType,
    required this.capacity,
    required this.totalTrips,
    required this.activeTrips,
    required this.completedTrips,
    required this.cancelledTrips,
    required this.currentStatus,
  });
}

class CustomerReportItem {
  final String customerName;
  final String mobileNumber;
  final int totalTrips;
  final int completedTrips;
  final int pendingTrips;
  final int cancelledTrips;

  const CustomerReportItem({
    required this.customerName,
    required this.mobileNumber,
    required this.totalTrips,
    required this.completedTrips,
    required this.pendingTrips,
    required this.cancelledTrips,
  });
}
