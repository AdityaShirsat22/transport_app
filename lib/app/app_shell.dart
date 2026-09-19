import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/auth/auth_provider.dart';
import '../core/constants/app_constants.dart';
import '../core/sync/sync_engine.dart';
import '../core/widgets/responsive_layout.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import '../features/drivers/data/driver_repository.dart';
import '../features/drivers/presentation/driver_view_model.dart';
import '../features/locations/data/location_repository.dart';
import '../features/locations/presentation/location_view_model.dart';
import '../features/parties/data/party_repository.dart';
import '../features/parties/presentation/party_view_model.dart';
import '../features/ports_cfs/data/port_cfs_repository.dart';
import '../features/ports_cfs/presentation/port_cfs_view_model.dart';
import '../features/shipping_lines/data/shipping_line_repository.dart';
import '../features/shipping_lines/presentation/shipping_line_view_model.dart';
import '../features/transport/data/transport_repository.dart';
import '../features/transport/presentation/transport_view_model.dart';
import '../features/vehicles/data/vehicle_repository.dart';
import '../features/vehicles/presentation/vehicle_view_model.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _hasSyncedOnStartup = false;

  @override
  void initState() {
    super.initState();
    // Run the startup sync after the first frame so providers are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupSync());
  }

  Future<void> _runStartupSync() async {
    if (_hasSyncedOnStartup) return;
    final authState = ref.read(authProvider);
    if (authState.user == null) return; // Not authenticated yet; skip

    _hasSyncedOnStartup = true;

    // Pull all cloud data into local SQLite
    await ref.read(syncEngineProvider.notifier).startupSync();

    // Reload every repository's in-memory cache from the freshly updated SQLite
    await ref.read(vehicleRepositoryProvider).reloadFromDatabase();
    await ref.read(driverRepositoryProvider).reloadFromDatabase();
    await ref.read(partyRepositoryProvider).reloadFromDatabase();
    await ref.read(shippingLineRepositoryProvider).reloadFromDatabase();
    await ref.read(locationRepositoryProvider).reloadFromDatabase();
    await ref.read(portCfsRepositoryProvider).reloadFromDatabase();
    await ref.read(transportRepositoryProvider).reloadFromDatabase();

    // Notify every ViewModel so the UI rebuilds with fresh data
    if (mounted) {
      ref.read(vehicleViewModelProvider.notifier).loadVehicles();
      ref.read(driverViewModelProvider.notifier).loadDrivers();
      ref.read(partyViewModelProvider.notifier).loadParties();
      ref.read(shippingLineViewModelProvider.notifier).loadItems();
      ref.read(locationViewModelProvider.notifier).loadLocations();
      ref.read(portCfsViewModelProvider.notifier).loadItems();
      ref.read(transportViewModelProvider.notifier).loadTransports();
    }
  }


  int _calculateSelectedIndex(String location) {
    if (location == '/dashboard') return 0;
    if (location.startsWith('/transport')) return 1;
    if (location.startsWith('/vehicles') || location.startsWith('/drivers')) return 2;
    if (location.startsWith('/masters') ||
        location.startsWith('/parties') ||
        location.startsWith('/shipping-lines') ||
        location.startsWith('/locations') ||
        location.startsWith('/ports-cfs')) {
      return 3;
    }
    if (location.startsWith('/reports')) return 4;
    if (location.startsWith('/settings')) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/transport');
        break;
      case 2:
        context.go('/vehicles');
        break;
      case 3:
        context.go('/masters');
        break;
      case 4:
        context.go('/reports');
        break;
      case 5:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _calculateSelectedIndex(location);
    final syncState = ref.watch(syncEngineProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final isDetailOrChild = location == '/transport/create' ||
        (location.startsWith('/transport/') && location != '/transport');

    if (isMobile) {
      return Scaffold(
        appBar: isDetailOrChild
            ? null
            : AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_shipping, size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: AppTextStyles.headingSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user?.name ?? 'Operations Manager',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  // Sync dot indicator
                  InkWell(
                    onTap: () => context.go('/settings'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: syncState.isOnline ? AppColors.green : AppColors.amber,
                            ),
                          ),
                          if (syncState.pendingCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${syncState.pendingCount}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: syncState.isOnline ? AppColors.green : AppColors.amber,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 20, color: AppColors.accent),
                    ),
                    tooltip: 'New Transport Booking',
                    onPressed: () => context.go('/transport/create'),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => context.go('/settings'),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.accentLight,
                      child: Text(
                        user?.name.substring(0, user.name.length >= 2 ? 2 : 1).toUpperCase() ?? 'AO',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
        drawer: isDetailOrChild
            ? null
            : Drawer(
                backgroundColor: AppColors.primary,
                child: _SidebarContent(currentPath: location, isMobile: true),
              ),
        body: widget.child,
        bottomNavigationBar: isDetailOrChild
            ? null
            : NavigationBar(
                selectedIndex: selectedIndex > 4 ? 0 : selectedIndex,
                onDestinationSelected: (index) => _onItemTapped(index, context),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.alt_route_outlined),
                    selectedIcon: Icon(Icons.alt_route),
                    label: 'Trips',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.local_shipping_outlined),
                    selectedIcon: Icon(Icons.local_shipping),
                    label: 'Fleet',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.hub_outlined),
                    selectedIcon: Icon(Icons.hub),
                    label: 'Masters',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.bar_chart_outlined),
                    selectedIcon: Icon(Icons.bar_chart),
                    label: 'Reports',
                  ),
                ],
              ),
      );
    }

    // Tablet & Desktop Responsive Layout (Landscape-first)
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: _SidebarContent(currentPath: location, isMobile: false),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class _SidebarContent extends ConsumerWidget {
  final String currentPath;
  final bool isMobile;

  const _SidebarContent({
    required this.currentPath,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncEngineProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            // App Branding Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_shipping, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Logistics Suite',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF334155), height: 1),

            // Quick Create Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Transport', style: TextStyle(fontWeight: FontWeight.w600)),
                onPressed: () {
                  if (isMobile) Navigator.of(context).pop();
                  context.go('/transport/create');
                },
              ),
            ),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                children: [
                  _buildNavItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    route: '/dashboard',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Transport Operations',
                    icon: Icons.alt_route_outlined,
                    activeIcon: Icons.alt_route,
                    route: '/transport',
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 14, 6),
                    child: Text(
                      'FLEET & CREW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    title: 'Vehicles',
                    icon: Icons.fire_truck_outlined,
                    activeIcon: Icons.fire_truck,
                    route: '/vehicles',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Drivers',
                    icon: Icons.badge_outlined,
                    activeIcon: Icons.badge,
                    route: '/drivers',
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 14, 6),
                    child: Text(
                      'LOGISTICS MASTERS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    title: 'Masters Hub',
                    icon: Icons.hub_outlined,
                    activeIcon: Icons.hub,
                    route: '/masters',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Parties / Customers',
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    route: '/parties',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Shipping Lines',
                    icon: Icons.directions_boat_outlined,
                    activeIcon: Icons.directions_boat,
                    route: '/shipping-lines',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Locations',
                    icon: Icons.location_on_outlined,
                    activeIcon: Icons.location_on,
                    route: '/locations',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Port / CFS',
                    icon: Icons.anchor_outlined,
                    activeIcon: Icons.anchor,
                    route: '/ports-cfs',
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 16, 14, 6),
                    child: Text(
                      'ANALYTICS & SYSTEM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  _buildNavItem(
                    context,
                    title: 'Reports',
                    icon: Icons.bar_chart_outlined,
                    activeIcon: Icons.bar_chart,
                    route: '/reports',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Settings & Cloud',
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    route: '/settings',
                  ),
                ],
              ),
            ),

            // Subtle Real-time Sync Indicator Footer
            InkWell(
              onTap: () {
                if (isMobile) Navigator.of(context).pop();
                context.go('/settings');
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: syncState.isOnline ? AppColors.green : AppColors.amber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        syncState.isSyncing
                            ? 'Syncing changes...'
                            : syncState.isOnline
                                ? 'Cloud Synced'
                                : 'Offline (${syncState.pendingCount} queued)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: syncState.isOnline ? const Color(0xFF94A3B8) : AppColors.amber,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: Color(0xFF64748B)),
                  ],
                ),
              ),
            ),

            // Super Admin User Profile Footnote
            const Divider(color: Color(0xFF334155), height: 1),
            InkWell(
              onTap: () {
                if (isMobile) Navigator.of(context).pop();
                context.go('/settings');
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.accentLight,
                      child: Text(
                        user?.name.substring(0, user.name.length >= 2 ? 2 : 1).toUpperCase() ?? 'AO',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? AppConstants.defaultUserName,
                            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (user?.role ?? AppConstants.defaultUserRole).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF38BDF8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required IconData activeIcon,
    required String route,
  }) {
    final isActive = currentPath == route ||
        (route != '/dashboard' && currentPath.startsWith(route));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (isMobile) Navigator.of(context).pop();
            context.go(route);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  size: 20,
                  color: isActive ? AppColors.accentLight : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isActive ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
