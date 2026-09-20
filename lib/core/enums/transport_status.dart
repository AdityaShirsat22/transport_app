enum TransportStatus {
  newStatus('NEW', 'New', false),
  bookingCreated('BOOKING_CREATED', 'Booking Created', true),
  vehiclePending('VEHICLE_PENDING', 'Vehicle Pending', false),
  vehicleAssigned('VEHICLE_ASSIGNED', 'Vehicle Assigned', true),
  driverAssigned('DRIVER_ASSIGNED', 'Driver Assigned', true),
  vehicleReported('VEHICLE_REPORTED', 'Vehicle Reported', false),
  containerPickedUp('CONTAINER_PICKED_UP', 'Container Picked Up', true),
  inTransit('IN_TRANSIT', 'In Transit', false),
  atPortCfs('AT_PORT_CFS', 'At Port / CFS', true),
  containerDelivered('CONTAINER_DELIVERED', 'Container Delivered', false),
  podReceived('POD_RECEIVED', 'POD Received', true),
  completed('COMPLETED', 'Completed', true),
  onHold('ON_HOLD', 'On Hold', false),
  cancelled('CANCELLED', 'Cancelled', false),
  vehicleBreakdown('VEHICLE_BREAKDOWN', 'Vehicle Breakdown', false),
  containerIssue('CONTAINER_ISSUE', 'Container Issue', false),
  documentIssue('DOCUMENT_ISSUE', 'Document Issue', false);

  final String code;
  final String label;
  final bool isSequentialStep;

  const TransportStatus(this.code, this.label, this.isSequentialStep);

  static TransportStatus fromCode(String code) {
    return TransportStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => TransportStatus.bookingCreated,
    );
  }

  /// The normal forward workflow progression sequence:
  static const List<TransportStatus> sequence = [
    TransportStatus.bookingCreated,
    TransportStatus.vehicleAssigned,
    TransportStatus.driverAssigned,
    TransportStatus.containerPickedUp,
    TransportStatus.atPortCfs,
    TransportStatus.podReceived,
    TransportStatus.completed,
  ];

  /// Get the next sequential status in the workflow, if any.
  TransportStatus? get nextStatus {
    final index = sequence.indexOf(this);
    if (index >= 0 && index < sequence.length - 1) {
      return sequence[index + 1];
    }
    return null;
  }

  bool get isException =>
      this == onHold ||
      this == cancelled ||
      this == vehicleBreakdown ||
      this == containerIssue ||
      this == documentIssue ||
      this == vehiclePending;

  bool get isCompleted => this == completed;
  bool get isCancelled => this == cancelled;
  bool get isActive => !isCompleted && !isCancelled;
}
