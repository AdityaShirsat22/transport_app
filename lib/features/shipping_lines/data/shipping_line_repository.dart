import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/shipping_line_model.dart';

abstract class ShippingLineRepository {
  List<ShippingLine> getAll();
  ShippingLine? getById(String id);
  void add(ShippingLine shippingLine);
  void update(ShippingLine shippingLine);
  void delete(String id);
}

class MockShippingLineRepository implements ShippingLineRepository {
  final List<ShippingLine> _shippingLines = [];

  MockShippingLineRepository() {
    _shippingLines.addAll(DemoSeedData.getShippingLines());
  }

  @override
  List<ShippingLine> getAll() => List.unmodifiable(_shippingLines);

  @override
  ShippingLine? getById(String id) {
    try {
      return _shippingLines.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(ShippingLine shippingLine) {
    _shippingLines.add(shippingLine);
  }

  @override
  void update(ShippingLine shippingLine) {
    final index = _shippingLines.indexWhere((s) => s.id == shippingLine.id);
    if (index != -1) {
      _shippingLines[index] = shippingLine;
    }
  }

  @override
  void delete(String id) {
    _shippingLines.removeWhere((s) => s.id == id);
  }
}

final shippingLineRepositoryProvider = Provider<ShippingLineRepository>((ref) {
  return MockShippingLineRepository();
});
