enum PortCfsType {
  port('PORT', 'Port'),
  cfs('CFS', 'CFS');

  final String code;
  final String label;

  const PortCfsType(this.code, this.label);

  static PortCfsType fromCode(String code) {
    return PortCfsType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => PortCfsType.cfs,
    );
  }
}
