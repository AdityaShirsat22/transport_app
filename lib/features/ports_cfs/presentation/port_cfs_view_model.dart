import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/port_cfs_type.dart';
import '../../../core/sync/sync_engine.dart';
import '../data/port_cfs_repository.dart';
import '../domain/port_cfs_model.dart';

class PortCfsState {
  final List<PortCfs> items;
  final String searchQuery;
  final PortCfsType? typeFilter;

  const PortCfsState({
    this.items = const [],
    this.searchQuery = '',
    this.typeFilter,
  });

  List<PortCfs> get filteredItems {
    return items.where((p) {
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        if (!p.name.toLowerCase().contains(q) && !p.location.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (typeFilter != null && p.type != typeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  PortCfsState copyWith({
    List<PortCfs>? items,
    String? searchQuery,
    PortCfsType? typeFilter,
    bool clearTypeFilter = false,
  }) {
    return PortCfsState(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
    );
  }
}

class PortCfsViewModel extends StateNotifier<PortCfsState> {
  final PortCfsRepository _repo;
  final void Function() _autoSync;

  PortCfsViewModel(this._repo, this._autoSync) : super(const PortCfsState()) {
    loadItems();
  }

  void loadItems() {
    state = state.copyWith(items: _repo.getAll());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setTypeFilter(PortCfsType? type) {
    if (type == null) {
      state = state.copyWith(clearTypeFilter: true);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  void addPortCfs({
    required String name,
    required PortCfsType type,
    required String location,
  }) {
    final item = PortCfs(
      id: 'pc-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      type: type,
      location: location.trim(),
      createdAt: DateTime.now(),
    );
    _repo.add(item);
    loadItems();
    _autoSync();
  }

  void updatePortCfs(PortCfs item) {
    _repo.update(item);
    loadItems();
    _autoSync();
  }

  void deletePortCfs(String id) {
    _repo.delete(id);
    loadItems();
    _autoSync();
  }
}

final portCfsViewModelProvider =
    StateNotifierProvider<PortCfsViewModel, PortCfsState>((ref) {
  final repo = ref.watch(portCfsRepositoryProvider);
  final sync = ref.read(syncEngineProvider.notifier);
  return PortCfsViewModel(repo, () => sync.triggerAutoSync());
});
