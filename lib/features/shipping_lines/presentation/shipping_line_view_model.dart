import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/shipping_line_repository.dart';
import '../domain/shipping_line_model.dart';

class ShippingLineState {
  final List<ShippingLine> shippingLines;
  final String searchQuery;

  const ShippingLineState({
    this.shippingLines = const [],
    this.searchQuery = '',
  });

  List<ShippingLine> get filteredItems {
    if (searchQuery.isEmpty) return shippingLines;
    final q = searchQuery.toLowerCase();
    return shippingLines
        .where((s) => s.name.toLowerCase().contains(q) || s.code.toLowerCase().contains(q))
        .toList();
  }

  ShippingLineState copyWith({
    List<ShippingLine>? shippingLines,
    String? searchQuery,
  }) {
    return ShippingLineState(
      shippingLines: shippingLines ?? this.shippingLines,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ShippingLineViewModel extends StateNotifier<ShippingLineState> {
  final ShippingLineRepository _repo;

  ShippingLineViewModel(this._repo) : super(const ShippingLineState()) {
    loadItems();
  }

  void loadItems() {
    state = state.copyWith(shippingLines: _repo.getAll());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addShippingLine({required String name, required String code}) {
    final item = ShippingLine(
      id: 'shp-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      code: code.trim().toUpperCase(),
      createdAt: DateTime.now(),
    );
    _repo.add(item);
    loadItems();
  }

  void updateShippingLine(ShippingLine item) {
    _repo.update(item);
    loadItems();
  }

  void deleteShippingLine(String id) {
    _repo.delete(id);
    loadItems();
  }
}

final shippingLineViewModelProvider =
    StateNotifierProvider<ShippingLineViewModel, ShippingLineState>((ref) {
  final repo = ref.watch(shippingLineRepositoryProvider);
  return ShippingLineViewModel(repo);
});
