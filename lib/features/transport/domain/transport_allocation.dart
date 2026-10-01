/// Represents a single vehicle+driver slot assigned to a transport booking.
/// A transport can have up to 5 such slots (allocations).
class TransportAllocation {
  final String id;
  final String transportId;
  final int slotIndex; // 0–4
  final String vehicleId;
  final String vehicleNumber;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;
  final String? containerNumber; // optional – per-slot container number
  final String? sealNumber; // optional – per-slot seal number
  final DateTime assignedAt;

  const TransportAllocation({
    required this.id,
    required this.transportId,
    required this.slotIndex,
    required this.vehicleId,
    required this.vehicleNumber,
    this.driverId,
    this.driverName,
    this.driverMobile,
    this.containerNumber,
    this.sealNumber,
    required this.assignedAt,
  });

  TransportAllocation copyWith({
    String? id,
    String? transportId,
    int? slotIndex,
    String? vehicleId,
    String? vehicleNumber,
    String? driverId,
    String? driverName,
    String? driverMobile,
    String? containerNumber,
    String? sealNumber,
    DateTime? assignedAt,
  }) {
    return TransportAllocation(
      id: id ?? this.id,
      transportId: transportId ?? this.transportId,
      slotIndex: slotIndex ?? this.slotIndex,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverMobile: driverMobile ?? this.driverMobile,
      containerNumber: containerNumber ?? this.containerNumber,
      sealNumber: sealNumber ?? this.sealNumber,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'transport_id': transportId,
        'slot_index': slotIndex,
        'vehicle_id': vehicleId,
        'vehicle_number': vehicleNumber,
        'driver_id': driverId,
        'driver_name': driverName,
        'driver_mobile': driverMobile,
        'container_number': containerNumber,
        'seal_number': sealNumber,
        'assigned_at': assignedAt.toIso8601String(),
      };

  factory TransportAllocation.fromJson(Map<String, dynamic> json) =>
      TransportAllocation(
        id: json['id'] as String,
        transportId: json['transport_id'] as String,
        slotIndex: (json['slot_index'] as num).toInt(),
        vehicleId: json['vehicle_id'] as String,
        vehicleNumber: json['vehicle_number'] as String,
        driverId: json['driver_id'] as String?,
        driverName: json['driver_name'] as String?,
        driverMobile: json['driver_mobile'] as String?,
        containerNumber: json['container_number'] as String?,
        sealNumber: json['seal_number'] as String?,
        assignedAt: DateTime.parse(json['assigned_at'] as String),
      );
}
