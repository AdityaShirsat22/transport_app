import '../../../core/enums/vehicle_status.dart';

class Vehicle {
  final String id;
  final String vehicleNumber;
  final String vehicleType;
  final String capacity; // '20 FT' or '40 FT'
  final VehicleStatus status;
  final String? assignedDriverId;
  final String? assignedDriverName;
  final bool isActive;
  final DateTime createdAt;

  const Vehicle({
    required this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.capacity,
    required this.status,
    this.assignedDriverId,
    this.assignedDriverName,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isAvailable => status == VehicleStatus.available && isActive;

  /// Check compatibility with container size
  bool canCarry(String containerSizeCode) {
    if (containerSizeCode == '20_FT' || containerSizeCode == '20 FT') {
      // 20 FT container can be carried by either 20 FT or 40 FT vehicles
      return true;
    }
    // 40 FT container requires 40 FT vehicle
    return capacity == '40 FT' || capacity == '40_FT';
  }

  Vehicle copyWith({
    String? id,
    String? vehicleNumber,
    String? vehicleType,
    String? capacity,
    VehicleStatus? status,
    String? assignedDriverId,
    String? assignedDriverName,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      assignedDriverId: assignedDriverId,
      assignedDriverName: assignedDriverName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'capacity': capacity,
      'status': status.code,
      'assignedDriverId': assignedDriverId,
      'assignedDriverName': assignedDriverName,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      capacity: json['capacity'] as String,
      status: VehicleStatus.fromCode(json['status'] as String),
      assignedDriverId: json['assignedDriverId'] as String?,
      assignedDriverName: json['assignedDriverName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
