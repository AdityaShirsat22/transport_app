import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_app/app/app.dart';
import 'package:transport_app/app/router/app_router.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/features/transport/presentation/notification_preview_dialog.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Android Mobile UI & Responsive Navigation Tests', () {
    testWidgets('Renders Android Material 3 NavigationBar and navigates across tabs on mobile', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
          ],
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Top App Bar with brand and Live badge
      expect(find.text('FreightOps'), findsWidgets);

      // 2. Verify Android Material 3 NavigationBar is present with 5 destinations
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Trips'), findsOneWidget);
      expect(find.text('Fleet'), findsOneWidget);
      expect(find.text('Masters'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);

      // 3. Tap "Trips" destination on NavigationBar
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();

      // Verify Trips screen loaded
      expect(find.text('Transport Trips'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);

      // 4. Tap "Fleet" destination on NavigationBar
      await tester.tap(find.text('Fleet'));
      await tester.pumpAndSettle();

      // Verify Vehicle Fleet screen loaded
      expect(find.text('Vehicle Fleet'), findsOneWidget);

      // 5. Tap "Masters" destination on NavigationBar
      await tester.tap(find.text('Masters'));
      await tester.pumpAndSettle();

      // Verify Masters Hub screen loaded
      expect(find.text('Logistics Masters'), findsOneWidget);
      expect(find.text('Parties / Customers'), findsOneWidget);

      // Scroll down to reveal remaining master cards
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('Port & CFS Terminals'), findsOneWidget);

      // 6. Tap "Reports" destination on NavigationBar
      await tester.tap(find.text('Reports'));
      await tester.pumpAndSettle();

      // Verify Reports screen loaded
      expect(find.text('Analytics & Reports'), findsOneWidget);

      await db.close();
    });

    testWidgets('Renders Create Transport screen on narrow mobile without dropdown overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate directly to create transport booking screen
      container.read(appRouterProvider).go('/transport/create');
      await tester.pumpAndSettle();

      // Verify Create Transport screen loaded
      expect(find.text('New Transport Booking'), findsOneWidget);
      expect(find.text('Container Size'), findsOneWidget);
      expect(find.text('Shipment Type'), findsOneWidget);
      expect(find.text('CREATE BOOKING'), findsOneWidget);

      container.dispose();
      await db.close();
    });

    testWidgets('Renders NotificationPreviewDialog on narrow mobile without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotificationPreviewDialog(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('WHATSAPP NOTIFICATION'), findsOneWidget);
      expect(find.text('SENT'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });
  });
}
