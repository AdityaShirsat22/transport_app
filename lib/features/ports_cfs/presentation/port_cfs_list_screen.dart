import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/enums/port_cfs_type.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/port_cfs_model.dart';
import 'port_cfs_dialog.dart';
import 'port_cfs_view_model.dart';

class PortCfsListScreen extends ConsumerWidget {
  const PortCfsListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = PortCfsDialog(
      onSave: (name, type, location) {
        ref.read(portCfsViewModelProvider.notifier).addPortCfs(name: name, type: type, location: location);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Port/CFS facility added successfully'), backgroundColor: AppColors.green),
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

  void _showEditDialog(BuildContext context, WidgetRef ref, PortCfs item) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = PortCfsDialog(
      initialItem: item,
      onSave: (name, type, location) {
        final updated = item.copyWith(name: name, type: type, location: location);
        ref.read(portCfsViewModelProvider.notifier).updatePortCfs(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Port/CFS facility updated successfully'), backgroundColor: AppColors.green),
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
    final state = ref.watch(portCfsViewModelProvider);
    final notifier = ref.read(portCfsViewModelProvider.notifier);
    final items = state.filteredItems;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Terminal'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Port & CFS Master',
                subtitle: 'Deepwater maritime ports, customs bonded container freight stations, and terminals',
                actions: [
                  AppButton(
                    text: 'Add Terminal',
                    icon: Icons.anchor_outlined,
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
                        Text('Port & CFS Terminals', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${items.length} maritime facilities', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search terminal name, location...',
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
                    label: const Text('All Categories'),
                    selected: state.typeFilter == null,
                    onSelected: (_) => notifier.setTypeFilter(null),
                  ),
                  const SizedBox(width: 8),
                  ...PortCfsType.values.map((t) {
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
                title: 'No Facilities Found',
                message: 'No ports or CFS terminals match your current filters.',
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.anchor, size: 20, color: AppColors.red),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
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
                                      item.type.label,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.location,
                                      style: AppTextStyles.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          tooltip: 'Edit Terminal',
                          onPressed: () => _showEditDialog(context, ref, item),
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
                        DataColumn(label: Text('Terminal / Facility', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: items.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.name, style: AppTextStyles.labelLarge)),
                            DataCell(Text(item.type.label, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(item.location, style: AppTextStyles.bodySmall)),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () => _showEditDialog(context, ref, item),
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
}
