import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/vehicle_status.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/vehicle_model.dart';
import 'vehicle_form_dialog.dart';
import 'vehicle_view_model.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = VehicleFormDialog(
      onSave: (vehNum, type, cap, status) {
        final success = ref.read(vehicleViewModelProvider.notifier).addVehicle(
              vehicleNumber: vehNum,
              vehicleType: type,
              capacity: cap,
              status: status,
            );
        if (!success) {
          final error = ref.read(vehicleViewModelProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Failed to add vehicle'), backgroundColor: AppColors.red),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle added successfully'), backgroundColor: AppColors.green),
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

  void _showEditDialog(BuildContext context, WidgetRef ref, Vehicle vehicle) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = VehicleFormDialog(
      initialVehicle: vehicle,
      onSave: (vehNum, type, cap, status) {
        final updated = vehicle.copyWith(
          vehicleNumber: vehNum,
          vehicleType: type,
          capacity: cap,
          status: status,
        );
        ref.read(vehicleViewModelProvider.notifier).updateVehicle(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle updated successfully'), backgroundColor: AppColors.green),
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

  void _showStatusSheet(BuildContext context, WidgetRef ref, Vehicle vehicle) {
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
                child: Text('Change Status: ${vehicle.vehicleNumber}', style: AppTextStyles.headingSmall),
              ),
              const Divider(),
              ...VehicleStatus.values.map((status) {
                final isCurrent = status == vehicle.status;
                return ListTile(
                  leading: StatusBadge.fromVehicle(status),
                  title: Text(status.label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                  trailing: isCurrent ? const Icon(Icons.check, color: AppColors.accent) : null,
                  onTap: () {
                    ref.read(vehicleViewModelProvider.notifier).updateStatus(vehicle.id, status);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Status updated to ${status.label}'), backgroundColor: AppColors.accent),
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
    final state = ref.watch(vehicleViewModelProvider);
    final notifier = ref.read(vehicleViewModelProvider.notifier);
    final vehicles = state.filteredVehicles;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Vehicle Fleet Master',
                subtitle: 'Manage trucks, trailers, capacity, and current assignment status',
                actions: [
                  AppButton(
                    text: 'Add Vehicle',
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
                        Text('Vehicle Fleet', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${vehicles.length} trucks registered', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search number, type, driver...',
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
                  ...VehicleStatus.values.map((s) {
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
            if (vehicles.isEmpty)
              const EmptyState(
                title: 'No Vehicles Found',
                message: 'No vehicles match your active search or filters. Try adjusting your search query.',
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vehicles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final v = vehicles[i];
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.blue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.local_shipping, size: 18, color: AppColors.blue),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      v.vehicleNumber,
                                      style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge.fromVehicle(v.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${v.vehicleType} • Capacity: ${v.capacity}', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                          'Assigned Driver: ${v.assignedDriverName ?? "None (Unassigned)"}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: v.assignedDriverName != null ? AppColors.textPrimary : AppColors.textMuted,
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
                              onPressed: () => _showStatusSheet(context, ref, v),
                              icon: const Icon(Icons.swap_vert, size: 16),
                              label: const Text('Status'),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  tooltip: 'Edit Vehicle',
                                  onPressed: () => _showEditDialog(context, ref, v),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                                  tooltip: 'Delete Vehicle',
                                  onPressed: () => _confirmDelete(context, ref, v),
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
                        DataColumn(label: Text('Vehicle Number', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Capacity', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Assigned Driver', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: vehicles.map((v) {
                        return DataRow(
                          cells: [
                            DataCell(Text(v.vehicleNumber, style: AppTextStyles.labelLarge)),
                            DataCell(Text(v.vehicleType, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(v.capacity, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(v.assignedDriverName ?? 'None', style: AppTextStyles.bodySmall)),
                            DataCell(StatusBadge.fromVehicle(v.status)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    onPressed: () => _showEditDialog(context, ref, v),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.sync_alt, size: 18),
                                    onPressed: () => _showStatusSheet(context, ref, v),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                                    tooltip: 'Delete Vehicle',
                                    onPressed: () => _confirmDelete(context, ref, v),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Vehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete vehicle ${v.vehicleNumber}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              final success = ref.read(vehicleViewModelProvider.notifier).deleteVehicle(v.id);
              if (!success) {
                final err = ref.read(vehicleViewModelProvider).errorMessage ?? 'Cannot delete vehicle';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err), backgroundColor: AppColors.red),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vehicle ${v.vehicleNumber} deleted successfully'), backgroundColor: AppColors.green),
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
