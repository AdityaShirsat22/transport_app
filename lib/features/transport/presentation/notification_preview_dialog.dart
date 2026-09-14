import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/notification_log.dart';
import '../domain/transport_model.dart';

class NotificationPreviewDialog extends StatelessWidget {
  final NotificationLog? log;
  final Transport? transport;

  const NotificationPreviewDialog({
    super.key,
    this.log,
    this.transport,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRecipientName = log?.recipientName ?? transport?.partyName ?? 'Customer';
    final effectiveRecipientPhone = log?.recipientMobile ?? '9820011223';
    final effectiveSentAt = log?.sentAt ?? transport?.createdAt ?? DateTime.now();
    final effectiveMessage = log?.messageBody ??
        '''FreightOps Dispatch Update:
Container: ${transport?.containerNumber ?? "MSCU1234567"} (${transport?.containerSize.label ?? "40 FT"} ${transport?.shipmentType.label ?? "Export"})
Booking Ref: ${transport?.bookingNumber ?? "BK-2026"}
Truck: ${transport?.vehicleNumber ?? "MH-04-AB-1234"}
Driver: ${transport?.driverName ?? "Rajesh Kumar"} (${transport?.driverMobile ?? "9876543210"})
Route: ${transport?.fromLocationName ?? "Origin"} to ${transport?.toLocationName ?? "Destination"}
Status: ASSIGNED / DISPATCHED''';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat, color: Color(0xFF25D366), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WHATSAPP NOTIFICATION',
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Simulated Dispatch • ${DateFormatter.formatDateTime(effectiveSentAt)}',
                              style: AppTextStyles.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.greenBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.done_all, color: AppColors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'SENT',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: const Color(0xFF065F46),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 12),

            // Recipient info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Recipient: $effectiveRecipientName',
                    style: AppTextStyles.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(effectiveRecipientPhone, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 14),

            // Chat Bubble
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCF8C6).withValues(alpha: 0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(2),
                ),
                border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    effectiveMessage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF1F2937),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormatter.formatTime(effectiveSentAt),
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all, size: 14, color: Color(0xFF34B7F1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Cloud API & SMS Webhook simulation',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11, fontStyle: FontStyle.italic),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  text: 'Close',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
