import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/features/reports/data/report_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late ReportExportService service;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('transport_report_export_test_');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    service = ReportExportService();
  });

  group('ReportExportService Tests', () {
    test('exportToExcel generates valid non-empty .xlsx file with structured data', () async {
      final headers = ['Date', 'Transport ID', 'Booking #', 'Customer', 'Status'];
      final rows = [
        ['2026-09-18', 'TRP-001', 'BK-100', 'Maersk Logistics', 'COMPLETED'],
        ['2026-09-18', 'TRP-002', 'BK-101', 'MSC Shipping', 'IN_TRANSIT'],
      ];

      final file = await service.exportToExcel(
        title: 'Daily Transport Test',
        headers: headers,
        rows: rows,
        filenamePrefix: 'test_daily',
      );

      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.xlsx'), isTrue);
      expect(await file.length(), greaterThan(100)); // Non-empty binary spreadsheet
    });

    test('exportToPdf generates valid non-empty .pdf file with styled table', () async {
      final headers = ['Date', 'Vehicle', 'Trips', 'Utilization'];
      final rows = [
        ['2026-09-18', 'MH04AS1170', '4', '85%'],
        ['2026-09-18', 'MH04AS1171', '3', '70%'],
      ];

      final file = await service.exportToPdf(
        title: 'Vehicle Utilization Test',
        subtitle: 'Filtered Historical Records',
        headers: headers,
        rows: rows,
        filenamePrefix: 'test_vehicle_utilization',
      );

      expect(file.existsSync(), isTrue);
      expect(file.path.endsWith('.pdf'), isTrue);
      expect(await file.length(), greaterThan(500)); // Non-empty PDF document

      // Verify PDF header bytes (%PDF)
      final bytes = await file.readAsBytes();
      final headerStr = String.fromCharCodes(bytes.take(5));
      expect(headerStr, equals('%PDF-'));
    });
  });
}
