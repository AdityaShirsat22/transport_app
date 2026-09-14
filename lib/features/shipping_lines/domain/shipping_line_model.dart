class ShippingLine {
  final String id;
  final String name;
  final String code;
  final bool isActive;
  final DateTime createdAt;

  const ShippingLine({
    required this.id,
    required this.name,
    required this.code,
    this.isActive = true,
    required this.createdAt,
  });

  ShippingLine copyWith({
    String? id,
    String? name,
    String? code,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ShippingLine(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ShippingLine.fromJson(Map<String, dynamic> json) {
    return ShippingLine(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
