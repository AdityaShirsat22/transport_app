import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/transport_status.dart';
import '../../../core/services/pod_service.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/transport_model.dart';
import 'notification_preview_dialog.dart';
import 'reassign_dialog.dart';
import 'transport_view_model.dart';

class TransportDetailsScreen extends ConsumerWidget {
  final String transportId;

  const TransportDetailsScreen({super.key, required this.transportId});

  void _showUpdateStatusSheet(BuildContext context, WidgetRef ref, Transport transport) {
    final next = transport.status.nextStatus;
    if (next == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Progress Transport Status', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),
              const Divider(height: 16),
              const SizedBox(height: 8),
              Text('Advance transport #${transport.id} from:'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(child: StatusBadge.fromTransport(transport.status)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                  const SizedBox(width: 8),
                  Flexible(child: StatusBadge.fromTransport(next)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'This will record a timestamped audit entry and advance the shipment.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetCtx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(sheetCtx).pop();
                        ref.read(transportViewModelProvider.notifier).updateStatus(transport.id, next);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Transport advanced to ${next.label}'), backgroundColor: AppColors.green),
                        );
                      },
                      child: const Text('Confirm Progression'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadPodSheet(BuildContext context, WidgetRef ref, Transport transport) {
    String docType = 'PDF';
    final cntrDoc = transport.containerNumber.isNotEmpty ? transport.containerNumber : transport.bookingNumber;
    final ctrl = TextEditingController(text: 'POD_${cntrDoc}_Signed.pdf');
    File? pickedFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetInnerCtx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(sheetInnerCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Upload Proof of Delivery (POD)', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),
              const Divider(height: 16),
              const SizedBox(height: 6),
              Text('Attach verified delivery slip or signed gate pass:', style: AppTextStyles.bodySmall),
              const SizedBox(height: 14),
              // File Picker Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
                icon: const Icon(Icons.folder_open, size: 20),
                label: Text(
                  pickedFile != null
                      ? 'Selected: ${pickedFile!.path.split(Platform.pathSeparator).last}'
                      : 'Choose Document from Device (PDF / Image)',
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () async {
                  final file = await ref.read(podServiceProvider).pickPodFile();
                  if (file != null) {
                    setSheetState(() {
                      pickedFile = file;
                      final name = file.path.split(Platform.pathSeparator).last;
                      ctrl.text = name;
                      docType = name.toLowerCase().endsWith('.pdf') ? 'PDF' : 'IMAGE';
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('PDF Document'),
                    selected: docType == 'PDF',
                    onSelected: (val) {
                      setSheetState(() {
                        docType = 'PDF';
                        ctrl.text = 'POD_${cntrDoc}_Signed.pdf';
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Camera Photo / Scan'),
                    selected: docType == 'IMAGE',
                    onSelected: (val) {
                      setSheetState(() {
                        docType = 'IMAGE';
                        ctrl.text = 'POD_${cntrDoc}_Photo.jpg';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  labelText: 'Document Reference / Filename',
                  prefixIcon: Icon(docType == 'PDF' ? Icons.picture_as_pdf : Icons.camera_alt, size: 18),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Upload & Confirm POD'),
                  onPressed: () async {
                    Navigator.of(sheetCtx).pop();
                    if (pickedFile != null) {
                      await ref.read(podServiceProvider).processPodUpload(
                            transportId: transport.id,
                            file: pickedFile!,
                          );
                      ref.read(transportViewModelProvider.notifier).loadTransports();
                    } else {
                      ref.read(transportViewModelProvider.notifier).uploadPod(
                            transportId: transport.id,
                            fileName: ctrl.text.trim(),
                            fileType: docType,
                            fileSize: 1024 * 350,
                          );
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('POD successfully verified, stored, and attached!'),
                          backgroundColor: AppColors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompleteSheet(BuildContext context, WidgetRef ref, Transport transport) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Complete Transport Operation', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),
              const Divider(height: 16),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, color: AppColors.green, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'POD has been received and verified. Completing this trip will automatically release the assigned vehicle and driver back to AVAILABLE.',
                        style: TextStyle(fontSize: 12, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Vehicle: ${transport.vehicleNumber ?? "None"} → AVAILABLE', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text('Driver: ${transport.driverName ?? "None"} → AVAILABLE', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetCtx).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
                      onPressed: () {
                        Navigator.of(sheetCtx).pop();
                        ref.read(transportViewModelProvider.notifier).completeTransport(transport.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transport completed! Vehicle and driver released to AVAILABLE.'),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      },
                      child: const Text('Complete Trip'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExceptionSheet(BuildContext context, WidgetRef ref, Transport transport) {
    final reasonCtrl = TextEditingController();
    TransportStatus selectedException = TransportStatus.vehicleBreakdown;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetInnerCtx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(sheetInnerCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Record Transport Exception', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                  ),
                ],
              ),
              const Divider(height: 16),
              const SizedBox(height: 6),
              Text('Select incident type and note operational context:', style: AppTextStyles.bodySmall),
              const SizedBox(height: 14),
              DropdownButtonFormField<TransportStatus>(
                initialValue: selectedException,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Exception Type'),
                items: const [
                  DropdownMenuItem(value: TransportStatus.vehicleBreakdown, child: Text('Vehicle Breakdown')),
                  DropdownMenuItem(value: TransportStatus.onHold, child: Text('On Hold / Delayed')),
                  DropdownMenuItem(value: TransportStatus.containerIssue, child: Text('Container Damage / Issue')),
                  DropdownMenuItem(value: TransportStatus.documentIssue, child: Text('Customs / Document Issue')),
                  DropdownMenuItem(value: TransportStatus.cancelled, child: Text('Cancel Transport')),
                ],
                onChanged: (val) {
                  if (val != null) setSheetState(() => selectedException = val);
                },
              ),
              const SizedBox(height: 14),
              TextField(
                controller: reasonCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Incident Notes / Reason',
                  hintText: 'e.g. Engine fault on highway, customer hold, customs check',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                  onPressed: () {
                    Navigator.of(sheetCtx).pop();
                    ref.read(transportViewModelProvider.notifier).updateStatus(
                          transport.id,
                          selectedException,
                          exceptionReason: reasonCtrl.text.trim(),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Incident logged: ${selectedException.label}'),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  },
                  child: const Text('Apply Exception'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationPreview(BuildContext context, Transport transport) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => NotificationPreviewDialog(transport: transport),
    );
  }

  void _showReassignSheet(BuildContext context, Transport transport) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => ReassignDialog(transport: transport),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transportState = ref.watch(transportViewModelProvider);
    final transport = transportState.transports.cast<Transport?>().firstWhere(
          (t) => t?.id == transportId,
          orElse: () => null,
        );

    if (transport == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/transport'))),
        body: Center(
          child: EmptyState(
            title: 'Transport Not Found',
            message: 'No transport matching ID $transportId could be found.',
            actionLabel: 'Back to Transport Operations',
            onAction: () => context.go('/transport'),
          ),
        ),
      );
    }

    final activityLogs = ref.watch(transportViewModelProvider.notifier).getActivityLogs(transport.id);
    final isMobile = ResponsiveLayout.isMobile(context);

    // Primary Next Action Button
    Widget? bottomActionButton;
    if (transport.canBeCompleted) {
      bottomActionButton = AppButton(
        text: 'COMPLETE TRANSPORT',
        icon: Icons.check_circle,
        onPressed: () => _showCompleteSheet(context, ref, transport),
      );
    } else if (transport.status == TransportStatus.containerDelivered && !transport.hasPod) {
      bottomActionButton = AppButton(
        text: 'UPLOAD PROOF OF DELIVERY (POD)',
        icon: Icons.upload_file,
        onPressed: () => _showUploadPodSheet(context, ref, transport),
      );
    } else if (transport.status.nextStatus != null && transport.status.isActive) {
      bottomActionButton = AppButton(
        text: 'ADVANCE: ${transport.status.nextStatus!.label.toUpperCase()}',
        icon: Icons.fast_forward,
        onPressed: () => _showUpdateStatusSheet(context, ref, transport),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/transport')),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transport.id, style: AppTextStyles.headingSmall),
            Text(
              '${transport.containerNumber.isNotEmpty ? transport.containerNumber : transport.bookingNumber} • ${transport.partyName}',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.red),
            tooltip: 'Delete Transport',
            onPressed: () => _confirmDeleteTransport(context, ref, transport),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (val) {
              if (val == 'whatsapp') _showNotificationPreview(context, transport);
              if (val == 'reassign') _showReassignSheet(context, transport);
              if (val == 'pod') _showUploadPodSheet(context, ref, transport);
              if (val == 'exception') _showExceptionSheet(context, ref, transport);
              if (val == 'delete') _confirmDeleteTransport(context, ref, transport);
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'whatsapp',
                child: Row(
                  children: [
                    Icon(Icons.chat, size: 18, color: AppColors.green),
                    SizedBox(width: 10),
                    Text('WhatsApp Dispatch Preview'),
                  ],
                ),
              ),
              if (transport.status.isActive) ...[
                const PopupMenuItem(
                  value: 'reassign',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, size: 18, color: AppColors.accent),
                      SizedBox(width: 10),
                      Text('Reassign Fleet / Driver'),
                    ],
                  ),
                ),
                if (!transport.hasPod)
                  const PopupMenuItem(
                    value: 'pod',
                    child: Row(
                      children: [
                        Icon(Icons.upload_file, size: 18, color: AppColors.purple),
                        SizedBox(width: 10),
                        Text('Upload POD'),
                      ],
                    ),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'exception',
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.red),
                      SizedBox(width: 10),
                      Text('Report Incident / Exception'),
                    ],
                  ),
                ),
              ],
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                    SizedBox(width: 10),
                    Text('Delete Transport', style: TextStyle(color: AppColors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: bottomActionButton != null
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: bottomActionButton,
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current Operational Status', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            StatusBadge.fromTransport(transport.status),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Booking #${transport.bookingNumber}',
                            style: AppTextStyles.codeMono.copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (transport.status.isException) ...[
                    const Divider(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.redLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: AppColors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Exception Logged: ${transport.exceptionReason ?? "Operational Hold"}',
                              style: const TextStyle(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Milestone Timeline
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip Milestone Timeline', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 2),
                  Text('Sequential progression across logistics checkpoints', style: AppTextStyles.bodySmall),
                  const Divider(height: 20),
                  _buildTimeline(context, transport),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Container & Route Details
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Container & Route', style: AppTextStyles.headingSmall),
                  const Divider(height: 16),
                  _buildDetailRow('Container Number', transport.containerNumber.isNotEmpty ? transport.containerNumber : '— (Pending)'),
                  _buildDetailRow('Size & Type', '${transport.containerSize.label} • ${transport.shipmentType.label}'),
                  _buildDetailRow('Custom Seal No', transport.sealNumber.isNotEmpty ? transport.sealNumber : '— (Pending)'),
                  _buildDetailRow('Customer', transport.partyName),
                  _buildDetailRow('Shipping Line', transport.shippingLineName),
                  _buildDetailRow('Origin (From)', transport.fromLocationName),
                  _buildDetailRow('Destination (To)', transport.toLocationName),
                  _buildDetailRow('Port / CFS Facility', transport.portCfsName),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Assigned Resources
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Assigned Fleet & Crew', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                      ),
                      if (transport.status.isActive) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _showReassignSheet(context, transport),
                          child: const Text('Reassign'),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.local_shipping, color: AppColors.blue, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle / Truck', style: AppTextStyles.bodySmall),
                            Text(
                              transport.vehicleNumber ?? 'PENDING AUTO-ASSIGNMENT',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: transport.vehicleNumber != null ? AppColors.textPrimary : AppColors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.person, color: AppColors.purple, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Driver', style: AppTextStyles.bodySmall),
                            Text(
                              transport.driverName ?? 'PENDING ASSIGNMENT',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: transport.driverName != null ? AppColors.textPrimary : AppColors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (transport.driverMobile != null)
                              Text(
                                transport.driverMobile!,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Proof of Delivery (POD) Section
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('Proof of Delivery (POD)', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                      ),
                      if (!transport.hasPod && transport.status.isActive) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _showUploadPodSheet(context, ref, transport),
                          icon: const Icon(Icons.upload, size: 16),
                          label: const Text('Upload'),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 16),
                  if (transport.hasPod) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.greenLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.task_alt, color: AppColors.green, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'POD Verified & Signed',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'File: ${transport.pod!.fileName}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.textMuted, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'POD document is required once the shipment is marked DELIVERED to complete and release resources.',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Audit Trail
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activity & Audit Trail', style: AppTextStyles.headingSmall),
                  const Divider(height: 16),
                  if (activityLogs.isEmpty)
                    Text('No activity records.', style: AppTextStyles.bodySmall)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activityLogs.length,
                      separatorBuilder: (ctx, i) => const Divider(height: 16),
                      itemBuilder: (ctx, i) {
                        final log = activityLogs[i];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(log.title, style: AppTextStyles.labelMedium),
                                  Text(log.description, style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormatter.formatDateTime(log.timestamp),
                                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, Transport transport) {
    final stages = [
      TransportStatus.bookingCreated,
      TransportStatus.vehicleAssigned,
      TransportStatus.driverAssigned,
      TransportStatus.vehicleReported,
      TransportStatus.containerPickedUp,
      TransportStatus.inTransit,
      TransportStatus.atPortCfs,
      TransportStatus.containerDelivered,
      TransportStatus.podReceived,
      TransportStatus.completed,
    ];

    final currentIndex = stages.indexOf(transport.status);

    return Column(
      children: stages.asMap().entries.map((entry) {
        final i = entry.key;
        final stage = entry.value;
        final isPassed = currentIndex >= 0 && i < currentIndex;
        final isCurrent = currentIndex == i;

        Color dotColor;
        if (isPassed) {
          dotColor = AppColors.green;
        } else if (isCurrent) {
          dotColor = transport.status.isException ? AppColors.red : AppColors.accent;
        } else {
          dotColor = AppColors.border;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isPassed ? AppColors.green : (isCurrent ? dotColor.withValues(alpha: 0.15) : Colors.transparent),
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  child: isPassed
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : (isCurrent
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                              ),
                            )
                          : null),
                ),
                if (i < stages.length - 1)
                  Container(
                    width: 2,
                    height: 24,
                    color: isPassed ? AppColors.green : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stage.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent
                              ? (transport.status.isException ? AppColors.red : AppColors.accent)
                              : (isPassed ? AppColors.textPrimary : AppColors.textMuted),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (transport.status.isException ? AppColors.red : AppColors.accent).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          transport.status.isException ? 'EXCEPTION' : 'ACTIVE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: transport.status.isException ? AppColors.red : AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransport(BuildContext context, WidgetRef ref, Transport t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transport Booking'),
        content: Text(
          'Are you sure you want to delete transport booking #${t.bookingNumber} (${t.id})?\n\n'
          'Assigned vehicle and driver (if any) will be released. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(transportViewModelProvider.notifier).deleteTransport(t.id);
              context.go('/transport');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transport #${t.bookingNumber} deleted successfully'),
                  backgroundColor: AppColors.green,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
