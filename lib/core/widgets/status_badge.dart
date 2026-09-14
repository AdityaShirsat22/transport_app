import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../enums/driver_status.dart';
import '../enums/transport_status.dart';
import '../enums/vehicle_status.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color dotColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.dotColor,
  });

  factory StatusBadge.fromTransport(TransportStatus status) {
    switch (status) {
      case TransportStatus.completed:
      case TransportStatus.podReceived:
      case TransportStatus.containerDelivered:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.greenLight,
          textColor: const Color(0xFF065F46),
          borderColor: AppColors.greenBorder,
          dotColor: AppColors.green,
        );

      case TransportStatus.vehicleAssigned:
      case TransportStatus.driverAssigned:
      case TransportStatus.vehicleReported:
      case TransportStatus.containerPickedUp:
      case TransportStatus.inTransit:
      case TransportStatus.atPortCfs:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.blueLight,
          textColor: const Color(0xFF1E40AF),
          borderColor: AppColors.blueBorder,
          dotColor: AppColors.blue,
        );

      case TransportStatus.vehiclePending:
      case TransportStatus.bookingCreated:
      case TransportStatus.newStatus:
      case TransportStatus.onHold:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.amberLight,
          textColor: const Color(0xFF92400E),
          borderColor: AppColors.amberBorder,
          dotColor: AppColors.amber,
        );

      case TransportStatus.cancelled:
      case TransportStatus.vehicleBreakdown:
      case TransportStatus.containerIssue:
      case TransportStatus.documentIssue:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.redLight,
          textColor: const Color(0xFF991B1B),
          borderColor: AppColors.redBorder,
          dotColor: AppColors.red,
        );
    }
  }

  factory StatusBadge.fromVehicle(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.available:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.greenLight,
          textColor: const Color(0xFF065F46),
          borderColor: AppColors.greenBorder,
          dotColor: AppColors.green,
        );
      case VehicleStatus.onTrip:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.blueLight,
          textColor: const Color(0xFF1E40AF),
          borderColor: AppColors.blueBorder,
          dotColor: AppColors.blue,
        );
      case VehicleStatus.maintenance:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.amberLight,
          textColor: const Color(0xFF92400E),
          borderColor: AppColors.amberBorder,
          dotColor: AppColors.amber,
        );
      case VehicleStatus.inactive:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.slateLight,
          textColor: AppColors.slate,
          borderColor: AppColors.slateBorder,
          dotColor: AppColors.slate,
        );
    }
  }

  factory StatusBadge.fromDriver(DriverStatus status) {
    switch (status) {
      case DriverStatus.available:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.greenLight,
          textColor: const Color(0xFF065F46),
          borderColor: AppColors.greenBorder,
          dotColor: AppColors.green,
        );
      case DriverStatus.onTrip:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.blueLight,
          textColor: const Color(0xFF1E40AF),
          borderColor: AppColors.blueBorder,
          dotColor: AppColors.blue,
        );
      case DriverStatus.offDuty:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.amberLight,
          textColor: const Color(0xFF92400E),
          borderColor: AppColors.amberBorder,
          dotColor: AppColors.amber,
        );
      case DriverStatus.inactive:
        return StatusBadge(
          label: status.label,
          backgroundColor: AppColors.slateLight,
          textColor: AppColors.slate,
          borderColor: AppColors.slateBorder,
          dotColor: AppColors.slate,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 10.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
