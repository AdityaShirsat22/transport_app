enum VehicleStatus {
  available('AVAILABLE', 'Available'),
  onTrip('ON_TRIP', 'On Trip'),
  maintenance('MAINTENANCE', 'Maintenance'),
  inactive('INACTIVE', 'Inactive');

  final String code;
  final String label;

  const VehicleStatus(this.code, this.label);

  static VehicleStatus fromCode(String code) {
    return VehicleStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => VehicleStatus.available,
    );
  }
}
