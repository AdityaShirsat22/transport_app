import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/location_type.dart';
import '../../../core/sync/sync_engine.dart';
import '../data/location_repository.dart';
import '../domain/location_model.dart';

class LocationState {
  final List<Location> locations;
  final String searchQuery;
  final LocationType? typeFilter;

  const LocationState({
    this.locations = const [],
    this.searchQuery = '',
    this.typeFilter,
  });

  List<Location> get filteredLocations {
    return locations.where((l) {
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        if (!l.name.toLowerCase().contains(q)) return false;
      }
      if (typeFilter != null && l.type != typeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  LocationState copyWith({
    List<Location>? locations,
    String? searchQuery,
    LocationType? typeFilter,
    bool clearTypeFilter = false,
  }) {
    return LocationState(
      locations: locations ?? this.locations,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
    );
  }
}

class LocationViewModel extends StateNotifier<LocationState> {
  final LocationRepository _repo;
  final void Function() _autoSync;

  LocationViewModel(this._repo, this._autoSync) : super(const LocationState()) {
    loadLocations();
  }

  void loadLocations() {
    state = state.copyWith(locations: _repo.getAll());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setTypeFilter(LocationType? type) {
    if (type == null) {
      state = state.copyWith(clearTypeFilter: true);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  void addLocation({required String name, required LocationType type}) {
    final item = Location(
      id: 'loc-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      type: type,
      createdAt: DateTime.now(),
    );
    _repo.add(item);
    loadLocations();
    _autoSync();
  }

  void updateLocation(Location location) {
    _repo.update(location);
    loadLocations();
    _autoSync();
  }

  void deleteLocation(String id) {
    _repo.delete(id);
    loadLocations();
    _autoSync();
  }
}

final locationViewModelProvider =
    StateNotifierProvider<LocationViewModel, LocationState>((ref) {
  final repo = ref.watch(locationRepositoryProvider);
  final sync = ref.read(syncEngineProvider.notifier);
  return LocationViewModel(repo, () => sync.triggerAutoSync());
});
