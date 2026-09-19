import '../../../core/enums/container_size.dart';
import '../../../core/enums/shipment_type.dart';
import '../../../core/enums/transport_status.dart';
import 'pod_document.dart';

class Transport {
  final String id;
  final String bookingNumber;
  final String containerNumber;
  final String sealNumber;
  final ContainerSize containerSize;
  final ShipmentType shipmentType;

  // Foreign keys
  final String partyId;
  final String partyName;
  final String? partyMobile;
  final String bookingPartyId;
  final String bookingPartyName;
  final String shippingLineId;
  final String shippingLineName;

  final String fromLocationId;
  final String fromLocationName;
  final String toLocationId;
  final String toLocationName;
  final String portCfsId;
  final String portCfsName;

  // Assignment
  final String? vehicleId;
  final String? vehicleNumber;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;

  // Status & Timestamps
  final TransportStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completionDate;

  // POD
  final PodDocument? pod;

  // Exception note
  final String? exceptionReason;

  const Transport({
    required this.id,
    required this.bookingNumber,
    required this.containerNumber,
    required this.sealNumber,
    required this.containerSize,
    required this.shipmentType,
    required this.partyId,
    required this.partyName,
    this.partyMobile,
    required this.bookingPartyId,
    required this.bookingPartyName,
    required this.shippingLineId,
    required this.shippingLineName,
    required this.fromLocationId,
    required this.fromLocationName,
    required this.toLocationId,
    required this.toLocationName,
    required this.portCfsId,
    required this.portCfsName,
    this.vehicleId,
    this.vehicleNumber,
    this.driverId,
    this.driverName,
    this.driverMobile,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completionDate,
    this.pod,
    this.exceptionReason,
  });

  bool get isAssigned => vehicleId != null && driverId != null;
  bool get hasPod => pod != null;
  bool get canBeCompleted => hasPod && status == TransportStatus.podReceived;

  Transport copyWith({
    String? id,
    String? bookingNumber,
    String? containerNumber,
    String? sealNumber,
    ContainerSize? containerSize,
    ShipmentType? shipmentType,
    String? partyId,
    String? partyName,
    String? partyMobile,
    String? bookingPartyId,
    String? bookingPartyName,
    String? shippingLineId,
    String? shippingLineName,
    String? fromLocationId,
    String? fromLocationName,
    String? toLocationId,
    String? toLocationName,
    String? portCfsId,
    String? portCfsName,
    String? vehicleId,
    String? vehicleNumber,
    String? driverId,
    String? driverName,
    String? driverMobile,
    TransportStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completionDate,
    PodDocument? pod,
    String? exceptionReason,
    bool clearVehicle = false,
    bool clearDriver = false,
    bool clearException = false,
    bool clearPod = false,
  }) {
    return Transport(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      containerNumber: containerNumber ?? this.containerNumber,
      sealNumber: sealNumber ?? this.sealNumber,
      containerSize: containerSize ?? this.containerSize,
      shipmentType: shipmentType ?? this.shipmentType,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      partyMobile: partyMobile ?? this.partyMobile,
      bookingPartyId: bookingPartyId ?? this.bookingPartyId,
      bookingPartyName: bookingPartyName ?? this.bookingPartyName,
      shippingLineId: shippingLineId ?? this.shippingLineId,
      shippingLineName: shippingLineName ?? this.shippingLineName,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      fromLocationName: fromLocationName ?? this.fromLocationName,
      toLocationId: toLocationId ?? this.toLocationId,
      toLocationName: toLocationName ?? this.toLocationName,
      portCfsId: portCfsId ?? this.portCfsId,
      portCfsName: portCfsName ?? this.portCfsName,
      vehicleId: clearVehicle ? null : (vehicleId ?? this.vehicleId),
      vehicleNumber: clearVehicle ? null : (vehicleNumber ?? this.vehicleNumber),
      driverId: clearDriver ? null : (driverId ?? this.driverId),
      driverName: clearDriver ? null : (driverName ?? this.driverName),
      driverMobile: clearDriver ? null : (driverMobile ?? this.driverMobile),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completionDate: completionDate ?? this.completionDate,
      pod: clearPod ? null : (pod ?? this.pod),
      exceptionReason: clearException ? null : (exceptionReason ?? this.exceptionReason),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingNumber': bookingNumber,
      'containerNumber': containerNumber,
      'sealNumber': sealNumber,
      'containerSize': containerSize.code,
      'shipmentType': shipmentType.code,
      'partyId': partyId,
      'partyName': partyName,
      'partyMobile': partyMobile,
      'bookingPartyId': bookingPartyId,
      'bookingPartyName': bookingPartyName,
      'shippingLineId': shippingLineId,
      'shippingLineName': shippingLineName,
      'fromLocationId': fromLocationId,
      'fromLocationName': fromLocationName,
      'toLocationId': toLocationId,
      'toLocationName': toLocationName,
      'portCfsId': portCfsId,
      'portCfsName': portCfsName,
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'driverId': driverId,
      'driverName': driverName,
      'driverMobile': driverMobile,
      'status': status.code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'pod': pod?.toJson(),
      'exceptionReason': exceptionReason,
    };
  }

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'] as String,
      bookingNumber: json['bookingNumber'] as String,
      containerNumber: json['containerNumber'] as String,
      sealNumber: json['sealNumber'] as String,
      containerSize: ContainerSize.fromCode(json['containerSize'] as String),
      shipmentType: ShipmentType.fromCode(json['shipmentType'] as String),
      partyId: json['partyId'] as String,
      partyName: json['partyName'] as String,
      partyMobile: json['partyMobile'] as String?,
      bookingPartyId: json['bookingPartyId'] as String,
      bookingPartyName: json['bookingPartyName'] as String,
      shippingLineId: json['shippingLineId'] as String,
      shippingLineName: json['shippingLineName'] as String,
      fromLocationId: json['fromLocationId'] as String,
      fromLocationName: json['fromLocationName'] as String,
      toLocationId: json['toLocationId'] as String,
      toLocationName: json['toLocationName'] as String,
      portCfsId: json['portCfsId'] as String,
      portCfsName: json['portCfsName'] as String,
      vehicleId: json['vehicleId'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverMobile: json['driverMobile'] as String?,
      status: TransportStatus.fromCode(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      pod: json['pod'] != null
          ? PodDocument.fromJson(json['pod'] as Map<String, dynamic>)
          : null,
      exceptionReason: json['exceptionReason'] as String?,
    );
  }
}
