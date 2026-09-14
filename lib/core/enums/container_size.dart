enum ContainerSize {
  size20Ft('20_FT', '20 FT'),
  size40Ft('40_FT', '40 FT');

  final String code;
  final String label;

  const ContainerSize(this.code, this.label);

  static ContainerSize fromCode(String code) {
    return ContainerSize.values.firstWhere(
      (e) => e.code == code,
      orElse: () => ContainerSize.size20Ft,
    );
  }
}
