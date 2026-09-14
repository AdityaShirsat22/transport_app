enum DriverStatus {
  available('AVAILABLE', 'Available'),
  onTrip('ON_TRIP', 'On Trip'),
  offDuty('OFF_DUTY', 'Off Duty'),
  inactive('INACTIVE', 'Inactive');

  final String code;
  final String label;

  const DriverStatus(this.code, this.label);

  static DriverStatus fromCode(String code) {
    return DriverStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => DriverStatus.available,
    );
  }
}
