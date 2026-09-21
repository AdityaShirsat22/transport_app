import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/transport_status.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/auth/auth_provider.dart';
import '../domain/transport_model.dart';
import 'transport_view_model.dart';

class TransportListScreen extends ConsumerWidget {
  const TransportListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transportViewModelProvider);
    final notifier = ref.read(transportViewModelProvider.notifier);
    final transports = state.filteredTransports;
    final isMobile = ResponsiveLayout.isMobile(context);
    final isCoordinator = ref.watch(authProvider).user?.role == 'Coordinator';

    return Scaffold(
      floatingActionButton: isMobile && !isCoordinator
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/transport/create'),
              icon: const Icon(Icons.add),
              label: const Text('New Booking'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Transport Operations',
                subtitle: 'Active shipments, container assignments, fleet dispatching, and status monitoring',
                actions: [
                  if (!isCoordinator)
                    AppButton(
                      text: 'New Booking',
                      icon: Icons.add,
                      onPressed: () => context.go('/transport/create'),
                    ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transport Trips', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${transports.length} shipments found', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search container, ID, booking, party...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => notifier.setSearchQuery(''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips Strip
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: state.statusFilter == null,
                    onSelected: (_) => notifier.setStatusFilter(null),
                  ),
                  const SizedBox(width: 8),
                  ...[
                    TransportStatus.bookingCreated,
                    TransportStatus.vehiclePending,
                    TransportStatus.vehicleAssigned,
                    TransportStatus.containerPickedUp,
                    TransportStatus.atPortCfs,
                    TransportStatus.podReceived,
                    TransportStatus.completed,
                    TransportStatus.onHold,
                    TransportStatus.cancelled,
                  ].map((s) {
                    final isSelected = state.statusFilter == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(s.label),
                        selected: isSelected,
                        onSelected: (val) => notifier.setStatusFilter(val ? s : null),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content List
            if (transports.isEmpty)
              EmptyState(
                title: 'No Transport Bookings Found',
                message: 'No active transports match your active filters.',
                actionLabel: isCoordinator ? null : 'Create New Booking',
                onAction: isCoordinator ? null : () => context.go('/transport/create'),
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transports.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final t = transports[i];
                  return _buildTransportCard(context, ref, t, isCoordinator);
                },
              )
            else
              AppCard(
                padding: EdgeInsets.zero,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
                      showCheckboxColumn: false,
                      columns: [
                        const DataColumn(label: Text('Transport ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Booking No', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Container No', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Size / Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Route', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: Text('Created Date', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text(isCoordinator ? 'View' : 'Actions', style: const TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: transports.map((t) {
                        return DataRow(
                          onSelectChanged: (_) => context.go('/transport/${t.id}'),
                          cells: [
                            DataCell(
                              Text(
                                t.id,
                                style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataCell(Text(t.bookingNumber, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(t.containerNumber.isNotEmpty ? t.containerNumber : '—', style: AppTextStyles.codeMono)),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 160),
                                child: Text(t.partyName, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            DataCell(
                              Text('${t.containerSize.label} • ${t.shipmentType.label}', style: AppTextStyles.bodySmall),
                            ),
                            DataCell(
                              Text(
                                t.vehicleNumber ?? 'Pending',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: t.vehicleNumber != null ? AppColors.textPrimary : AppColors.amber,
                                  fontWeight: t.vehicleNumber != null ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                t.driverName ?? 'Pending',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: t.driverName != null ? AppColors.textPrimary : AppColors.amber,
                                ),
                              ),
                            ),
                            DataCell(Text('${t.fromLocationName} → ${t.toLocationName}', style: AppTextStyles.bodySmall)),
                            DataCell(StatusBadge.fromTransport(t.status)),
                            DataCell(Text(DateFormatter.formatShortDate(t.createdAt), style: AppTextStyles.bodySmall)),
                            DataCell(
                              isCoordinator
                                  ? IconButton(
                                      icon: const Icon(Icons.chevron_right, size: 20, color: AppColors.accent),
                                      tooltip: 'View Details',
                                      onPressed: () => context.go('/transport/${t.id}'),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                                      tooltip: 'Delete Transport',
                                      onPressed: () => _confirmDeleteTransport(context, ref, t),
                                    ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            SizedBox(height: isMobile ? 80 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportCard(BuildContext context, WidgetRef ref, Transport t, bool isCoordinator) {
    return AppCard(
      onTap: () => context.go('/transport/${t.id}'),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.id,
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: StatusBadge.fromTransport(t.status),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${t.containerSize.label} ${t.shipmentType.label}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(t.containerNumber.isNotEmpty ? t.containerNumber : 'NO CONTAINER', style: AppTextStyles.codeMono.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '• ${t.partyName}',
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.navigation_outlined, size: 14, color: AppColors.accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${t.fromLocationName}  →  ${t.toLocationName}',
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Truck: ${t.vehicleNumber ?? "Pending"}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.vehicleNumber != null ? AppColors.textPrimary : AppColors.amber,
                        fontWeight: t.vehicleNumber != null ? FontWeight.normal : FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Driver: ${t.driverName ?? "Pending"}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.driverName != null ? AppColors.textSecondary : AppColors.amber,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCoordinator)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                      tooltip: 'Delete Transport',
                      onPressed: () => _confirmDeleteTransport(context, ref, t),
                    ),
                  const SizedBox(width: 4),
                  const Text(
                    'Details',
                    style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.accent),
                ],
              ),
            ],
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
