import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/app/app.dart';
import 'package:transport_app/core/auth/auth_provider.dart';
import 'package:transport_app/core/auth/auth_service.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/core/enums/container_size.dart';
import 'package:transport_app/core/enums/shipment_type.dart';
import 'package:transport_app/core/enums/transport_status.dart';
import 'package:transport_app/features/transport/data/transport_repository.dart';
import 'package:transport_app/features/transport/domain/transport_model.dart';
import 'package:transport_app/features/transport/presentation/transport_view_model.dart';

class FakeAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  FakeAuthNotifier(AppUser user)
      : super(AuthState(
          user: user,
          isInitialized: true,
        ));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const coordinatorUser = AppUser(
    id: 'pin-user-coordinator',
    email: 'coordinator@freightops.com',
    name: 'Operations Coordinator',
    role: 'Coordinator',
  );

  group('Coordinator Role Navigation & Permissions Tests', () {
    test('Coordinator PIN login yields Coordinator role', () async {
      SharedPreferences.setMockInitialValues({});
      final authService = AuthService();
      final user = await authService.loginWithPin(pin: '1170', role: 'Coordinator');
      expect(user.role, equals('Coordinator'));
      expect(user.name, equals('Operations Coordinator'));
    });

    testWidgets('AppShell shows exactly 3 navigation options (Trips, Fleet, Driver) for Coordinator on mobile',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({
        'freightops_last_active_route': '/transport',
      });

      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            authProvider.overrideWith((ref) => FakeAuthNotifier(coordinatorUser)),
          ],
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify bottom navigation bar has only 3 destinations
      final navBarFinder = find.byType(NavigationBar);
      expect(navBarFinder, findsOneWidget);

      final navBar = tester.widget<NavigationBar>(navBarFinder);
      expect(navBar.destinations.length, equals(3));

      // Verify labels
      expect(find.text('Trips'), findsWidgets);
      expect(find.text('Fleet'), findsOneWidget);
      expect(find.text('Driver'), findsOneWidget);

      // Verify Super Admin labels are absent
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Masters'), findsNothing);
      expect(find.text('Reports'), findsNothing);

      // Verify "New Transport Booking" button in mobile AppBar is NOT present
      expect(find.byTooltip('New Transport Booking'), findsNothing);

      // Verify direct Sign Out icon is present in mobile AppBar
      expect(find.byTooltip('Sign Out'), findsOneWidget);

      // Verify "New Booking" FloatingActionButton on trips screen is NOT present for Coordinator
      expect(find.text('New Booking'), findsNothing);
    });

    testWidgets('AppShell sidebar shows only Trips, Fleet, Driver, and no New Transport for Coordinator on desktop',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({
        'freightops_last_active_route': '/transport',
      });

      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            authProvider.overrideWith((ref) => FakeAuthNotifier(coordinatorUser)),
          ],
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // "New Transport" button should be hidden for Coordinator
      expect(find.text('New Transport'), findsNothing);

      // Sidebar nav items: Trips, Fleet, Driver
      expect(find.text('Trips'), findsOneWidget);
      expect(find.text('Fleet'), findsOneWidget);
      expect(find.text('Driver'), findsOneWidget);

      // Other sections hidden
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Masters Hub'), findsNothing);
      expect(find.text('Reports'), findsNothing);
      expect(find.text('Settings & Cloud'), findsNothing);

      // Desktop table on Trips page does not show "New Booking"
      expect(find.text('New Booking'), findsNothing);
    });

    testWidgets('Coordinator can navigate to Fleet and Driver screens via NavigationBar',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({
        'freightops_last_active_route': '/transport',
      });

      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            authProvider.overrideWith((ref) => FakeAuthNotifier(coordinatorUser)),
          ],
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Fleet tab
      await tester.tap(find.text('Fleet'));
      await tester.pumpAndSettle();

      // Verify Vehicle Fleet screen loaded with Add Vehicle available
      expect(find.text('Vehicle Fleet'), findsOneWidget);
      expect(find.text('Add Vehicle'), findsOneWidget);

      // Tap Driver tab
      await tester.tap(find.text('Driver'));
      await tester.pumpAndSettle();

      // Verify Driver screen loaded with Add Driver available
      expect(find.text('Drivers Crew'), findsOneWidget);
      expect(find.text('Add Driver'), findsOneWidget);
    });

    testWidgets('Coordinator on Trip Details screen can edit container/seal and assign fleet/crew, but cannot delete or advance status',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final db = AppDatabase.forTesting(NativeDatabase.memory());

      // Pre-seed a transport trip
      final now = DateTime(2026, 1, 1);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authProvider.overrideWith((ref) => FakeAuthNotifier(coordinatorUser)),
        ],
      );

      final tRepo = container.read(transportRepositoryProvider);
      await tRepo.reloadFromDatabase();
      tRepo.add(
        Transport(
          id: 'TRP-COORD-99',
          bookingNumber: 'BK-9999',
          containerNumber: 'MSCU1234567',
          sealNumber: 'SL-7777',
          containerSize: ContainerSize.size40Ft,
          shipmentType: ShipmentType.import,
          status: TransportStatus.atPortCfs,
          partyId: 'p-1',
          partyName: 'ABC Logistics',
          bookingPartyId: 'p-1',
          bookingPartyName: 'ABC Logistics',
          shippingLineId: 'sl-1',
          shippingLineName: 'Maersk',
          fromLocationId: 'l-1',
          fromLocationName: 'JNPT Port',
          toLocationId: 'l-2',
          toLocationName: 'Bhiwandi Hub',
          portCfsId: 'pc-1',
          portCfsName: 'Speed CFS',
          allocations: [],
          createdAt: now,
          updatedAt: now,
        ),
      );
      container.read(transportViewModelProvider.notifier).loadTransports();

      SharedPreferences.setMockInitialValues({
        'freightops_last_active_route': '/transport/TRP-COORD-99',
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // On desktop table, tap on the seeded booking to open details
      expect(find.text('BK-9999'), findsOneWidget);
      await tester.tap(find.text('BK-9999'));
      await tester.pumpAndSettle();

      // 1. Delete Transport & 3-dot menu in AppBar should NOT be present
      expect(find.byTooltip('Delete Transport'), findsNothing);
      expect(find.byIcon(Icons.more_vert), findsNothing);

      // 2. Advance Status bottom button should NOT be present
      expect(find.textContaining('ADVANCE:'), findsNothing);
      expect(find.text('COMPLETE TRANSPORT'), findsNothing);

      // 3. Edit Container & Seal should be accessible
      expect(find.text('Edit Container & Seal'), findsOneWidget);

      // 4. Assigned Fleet & Crew should be accessible
      expect(find.text('Assigned Fleet & Crew'), findsOneWidget);
      expect(find.text('Allot Vehicle & Driver'), findsOneWidget);

      container.dispose();
      await db.close();
    });
  });
}
