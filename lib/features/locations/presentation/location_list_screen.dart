import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/location_type.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/location_model.dart';
import 'location_dialog.dart';
import 'location_view_model.dart';

class LocationListScreen extends ConsumerWidget {
  const LocationListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = LocationDialog(
      onSave: (name, type) {
        ref.read(locationViewModelProvider.notifier).addLocation(name: name, type: type);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location hub added successfully'), backgroundColor: AppColors.green),
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

  void _showEditDialog(BuildContext context, WidgetRef ref, Location item) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = LocationDialog(
      initialLocation: item,
      onSave: (name, type) {
        final updated = item.copyWith(name: name, type: type);
        ref.read(locationViewModelProvider.notifier).updateLocation(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully'), backgroundColor: AppColors.green),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationViewModelProvider);
    final notifier = ref.read(locationViewModelProvider.notifier);
    final items = state.filteredLocations;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Location'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Location & Hub Master',
                subtitle: 'Factories, inland container depots (ICD), logistics parks, and delivery destinations',
                actions: [
                  AppButton(
                    text: 'Add Location',
                    icon: Icons.location_on_outlined,
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
                        Text('Locations & Hubs', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${items.length} logistics facilities', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search location hub or type...',
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
                    label: const Text('All Types'),
                    selected: state.typeFilter == null,
                    onSelected: (_) => notifier.setTypeFilter(null),
                  ),
                  const SizedBox(width: 8),
                  ...LocationType.values.map((t) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(t.label),
                        selected: state.typeFilter == t,
                        onSelected: (val) => notifier.setTypeFilter(val ? t : null),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Content List
            if (items.isEmpty)
              const EmptyState(
                title: 'No Locations Found',
                message: 'No location hubs match your active search or filters.',
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final loc = items[i];
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.location_on, size: 20, color: AppColors.green),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.name, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  loc.type.label,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Edit Location',
                              onPressed: () => _showEditDialog(context, ref, loc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                              tooltip: 'Delete Location',
                              onPressed: () => _confirmDelete(context, ref, loc),
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
                        DataColumn(label: Text('Location / Hub Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: items.map((loc) {
                        return DataRow(
                          cells: [
                            DataCell(Text(loc.name, style: AppTextStyles.labelLarge)),
                            DataCell(Text(loc.type.label, style: AppTextStyles.bodyMedium)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    onPressed: () => _showEditDialog(context, ref, loc),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                                    tooltip: 'Delete Location',
                                    onPressed: () => _confirmDelete(context, ref, loc),
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

  void _confirmDelete(BuildContext context, WidgetRef ref, Location loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text('Are you sure you want to delete location "${loc.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(locationViewModelProvider.notifier).deleteLocation(loc.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location "${loc.name}" deleted successfully'), backgroundColor: AppColors.green),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
