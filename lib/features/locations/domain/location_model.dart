import '../../../core/enums/location_type.dart';

class Location {
  final String id;
  final String name;
  final LocationType type;
  final bool isActive;
  final DateTime createdAt;

  const Location({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = true,
    required this.createdAt,
  });

  Location copyWith({
    String? id,
    String? name,
    LocationType? type,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      name: json['name'] as String,
      type: LocationType.fromString(json['type'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
