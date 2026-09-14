enum ShipmentType {
  export('EXPORT', 'Export'),
  import('IMPORT', 'Import');

  final String code;
  final String label;

  const ShipmentType(this.code, this.label);

  static ShipmentType fromCode(String code) {
    return ShipmentType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ShipmentType.export,
    );
  }
}
