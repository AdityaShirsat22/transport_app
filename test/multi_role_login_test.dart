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

  group('AuthService PIN Login Unit Tests', () {
    final authService = AuthService();

    test('Valid PIN 1170 succeeds for Super Admin', () async {
      final user = await authService.loginWithPin(pin: '1170', role: 'Super Admin');
      expect(user.role, equals('Super Admin'));
      expect(user.name, isNotEmpty);
    });

    test('Valid PIN 1170 succeeds for Coordinator', () async {
      final user = await authService.loginWithPin(pin: '1170', role: 'Coordinator');
      expect(user.role, equals('Coordinator'));
      expect(user.name, equals('Operations Coordinator'));
    });

    test('Valid PIN 1170 succeeds for Driver', () async {
      final user = await authService.loginWithPin(pin: '1170', role: 'Driver');
      expect(user.role, equals('Driver'));
      expect(user.name, equals('Fleet Driver'));
    });

    test('Incorrect PIN throws friendly Exception', () async {
      expect(
        () => authService.loginWithPin(pin: '0000', role: 'Driver'),
        throwsA(isA<Exception>()),
      );
    });

    test('Session and route persist across screens and survive app restart', () async {
      SharedPreferences.setMockInitialValues({});
      await authService.loginWithPin(pin: '1170', role: 'Super Admin');
      await authService.saveLastRoute('/attendance');

      expect(authService.getCachedLastRoute(), equals('/attendance'));

      final restoredService = AuthService();
      final restoredUser = await restoredService.restoreSession();

      expect(restoredUser, isNotNull);
      expect(restoredUser!.role, equals('Super Admin'));
      expect(restoredService.getCachedLastRoute(), equals('/attendance'));

      await restoredService.signOut();
      expect(restoredService.getCachedLastRoute(), isNull);
      final afterSignOutUser = await restoredService.restoreSession();
      expect(afterSignOutUser, isNull);
    });

    test('Attendance session storage writes, reads, and clears reliably', () async {
      SharedPreferences.setMockInitialValues({});
      expect(await authService.hasActiveAttendanceSession(), isFalse);

      await authService.saveAttendanceSession(role: 'Super Admin');
      expect(await authService.hasActiveAttendanceSession(), isTrue);
      expect(authService.isAttendanceSessionActive, isTrue);

      final details = await authService.getAttendanceSessionDetails();
      expect(details, isNotNull);
      expect(details!['isUnlocked'], isTrue);
      expect(details['role'], equals('Super Admin'));

      await authService.clearAttendanceSession();
      expect(await authService.hasActiveAttendanceSession(), isFalse);
      expect(authService.isAttendanceSessionActive, isFalse);
    });
  });

  group('LoginScreen Multi-Role UI Tests', () {
    testWidgets('Displays role tabs and toggles between Super Admin, Coordinator, and Driver', (tester) async {
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

      // Check role tabs
      expect(find.text('Super Admin'), findsWidgets);
      expect(find.text('Coordinator'), findsOneWidget);
      expect(find.text('Driver'), findsOneWidget);

      // Default Super Admin shows Transport Operations & Attendance Section
      expect(find.text('Transport Operations'), findsOneWidget);
      expect(find.text('Attendance Section'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Switch to Attendance Section under Super Admin
      await tester.tap(find.text('Attendance Section'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Attendance Section Access'), findsOneWidget);
      expect(find.text('Demo PIN: 1170'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);

      // Switch to Coordinator role
      await tester.tap(find.text('Coordinator'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Coordinator Portal Access'), findsOneWidget);
      expect(find.text('Demo PIN: 1170'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);

      // Switch to Driver role
      await tester.tap(find.text('Driver'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Driver Portal Access'), findsOneWidget);
      expect(find.text('Demo PIN: 1170'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
    });
  });
}
