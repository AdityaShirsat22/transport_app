import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/driver_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/driver_model.dart';
import 'driver_form_dialog.dart';
import 'driver_view_model.dart';

class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = DriverFormDialog(
      onSave: (name, mobile, status) {
        final success = ref.read(driverViewModelProvider.notifier).addDriver(
              name: name,
              mobileNumber: mobile,
              status: status,
            );
        if (!success) {
          final error = ref.read(driverViewModelProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Failed to register driver'), backgroundColor: AppColors.red),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Driver registered successfully'), backgroundColor: AppColors.green),
          );
        }
      },
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => form,
      );
    } else {
      showDialog(context: context, builder: (_) => form);
    }
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Driver driver) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = DriverFormDialog(
      initialDriver: driver,
      onSave: (name, mobile, status) {
        final updated = driver.copyWith(
          name: name,
          mobileNumber: mobile,
          status: status,
        );
        ref.read(driverViewModelProvider.notifier).updateDriver(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver updated successfully'), backgroundColor: AppColors.green),
        );
      },
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => form,
      );
    } else {
      showDialog(context: context, builder: (_) => form);
    }
  }

  void _showStatusSheet(BuildContext context, WidgetRef ref, Driver driver) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text('Change Duty Status: ${driver.name}', style: AppTextStyles.headingSmall),
              ),
              const Divider(),
              ...DriverStatus.values.map((status) {
                final isCurrent = status == driver.status;
                return ListTile(
                  leading: StatusBadge.fromDriver(status),
                  title: Text(status.label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                  trailing: isCurrent ? const Icon(Icons.check, color: AppColors.accent) : null,
                  onTap: () {
                    ref.read(driverViewModelProvider.notifier).updateStatus(driver.id, status);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Duty status updated to ${status.label}'), backgroundColor: AppColors.accent),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(driverViewModelProvider);
    final notifier = ref.read(driverViewModelProvider.notifier);
    final drivers = state.filteredDrivers;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Driver'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Driver Crew Master',
                subtitle: 'Manage commercial heavy transport drivers, contact details, and duty status',
                actions: [
                  AppButton(
                    text: 'Add Driver',
                    icon: Icons.add,
                    onPressed: () => _showAddDialog(context, ref),
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
                        Text('Drivers Crew', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${drivers.length} drivers registered', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search driver name, mobile...',
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
                    label: const Text('All Statuses'),
                    selected: state.statusFilter == null,
                    onSelected: (_) => notifier.setStatusFilter(null),
                  ),
                  const SizedBox(width: 8),
                  ...DriverStatus.values.map((s) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(s.label),
                        selected: state.statusFilter == s,
                        onSelected: (val) => notifier.setStatusFilter(val ? s : null),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content List
            if (drivers.isEmpty)
              const EmptyState(
                title: 'No Drivers Found',
                message: 'No drivers match your active search or filters. Try adjusting your query.',
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: drivers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final d = drivers[i];
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.purple.withValues(alpha: 0.15),
                                    child: Text(
                                      d.name.isNotEmpty ? d.name.substring(0, 1).toUpperCase() : 'D',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.purple),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.name,
                                          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          d.mobileNumber,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge.fromDriver(d.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Assigned Truck: ${d.currentVehicleNumber ?? "None"}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: d.currentVehicleNumber != null ? AppColors.textPrimary : AppColors.textMuted,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              onPressed: () => _showStatusSheet(context, ref, d),
                              icon: const Icon(Icons.swap_vert, size: 16),
                              label: const Text('Status'),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  tooltip: 'Edit Driver',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _showEditDialog(context, ref, d),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                                  tooltip: 'Delete Driver',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _confirmDelete(context, ref, d),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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
                      columns: const [
                        DataColumn(label: Text('Driver Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Assigned Vehicle', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: drivers.map((d) {
                        return DataRow(
                          cells: [
                            DataCell(Text(d.name, style: AppTextStyles.labelLarge)),
                            DataCell(Text(d.mobileNumber, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(d.currentVehicleNumber ?? 'None', style: AppTextStyles.bodySmall)),
                            DataCell(StatusBadge.fromDriver(d.status)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    onPressed: () => _showEditDialog(context, ref, d),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.sync_alt, size: 18),
                                    onPressed: () => _showStatusSheet(context, ref, d),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                                    tooltip: 'Delete Driver',
                                    onPressed: () => _confirmDelete(context, ref, d),
                                  ),
                                ],
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Driver d) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Driver'),
        content: Text('Are you sure you want to delete driver ${d.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              final success = ref.read(driverViewModelProvider.notifier).deleteDriver(d.id);
              if (!success) {
                final err = ref.read(driverViewModelProvider).errorMessage ?? 'Cannot delete driver';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err), backgroundColor: AppColors.red),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Driver ${d.name} deleted successfully'), backgroundColor: AppColors.green),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
