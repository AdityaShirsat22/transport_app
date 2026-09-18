import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../domain/party_model.dart';
import 'party_form_dialog.dart';
import 'party_view_model.dart';

class PartyListScreen extends ConsumerWidget {
  const PartyListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = PartyFormDialog(
      onSave: (name, mobile, email, city) {
        ref.read(partyViewModelProvider.notifier).addParty(
              name: name,
              mobileNumber: mobile,
              email: email,
              city: city,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Party registered successfully'), backgroundColor: AppColors.green),
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

  void _showEditDialog(BuildContext context, WidgetRef ref, Party party) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final form = PartyFormDialog(
      initialParty: party,
      onSave: (name, mobile, email, city) {
        final updated = party.copyWith(
          name: name,
          mobileNumber: mobile,
          email: email,
          city: city,
        );
        ref.read(partyViewModelProvider.notifier).updateParty(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Party updated successfully'), backgroundColor: AppColors.green),
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
    final state = ref.watch(partyViewModelProvider);
    final notifier = ref.read(partyViewModelProvider.notifier);
    final items = state.filteredParties;
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Party'),
            )
          : null,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              PageHeader(
                title: 'Party / Customer Master',
                subtitle: 'Client directory, active transport statistics, and contact information',
                actions: [
                  AppButton(
                    text: 'Add Party',
                    icon: Icons.business_outlined,
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
                        Text('Parties / Customers', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 2),
                        Text('${items.length} accounts registered', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Bar
            TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search customer name, mobile, city...',
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
            const SizedBox(height: 16),

            // Content List
            if (items.isEmpty)
              const EmptyState(
                title: 'No Parties Found',
                message: 'No parties match your current search query.',
              )
            else if (isMobile)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  final p = item.party;
                  return AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.business, size: 18, color: AppColors.accent),
                                ),
                                const SizedBox(width: 10),
                                Text(p.name, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  tooltip: 'Edit Party',
                                  onPressed: () => _showEditDialog(context, ref, p),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
                                  tooltip: 'Delete Party',
                                  onPressed: () => _confirmDelete(context, ref, p),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(p.mobileNumber, style: AppTextStyles.bodySmall),
                            const SizedBox(width: 14),
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(p.city, style: AppTextStyles.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(p.email, style: AppTextStyles.bodySmall),
                          ],
                        ),
                        const Divider(height: 18),
                        Row(
                          children: [
                            _buildStatBadge('Total', '${item.totalTrips}', AppColors.blue),
                            const SizedBox(width: 8),
                            _buildStatBadge('Active', '${item.activeTrips}', AppColors.amber),
                            const SizedBox(width: 8),
                            _buildStatBadge('Done', '${item.completedTrips}', AppColors.green),
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
                        DataColumn(label: Text('Customer / Party', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('City', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Total Trips', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Active Trips', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Completed', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: items.map((item) {
                        final p = item.party;
                        return DataRow(
                          cells: [
                            DataCell(Text(p.name, style: AppTextStyles.labelLarge)),
                            DataCell(Text(p.mobileNumber, style: AppTextStyles.bodyMedium)),
                            DataCell(Text(p.email, style: AppTextStyles.bodySmall)),
                            DataCell(Text(p.city, style: AppTextStyles.bodyMedium)),
                            DataCell(Text('${item.totalTrips}', style: AppTextStyles.bodyMedium)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.amberLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.activeTrips}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.greenLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.completedTrips}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    onPressed: () => _showEditDialog(context, ref, p),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                                    tooltip: 'Delete Party',
                                    onPressed: () => _confirmDelete(context, ref, p),
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

  Widget _buildStatBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Party p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Party / Customer'),
        content: Text('Are you sure you want to delete customer/party "${p.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(partyViewModelProvider.notifier).deleteParty(p.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Party "${p.name}" deleted successfully'), backgroundColor: AppColors.green),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
