import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../drivers/presentation/driver_view_model.dart';
import '../../locations/presentation/location_view_model.dart';
import '../../parties/presentation/party_view_model.dart';
import '../../ports_cfs/presentation/port_cfs_view_model.dart';
import '../../shipping_lines/presentation/shipping_line_view_model.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';

class MastersHubScreen extends ConsumerWidget {
  const MastersHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parties = ref.watch(partyViewModelProvider).parties;
    final vehicles = ref.watch(vehicleViewModelProvider).vehicles;
    final drivers = ref.watch(driverViewModelProvider).drivers;
    final shippingLines = ref.watch(shippingLineViewModelProvider).shippingLines;
    final locations = ref.watch(locationViewModelProvider).locations;
    final ports = ref.watch(portCfsViewModelProvider).items;

    final masters = [
      _MasterItem(
        title: 'Parties / Customers',
        subtitle: 'Billed entities, consignors, and booking agents',
        count: '${parties.length} Clients',
        icon: Icons.people_alt_outlined,
        color: AppColors.accent,
        route: '/parties',
      ),
      _MasterItem(
        title: 'Vehicle Fleet',
        subtitle: 'Trucks, trailers, capacity, and operational status',
        count: '${vehicles.length} Trucks',
        icon: Icons.local_shipping_outlined,
        color: AppColors.blue,
        route: '/vehicles',
      ),
      _MasterItem(
        title: 'Drivers Master',
        subtitle: 'Commercial licensed drivers, mobile & duty status',
        count: '${drivers.length} Drivers',
        icon: Icons.badge_outlined,
        color: AppColors.purple,
        route: '/drivers',
      ),
      _MasterItem(
        title: 'Shipping Lines',
        subtitle: 'Ocean container shipping carriers & prefix codes',
        count: '${shippingLines.length} Carriers',
        icon: Icons.directions_boat_outlined,
        color: AppColors.amber,
        route: '/shipping-lines',
      ),
      _MasterItem(
        title: 'Locations & Hubs',
        subtitle: 'Factories, warehouses, ICD hubs, and city yards',
        count: '${locations.length} Hubs',
        icon: Icons.location_on_outlined,
        color: AppColors.green,
        route: '/locations',
      ),
      _MasterItem(
        title: 'Port & CFS Terminals',
        subtitle: 'Deepwater seaports, container freight stations',
        count: '${ports.length} Terminals',
        icon: Icons.anchor_outlined,
        color: AppColors.red,
        route: '/ports-cfs',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logistics Masters'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.hub, color: AppColors.accentLight, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Configuration',
                        style: AppTextStyles.headingSmall.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage foundational logistics entities and fleet databases',
                        style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Master Cards Grid
          ...masters.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                onTap: () => context.go(item.route),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: AppTextStyles.labelLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.count,
                                  style: TextStyle(
                                    color: item.color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MasterItem {
  final String title;
  final String subtitle;
  final String count;
  final IconData icon;
  final Color color;
  final String route;

  _MasterItem({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.color,
    required this.route,
  });
}
