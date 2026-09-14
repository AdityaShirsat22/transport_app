class Party {
  final String id;
  final String name;
  final String mobileNumber;
  final String email;
  final String city;
  final bool isActive;
  final DateTime createdAt;

  const Party({
    required this.id,
    required this.name,
    required this.mobileNumber,
    this.email = '',
    this.city = '',
    this.isActive = true,
    required this.createdAt,
  });

  Party copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? email,
    String? city,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      city: city ?? this.city,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'city': city,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'] as String,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
