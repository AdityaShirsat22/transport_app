import '../../../core/enums/driver_status.dart';

class Driver {
  final String id;
  final String name;
  final String mobileNumber;
  final DriverStatus status;
  final String? currentVehicleId;
  final String? currentVehicleNumber;
  final bool isActive;
  final DateTime createdAt;

  const Driver({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.status,
    this.currentVehicleId,
    this.currentVehicleNumber,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isAvailable => status == DriverStatus.available && isActive;

  Driver copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    DriverStatus? status,
    String? currentVehicleId,
    String? currentVehicleNumber,
    bool clearCurrentVehicle = false,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      currentVehicleId: clearCurrentVehicle ? null : (currentVehicleId ?? this.currentVehicleId),
      currentVehicleNumber: clearCurrentVehicle ? null : (currentVehicleNumber ?? this.currentVehicleNumber),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'status': status.code,
      'currentVehicleId': currentVehicleId,
      'currentVehicleNumber': currentVehicleNumber,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      status: DriverStatus.fromCode(json['status'] as String),
      currentVehicleId: json['currentVehicleId'] as String?,
      currentVehicleNumber: json['currentVehicleNumber'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
