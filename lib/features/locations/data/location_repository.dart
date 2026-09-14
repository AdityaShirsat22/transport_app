import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/location_model.dart';

abstract class LocationRepository {
  List<Location> getAll();
  Location? getById(String id);
  void add(Location location);
  void update(Location location);
  void delete(String id);
}

class MockLocationRepository implements LocationRepository {
  final List<Location> _locations = [];

  MockLocationRepository() {
    _locations.addAll(DemoSeedData.getLocations());
  }

  @override
  List<Location> getAll() => List.unmodifiable(_locations);

  @override
  Location? getById(String id) {
    try {
      return _locations.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Location location) {
    _locations.add(location);
  }

  @override
  void update(Location location) {
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      _locations[index] = location;
    }
  }

  @override
  void delete(String id) {
    _locations.removeWhere((l) => l.id == id);
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return MockLocationRepository();
});
