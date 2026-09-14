import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/kpi_card.dart';
import '../../../core/widgets/page_header.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_badge.dart';
import '../../transport/domain/transport_model.dart';
import '../../transport/presentation/transport_view_model.dart';
import 'dashboard_view_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardStatsProvider);
    final transportState = ref.watch(transportViewModelProvider);
    final recentTransports = transportState.transports.take(8).toList();
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      floatingActionButton: isMobile
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
                title: 'Operations Dashboard',
                subtitle: 'Real-time logistics overview, fleet assignment metrics, and dispatch throughput',
                actions: [
                  AppButton(
                    text: 'New Booking',
                    icon: Icons.add,
                    onPressed: () => context.go('/transport/create'),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Operations Overview', style: AppTextStyles.headingMedium, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Live dispatch and fleet metrics', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Top KPI Cards Grid (Mobile 2-column or Desktop multi-column)
            LayoutBuilder(
              builder: (ctx, constraints) {
                final crossAxisCount = constraints.maxWidth > 1200
                    ? 6
                    : (constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 550 ? 2 : 2));

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isMobile ? 1.18 : (crossAxisCount >= 6 ? 1.3 : 1.6),
                  children: [
                    KpiCard(
                      title: 'Total Transport',
                      value: '${stats.totalTransport}',
                      subtitle: 'Cumulative',
                      icon: Icons.local_shipping_outlined,
                      iconColor: AppColors.accent,
                      iconBgColor: AppColors.blueLight,
                      onTap: () => context.go('/transport'),
                    ),
                    KpiCard(
                      title: "Today's Trips",
                      value: '${stats.todaysTrips}',
                      subtitle: 'Dispatched today',
                      icon: Icons.today_outlined,
                      iconColor: AppColors.purple,
                      iconBgColor: AppColors.purpleLight,
                    ),
                    KpiCard(
                      title: 'Vehicle Pending',
                      value: '${stats.vehiclePending}',
                      subtitle: 'Needs attention',
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.amber,
                      iconBgColor: AppColors.amberLight,
                      onTap: () {
                        ref.read(transportViewModelProvider.notifier).setStatusFilter(null);
                        context.go('/transport');
                      },
                    ),
                    KpiCard(
                      title: 'Assigned',
                      value: '${stats.assigned}',
                      subtitle: 'Ready to report',
                      icon: Icons.assignment_turned_in_outlined,
                      iconColor: AppColors.blue,
                      iconBgColor: AppColors.blueLight,
                    ),
                    KpiCard(
                      title: 'In Transit',
                      value: '${stats.inTransit}',
                      subtitle: 'En route to hub',
                      icon: Icons.navigation_outlined,
                      iconColor: AppColors.accentLight,
                      iconBgColor: AppColors.blueLight,
                    ),
                    KpiCard(
                      title: 'Completed',
                      value: '${stats.completed}',
                      subtitle: 'POD signed & closed',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.green,
                      iconBgColor: AppColors.greenLight,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),

            // Vehicle Fleet Status Dashboard
            AppCard(
              padding: EdgeInsets.all(isMobile ? 14 : 20),
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
                            Text(isMobile ? 'Fleet Availability' : 'Fleet Availability Dashboard', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Commercial truck readiness', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => context.go('/vehicles'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(isMobile ? 'View' : 'Fleet Master'),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (isMobile)
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactStatusChip(
                            label: 'Available',
                            count: stats.vehiclesAvailable,
                            color: AppColors.green,
                            bgColor: AppColors.greenLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactStatusChip(
                            label: 'On Trip',
                            count: stats.vehiclesOnTrip,
                            color: AppColors.blue,
                            bgColor: AppColors.blueLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactStatusChip(
                            label: 'Maint.',
                            count: stats.vehiclesMaintenance,
                            color: AppColors.amber,
                            bgColor: AppColors.amberLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactStatusChip(
                            label: 'Inactive',
                            count: stats.vehiclesInactive,
                            color: AppColors.slate,
                            bgColor: AppColors.slateLight,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildVehicleStatusPill(
                            label: 'Available',
                            count: stats.vehiclesAvailable,
                            color: AppColors.green,
                            bgColor: AppColors.greenLight,
                            icon: Icons.check_circle_outline,
                            subtitle: 'Ready for assignment',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildVehicleStatusPill(
                            label: 'On Trip',
                            count: stats.vehiclesOnTrip,
                            color: AppColors.blue,
                            bgColor: AppColors.blueLight,
                            icon: Icons.local_shipping,
                            subtitle: 'Active on road / at CFS',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildVehicleStatusPill(
                            label: 'Maintenance',
                            count: stats.vehiclesMaintenance,
                            color: AppColors.amber,
                            bgColor: AppColors.amberLight,
                            icon: Icons.build_circle_outlined,
                            subtitle: 'Workshop service',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildVehicleStatusPill(
                            label: 'Inactive',
                            count: stats.vehiclesInactive,
                            color: AppColors.slate,
                            bgColor: AppColors.slateLight,
                            icon: Icons.pause_circle_outline,
                            subtitle: 'Permit hold',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Recent Transport Operations
            AppCard(
              padding: EdgeInsets.all(isMobile ? 14 : 20),
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
                            Text('Recent Operations', style: AppTextStyles.headingSmall, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Tap to inspect timeline & POD', style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => context.go('/transport'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('View All'),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (recentTransports.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No transport records found.', style: AppTextStyles.bodyMedium),
                      ),
                    )
                  else if (isMobile)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTransports.length,
                      separatorBuilder: (context, index) => const Divider(height: 16),
                      itemBuilder: (ctx, i) {
                        final t = recentTransports[i];
                        return _buildMobileTransportCard(context, t);
                      },
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(AppColors.surfaceMuted),
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('Transport ID', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Booking No', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Container No', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Driver', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Route', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Created Date', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: recentTransports.map((t) {
                            return DataRow(
                              onSelectChanged: (_) => context.go('/transport/${t.id}'),
                              cells: [
                                DataCell(
                                  Text(
                                    t.id,
                                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataCell(Text(t.bookingNumber, style: AppTextStyles.bodyMedium)),
                                DataCell(Text(t.containerNumber, style: AppTextStyles.codeMono)),
                                DataCell(
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 160),
                                    child: Text(t.partyName, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                DataCell(Text(t.vehicleNumber ?? 'Pending', style: AppTextStyles.bodyMedium)),
                                DataCell(Text(t.driverName ?? 'Pending', style: AppTextStyles.bodyMedium)),
                                DataCell(Text('${t.fromLocationName} → ${t.toLocationName}', style: AppTextStyles.bodySmall)),
                                DataCell(StatusBadge.fromTransport(t.status)),
                                DataCell(Text(DateFormatter.formatShortDate(t.createdAt), style: AppTextStyles.bodySmall)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 80 : 20), // Bottom padding for FAB and navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTransportCard(BuildContext context, Transport t) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.go('/transport/${t.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.id,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
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
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(t.containerNumber, style: AppTextStyles.codeMono.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.navigation_outlined, size: 14, color: AppColors.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${t.fromLocationName} → ${t.toLocationName}',
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Truck: ${t.vehicleNumber ?? "Pending"}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.vehicleNumber != null ? AppColors.textPrimary : AppColors.amber,
                        fontWeight: t.vehicleNumber != null ? FontWeight.w500 : FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Driver: ${t.driverName ?? "Pending"}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.driverName != null ? AppColors.textPrimary : AppColors.amber,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatusChip({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleStatusPill({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: AppTextStyles.headingMedium.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: color.withValues(alpha: 0.8), fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
