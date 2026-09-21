import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_provider.dart';
import '../../features/attendance/presentation/attendance_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/drivers/presentation/driver_list_screen.dart';
import '../../features/locations/presentation/location_list_screen.dart';
import '../../features/masters/presentation/masters_hub_screen.dart';
import '../../features/parties/presentation/party_list_screen.dart';
import '../../features/ports_cfs/presentation/port_cfs_list_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shipping_lines/presentation/shipping_line_list_screen.dart';
import '../../features/transport/presentation/create_transport_screen.dart';
import '../../features/transport/presentation/transport_details_screen.dart';
import '../../features/transport/presentation/transport_list_screen.dart';
import '../../features/vehicles/presentation/vehicle_list_screen.dart';
import '../app_shell.dart';

class AppRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AppRouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (previous, next) => notifyListeners(),
    );
  }
}

final appRouterNotifierProvider = Provider<AppRouterNotifier>((ref) {
  return AppRouterNotifier(ref);
});

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shellNav');

bool _isCoordinatorPermittedRoute(String location) {
  if (location == '/transport') return true;
  if (location.startsWith('/transport/') && location != '/transport/create') return true;
  if (location.startsWith('/vehicles')) return true;
  if (location.startsWith('/drivers')) return true;
  return false;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(appRouterNotifierProvider);
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    initialLocation: '/dashboard',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      if (!authState.isInitialized) return null;

      final isAuth = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login' || state.matchedLocation == '/forgot-password';

      if (!isAuth && !isLoginRoute) {
        return '/login';
      }
      if (isAuth) {
        final role = authState.user?.role;
        final isCoordinator = role == 'Coordinator';

        if (isLoginRoute) {
          if (isCoordinator) {
            final lastRoute = authService.getCachedLastRoute();
            if (lastRoute != null && _isCoordinatorPermittedRoute(lastRoute)) {
              return lastRoute;
            }
            return '/transport';
          }
          final lastRoute = authService.getCachedLastRoute();
          return (lastRoute != null && lastRoute.isNotEmpty) ? lastRoute : '/dashboard';
        }

        if (isCoordinator && !_isCoordinatorPermittedRoute(state.matchedLocation)) {
          return '/transport';
        }

        // Keep active screen persisted across reloads & navigation
        authService.saveLastRoute(state.matchedLocation);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/transport',
            builder: (context, state) => const TransportListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateTransportScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return TransportDetailsScreen(transportId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/vehicles',
            builder: (context, state) => const VehicleListScreen(),
          ),
          GoRoute(
            path: '/drivers',
            builder: (context, state) => const DriverListScreen(),
          ),
          GoRoute(
            path: '/masters',
            builder: (context, state) => const MastersHubScreen(),
          ),
          GoRoute(
            path: '/parties',
            builder: (context, state) => const PartyListScreen(),
          ),
          GoRoute(
            path: '/shipping-lines',
            builder: (context, state) => const ShippingLineListScreen(),
          ),
          GoRoute(
            path: '/locations',
            builder: (context, state) => const LocationListScreen(),
          ),
          GoRoute(
            path: '/ports-cfs',
            builder: (context, state) => const PortCfsListScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
