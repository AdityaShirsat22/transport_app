import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/utils/id_generator.dart';

void main() {
  setUp(() {
    IdGenerator.resetForTesting();
  });

  group('IdGenerator Tests', () {
    test('generateTransportId starts from TR-01 and increments sequentially', () {
      expect(IdGenerator.generateTransportId(), equals('TR-01'));
      expect(IdGenerator.generateTransportId(), equals('TR-02'));
      expect(IdGenerator.generateTransportId(), equals('TR-03'));
    });

    test('syncTransportCounter carries on from highest existing ID', () {
      IdGenerator.syncTransportCounter(['TR-01', 'TR-02', 'TR-05']);
      expect(IdGenerator.generateTransportId(), equals('TR-06'));
      expect(IdGenerator.generateTransportId(), equals('TR-07'));
    });

    test('syncTransportCounter ignores legacy dummy TR-00130', () {
      IdGenerator.syncTransportCounter(['TR-00130', 'TR-01']);
      expect(IdGenerator.generateTransportId(), equals('TR-02'));
    });
  });
}
