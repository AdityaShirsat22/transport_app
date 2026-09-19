import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/config/env_config.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/page_header.dart';
import '../../drivers/data/driver_repository.dart';
import '../../drivers/presentation/driver_view_model.dart';
import '../../locations/data/location_repository.dart';
import '../../locations/presentation/location_view_model.dart';
import '../../parties/data/party_repository.dart';
import '../../parties/presentation/party_view_model.dart';
import '../../ports_cfs/data/port_cfs_repository.dart';
import '../../ports_cfs/presentation/port_cfs_view_model.dart';
import '../../shipping_lines/data/shipping_line_repository.dart';
import '../../shipping_lines/presentation/shipping_line_view_model.dart';
import '../../transport/data/transport_repository.dart';
import '../../transport/presentation/transport_view_model.dart';
import '../../vehicles/data/vehicle_repository.dart';
import '../../vehicles/presentation/vehicle_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to sign out? Your local operational cache will remain secure on this device.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dlgCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () async {
              Navigator.of(dlgCtx).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearDatabase(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset & Clear Local Database?'),
        content: const Text(
          'This will wipe all local transport, master, and queue records stored on this device. '
          'Records stored in Supabase cloud will not be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(appDatabaseProvider).clearAllData();
      await ref.read(vehicleRepositoryProvider).reloadFromDatabase();
      await ref.read(driverRepositoryProvider).reloadFromDatabase();
      await ref.read(partyRepositoryProvider).reloadFromDatabase();
      await ref.read(shippingLineRepositoryProvider).reloadFromDatabase();
      await ref.read(locationRepositoryProvider).reloadFromDatabase();
      await ref.read(portCfsRepositoryProvider).reloadFromDatabase();
      await ref.read(transportRepositoryProvider).reloadFromDatabase();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Local database cleared. Application is completely fresh.'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final syncState = ref.watch(syncEngineProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'Settings & Administration',
              subtitle: 'System configuration, cloud synchronization, and user session',
              actions: [
                AppButton(
                  text: 'Sign Out',
                  icon: Icons.logout,
                  variant: AppButtonVariant.danger,
                  onPressed: () => _showLogoutDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Profile Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Super Admin Profile', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.accentLight,
                        child: Text(
                          user?.name.substring(0, user.name.length >= 2 ? 2 : 1).toUpperCase() ?? 'AO',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? AppConstants.defaultUserName, style: AppTextStyles.headingMedium),
                            const SizedBox(height: 4),
                            Text(user?.email ?? EnvConfig.adminEmail, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                user?.role ?? AppConstants.defaultUserRole,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cloud Sync & Connectivity Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cloud Synchronization (Supabase)', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: syncState.isOnline ? AppColors.green : AppColors.amber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        syncState.isOnline ? 'Online • Connected to Cloud' : 'Offline • Changes Queued Locally',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: syncState.isOnline ? AppColors.green : AppColors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Pending Queue: ${syncState.pendingCount} operations waiting to sync', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Last Synced: ${syncState.lastSyncedAt != null ? syncState.lastSyncedAt.toString().substring(0, 19) : "Never"}',
                    style: AppTextStyles.bodySmall,
                  ),
                  if (syncState.errorMessage != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Sync Error: ${syncState.errorMessage}',
                      style: const TextStyle(fontSize: 12, color: AppColors.red),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.sync, size: 18),
                        label: const Text('Sync Now'),
                        onPressed: syncState.isSyncing
                            ? null
                            : () => ref.read(syncEngineProvider.notifier).syncPending(),
                      ),
                      if (syncState.pendingCount > 0)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.delete_sweep_outlined, size: 18, color: AppColors.red),
                          label: const Text('Clear Stuck Queue', style: TextStyle(color: AppColors.red)),
                          onPressed: syncState.isSyncing
                              ? null
                              : () async {
                                  await ref.read(syncEngineProvider.notifier).clearSyncQueue();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Sync queue cleared.'),
                                        backgroundColor: AppColors.textPrimary,
                                      ),
                                    );
                                  }
                                },
                        ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cloud_download_outlined, size: 18),
                        label: const Text('Restore Cloud Data (Device Loss)'),
                        onPressed: syncState.isSyncing
                            ? null
                            : () async {
                                final count = await ref.read(syncEngineProvider.notifier).restoreFromCloud();

                                // Reload every repository's in-memory cache from SQLite
                                await ref.read(vehicleRepositoryProvider).reloadFromDatabase();
                                await ref.read(driverRepositoryProvider).reloadFromDatabase();
                                await ref.read(partyRepositoryProvider).reloadFromDatabase();
                                await ref.read(shippingLineRepositoryProvider).reloadFromDatabase();
                                await ref.read(locationRepositoryProvider).reloadFromDatabase();
                                await ref.read(portCfsRepositoryProvider).reloadFromDatabase();
                                await ref.read(transportRepositoryProvider).reloadFromDatabase();

                                // Notify every ViewModel so the UI rebuilds
                                ref.read(vehicleViewModelProvider.notifier).loadVehicles();
                                ref.read(driverViewModelProvider.notifier).loadDrivers();
                                ref.read(partyViewModelProvider.notifier).loadParties();
                                ref.read(shippingLineViewModelProvider.notifier).loadItems();
                                ref.read(locationViewModelProvider.notifier).loadLocations();
                                ref.read(portCfsViewModelProvider.notifier).loadItems();
                                ref.read(transportViewModelProvider.notifier).loadTransports();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Restored $count records from Supabase. All screens updated.'),
                                      backgroundColor: AppColors.green,
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Local Database Info Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Database (Drift / SQLite)', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  const Text('Local engine: SQLite (Drift 2.x) with multi-table relational schema & background connection.'),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.red),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Reset & Clear Local Database'),
                    onPressed: () => _clearDatabase(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About FreightOps
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Application Information', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 16),
                  Text('${AppConstants.appName} v1.0.0+1 (Production Build)', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 4),
                  const Text('Designed for Android Logistics Tablets (Landscape-first) & Mobile Phones.'),
                  const SizedBox(height: 4),
                  Text(
                    'Supabase Backend: ${EnvConfig.isSupabaseConfigured ? "Configured" : "Standalone/Offline Development Mode"}',
                    style: TextStyle(
                      color: EnvConfig.isSupabaseConfigured ? AppColors.green : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
