import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/notification_log.dart';
import '../domain/transport_model.dart';
import 'notification_preview_dialog.dart';

class AssignmentProgressDialog extends StatefulWidget {
  final Transport transport;
  final bool wasAssigned;
  final String? failureReason;
  final NotificationLog? notificationLog;
  final ValueChanged<Transport>? onDone;
  final VoidCallback? onViewDetails;

  const AssignmentProgressDialog({
    super.key,
    required this.transport,
    this.wasAssigned = true,
    this.failureReason,
    this.notificationLog,
    this.onDone,
    this.onViewDetails,
  });

  @override
  State<AssignmentProgressDialog> createState() => _AssignmentProgressDialogState();
}

class _AssignmentProgressDialogState extends State<AssignmentProgressDialog> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _currentStep = 1);

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _currentStep = 2);

    if (!widget.wasAssigned && widget.transport.vehicleId == null) {
      setState(() => _currentStep = 4);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _currentStep = 3);

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _currentStep = 4);
  }

  void _openNotificationPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NotificationPreviewDialog(
        log: widget.notificationLog,
        transport: widget.transport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transport;
    final isPending = !widget.wasAssigned && t.vehicleId == null;
    final isComplete = _currentStep == 4;
    final isMobile = ResponsiveLayout.isMobile(context);

    final content = Padding(
      padding: EdgeInsets.fromLTRB(20, isMobile ? 12 : 24, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRANSPORT #${t.id}',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text('Automated Resource Engine', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: StatusBadge.fromTransport(isPending ? t.status : t.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Steps list
          _buildStepRow(
            index: 0,
            title: 'Verifying booking & capacity requirements',
            subTitle: 'Container size: ${t.containerSize.label} • Type: ${t.shipmentType.label}',
            isActive: _currentStep == 0,
            isDone: _currentStep >= 1,
            isError: false,
          ),
          const SizedBox(height: 12),
          _buildStepRow(
            index: 1,
            title: 'Matching available fleet vehicle',
            subTitle: isPending
                ? 'No matching ${t.containerSize.label} vehicle found in available fleet'
                : (_currentStep >= 2
                    ? 'Selected truck: ${t.vehicleNumber ?? "Assigned"}'
                    : 'Searching for AVAILABLE ${t.containerSize.label} trailer...'),
            isActive: _currentStep == 1,
            isDone: _currentStep >= 2 && !isPending,
            isError: isPending && _currentStep >= 2,
          ),
          const SizedBox(height: 12),
          if (!isPending) ...[
            _buildStepRow(
              index: 2,
              title: 'Assigning licensed commercial driver',
              subTitle: _currentStep >= 3
                  ? 'Assigned: ${t.driverName ?? "Active Driver"}'
                  : 'Matching active driver...',
              isActive: _currentStep == 2,
              isDone: _currentStep >= 3,
              isError: false,
            ),
            const SizedBox(height: 12),
            _buildStepRow(
              index: 3,
              title: 'Transmitting customer notification...',
              subTitle: _currentStep >= 4
                  ? 'WhatsApp dispatch notification sent to ${t.partyName}'
                  : 'Preparing messaging template...',
              isActive: _currentStep == 3,
              isDone: _currentStep >= 4,
              isError: false,
            ),
          ],

          // Outcome Card
          if (isComplete) ...[
            const SizedBox(height: 16),
            if (isPending)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.amberBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text('Vehicle Pending', style: AppTextStyles.labelMedium.copyWith(color: const Color(0xFF92400E))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.failureReason ?? 'All suitable vehicles are currently busy. Flagged for manager action.',
                      style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF92400E)),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.greenBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.green, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transport Assigned Successfully', style: AppTextStyles.labelMedium.copyWith(color: const Color(0xFF065F46))),
                          const SizedBox(height: 2),
                          Text('Vehicle and driver marked ON TRIP.', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF065F46))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],

          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isComplete && !isPending) ...[
                if (isMobile)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openNotificationPreview,
                      icon: const Icon(Icons.chat_outlined, size: 16),
                      label: const Text('WhatsApp'),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _openNotificationPreview,
                    icon: const Icon(Icons.chat_outlined, size: 16),
                    label: const Text('WhatsApp'),
                  ),
                const SizedBox(width: 10),
              ],
              if (isMobile)
                Expanded(
                  child: AppButton(
                    text: 'View Details',
                    icon: Icons.arrow_forward,
                    onPressed: isComplete
                        ? () {
                            if (widget.onDone != null) {
                              widget.onDone!(t);
                            } else if (widget.onViewDetails != null) {
                              widget.onViewDetails!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          }
                        : null,
                  ),
                )
              else
                AppButton(
                  text: 'View Details',
                  icon: Icons.arrow_forward,
                  onPressed: isComplete
                      ? () {
                          if (widget.onDone != null) {
                            widget.onDone!(t);
                          } else if (widget.onViewDetails != null) {
                            widget.onViewDetails!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                ),
            ],
          ),
        ],
      ),
    );

    if (isMobile) {
      return SafeArea(child: content);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: content,
      ),
    );
  }

  Widget _buildStepRow({
    required int index,
    required String title,
    required String subTitle,
    required bool isActive,
    required bool isDone,
    required bool isError,
  }) {
    Widget indicator;
    if (isError) {
      indicator = const Icon(Icons.error_outline, color: AppColors.red, size: 20);
    } else if (isDone) {
      indicator = const Icon(Icons.check_circle, color: AppColors.green, size: 20);
    } else if (isActive) {
      indicator = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation(AppColors.accent)),
      );
    } else {
      indicator = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.slateBorder, width: 2),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 2), child: indicator),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isActive || isDone ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subTitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isError
                      ? AppColors.red
                      : (isDone ? AppColors.green : AppColors.textMuted),
                  fontWeight: isDone || isError ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
