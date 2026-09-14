import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_app/app/app.dart';
import 'package:transport_app/app/router/app_router.dart';
import 'package:transport_app/features/transport/presentation/notification_preview_dialog.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Android Mobile UI & Responsive Navigation Tests', () {
    testWidgets('Renders Android Material 3 NavigationBar and navigates across tabs on mobile', (WidgetTester tester) async {
      // Simulate standard Android mobile device screen (390 x 844)
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Top App Bar with brand and Live badge
      expect(find.text('FreightOps'), findsWidgets);
      expect(find.text('LIVE'), findsOneWidget);

      // 2. Verify Android Material 3 NavigationBar is present with 5 destinations
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Trips'), findsOneWidget);
      expect(find.text('Fleet'), findsOneWidget);
      expect(find.text('Masters'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);

      // 3. Verify Floating Action Button is present on mobile Dashboard
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('New Booking'), findsOneWidget);

      // 4. Tap "Trips" destination on NavigationBar
      await tester.tap(find.text('Trips'));
      await tester.pumpAndSettle();

      // Verify Trips screen loaded
      expect(find.text('Transport Trips'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);

      // 5. Tap "Fleet" destination on NavigationBar
      await tester.tap(find.text('Fleet'));
      await tester.pumpAndSettle();

      // Verify Vehicle Fleet screen loaded
      expect(find.text('Vehicle Fleet'), findsOneWidget);

      // 6. Tap "Masters" destination on NavigationBar
      await tester.tap(find.text('Masters'));
      await tester.pumpAndSettle();

      // Verify Masters Hub screen loaded
      expect(find.text('Logistics Masters'), findsOneWidget);
      expect(find.text('Parties / Customers'), findsOneWidget);

      // Scroll down to reveal remaining master cards
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('Port & CFS Terminals'), findsOneWidget);

      // 7. Tap "Reports" destination on NavigationBar
      await tester.tap(find.text('Reports'));
      await tester.pumpAndSettle();

      // Verify Reports screen loaded
      expect(find.text('Analytics & Reports'), findsOneWidget);
    });

    testWidgets('Renders Create Transport screen on narrow mobile without dropdown overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate directly to create transport booking screen
      appRouter.go('/transport/create');
      await tester.pumpAndSettle();

      // Verify Create Transport screen loaded
      expect(find.text('New Transport Booking'), findsOneWidget);
      expect(find.text('Container Size'), findsOneWidget);
      expect(find.text('Shipment Type'), findsOneWidget);
      expect(find.text('CREATE & AUTO-ASSIGN'), findsOneWidget);
    });

    testWidgets('Renders TransportDetailsScreen on narrow mobile (360x780) without overflow', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: TransportApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to TransportDetailsScreen with mock booking
      appRouter.go('/transport/TR-00124');
      await tester.pumpAndSettle();

      // Verify status banner and details load cleanly without any RenderFlex overflow
      expect(find.text('Current Operational Status'), findsOneWidget);
      expect(find.textContaining('TR-00124'), findsWidgets);
      expect(find.text('Trip Milestone Timeline'), findsOneWidget);
      expect(find.text('Container & Route'), findsOneWidget);
      expect(find.text('Assigned Fleet & Crew'), findsOneWidget);
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
