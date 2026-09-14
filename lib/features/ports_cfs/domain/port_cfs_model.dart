import '../../../core/enums/port_cfs_type.dart';

class PortCfs {
  final String id;
  final String name;
  final PortCfsType type;
  final String location;
  final bool isActive;
  final DateTime createdAt;

  const PortCfs({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    this.isActive = true,
    required this.createdAt,
  });

  PortCfs copyWith({
    String? id,
    String? name,
    PortCfsType? type,
    String? location,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return PortCfs(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.code,
      'location': location,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PortCfs.fromJson(Map<String, dynamic> json) {
    return PortCfs(
      id: json['id'] as String,
      name: json['name'] as String,
      type: PortCfsType.fromCode(json['type'] as String),
      location: json['location'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
