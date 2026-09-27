import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/core/auth/auth_service.dart';
import 'package:transport_app/features/auth/presentation/login_screen.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AuthService Session Tests', () {
    test('Session route persists and clears correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final authService = AuthService();

      await authService.saveLastRoute('/dashboard');
      expect(authService.getCachedLastRoute(), equals('/dashboard'));

      await authService.clearLastRoute();
      expect(authService.getCachedLastRoute(), isNull);
    });

    test('Sign out clears cached last route', () async {
      SharedPreferences.setMockInitialValues({});
      final authService = AuthService();

      await authService.saveLastRoute('/transport');
      expect(authService.getCachedLastRoute(), equals('/transport'));

      await authService.signOut();
      expect(authService.getCachedLastRoute(), isNull);
    });

    test('PIN login requires Supabase connection (throws offline error)', () async {
      final authService = AuthService();
      expect(
        () => authService.loginWithPin(pin: '1234', role: 'Coordinator'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('LoginScreen Multi-Role UI Tests', () {
    testWidgets('Displays role tabs and correct sections per role', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Super Admin'), findsWidgets);
      expect(find.text('Coordinator'), findsOneWidget);
      expect(find.text('Driver'), findsOneWidget);

      // Super Admin: email/password form, no attendance section
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Attendance Section'), findsNothing);
      expect(find.text('Attendance Section Access'), findsNothing);

      // Coordinator: PIN input, no demo PIN hint
      await tester.tap(find.text('Coordinator'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Coordinator Portal Access'), findsOneWidget);
      expect(find.text('Demo PIN: 1170'), findsNothing);
      expect(find.byType(Pinput), findsOneWidget);

      // Driver: Coming Soon, no PIN
      await tester.tap(find.text('Driver'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Driver Mobile App'), findsOneWidget);
      expect(find.text('COMING SOON'), findsOneWidget);
      expect(find.text('View Driver App Preview'), findsNothing);
      expect(find.byType(Pinput), findsNothing);
    });
  });
}
