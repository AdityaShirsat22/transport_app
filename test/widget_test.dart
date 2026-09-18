import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_app/app/app.dart';
import 'package:transport_app/core/database/app_database.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Widget Tests', () {
    testWidgets('TransportApp loads and shows FreightOps brand and Operations Dashboard', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
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

      expect(find.text('FreightOps'), findsWidgets);
      expect(find.text('Operations Dashboard'), findsOneWidget);
      expect(find.text('Total Transport'), findsOneWidget);
      expect(find.text('Fleet Availability Dashboard'), findsOneWidget);

      await db.close();
    });
  });
}
