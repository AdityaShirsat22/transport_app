import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/port_cfs_model.dart';

abstract class PortCfsRepository {
  List<PortCfs> getAll();
  PortCfs? getById(String id);
  void add(PortCfs portCfs);
  void update(PortCfs portCfs);
  void delete(String id);
}

class MockPortCfsRepository implements PortCfsRepository {
  final List<PortCfs> _items = [];

  MockPortCfsRepository() {
    _items.addAll(DemoSeedData.getPortCfsList());
  }

  @override
  List<PortCfs> getAll() => List.unmodifiable(_items);

  @override
  PortCfs? getById(String id) {
    try {
      return _items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(PortCfs portCfs) {
    _items.add(portCfs);
  }

  @override
  void update(PortCfs portCfs) {
    final index = _items.indexWhere((p) => p.id == portCfs.id);
    if (index != -1) {
      _items[index] = portCfs;
    }
  }

  @override
  void delete(String id) {
    _items.removeWhere((p) => p.id == id);
  }
}

final portCfsRepositoryProvider = Provider<PortCfsRepository>((ref) {
  return MockPortCfsRepository();
});
