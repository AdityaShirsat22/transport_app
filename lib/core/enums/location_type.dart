enum LocationType {
  customer('Customer'),
  factory('Factory'),
  warehouse('Warehouse'),
  port('Port'),
  cfs('CFS'),
  other('Other');

  final String label;
  const LocationType(this.label);

  static LocationType fromString(String value) {
    return LocationType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase() || e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => LocationType.customer,
    );
  }
}
