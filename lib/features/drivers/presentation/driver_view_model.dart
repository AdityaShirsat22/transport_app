import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/driver_status.dart';
import '../data/driver_repository.dart';
import '../domain/driver_model.dart';

class DriverState {
  final List<Driver> drivers;
  final String searchQuery;
  final DriverStatus? statusFilter;
  final bool isLoading;
  final String? errorMessage;

  const DriverState({
    this.drivers = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.isLoading = false,
    this.errorMessage,
  });

  List<Driver> get filteredDrivers {
    return drivers.where((d) {
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchName = d.name.toLowerCase().contains(q);
        final matchMobile = d.mobileNumber.contains(q);
        final matchVehicle = d.currentVehicleNumber?.toLowerCase().contains(q) ?? false;
        if (!matchName && !matchMobile && !matchVehicle) return false;
      }
      if (statusFilter != null && d.status != statusFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  DriverState copyWith({
    List<Driver>? drivers,
    String? searchQuery,
    DriverStatus? statusFilter,
    bool? isLoading,
    String? errorMessage,
    bool clearStatusFilter = false,
  }) {
    return DriverState(
      drivers: drivers ?? this.drivers,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class DriverViewModel extends StateNotifier<DriverState> {
  final DriverRepository _repo;

  DriverViewModel(this._repo) : super(const DriverState()) {
    loadDrivers();
  }

  void loadDrivers() {
    state = state.copyWith(drivers: _repo.getAll());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(DriverStatus? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
  }

  bool addDriver({
    required String name,
    required String mobileNumber,
    required DriverStatus status,
  }) {
    final newDriver = Driver(
      id: 'drv-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      mobileNumber: mobileNumber.trim(),
      status: status,
      createdAt: DateTime.now(),
    );

    _repo.add(newDriver);
    loadDrivers();
    return true;
  }

  bool updateDriver(Driver driver) {
    _repo.update(driver);
    loadDrivers();
    return true;
  }

  void updateStatus(String id, DriverStatus status) {
    _repo.updateStatus(id, status);
    loadDrivers();
  }

  void deleteDriver(String id) {
    _repo.delete(id);
    loadDrivers();
  }
}

final driverViewModelProvider =
    StateNotifierProvider<DriverViewModel, DriverState>((ref) {
  final repo = ref.watch(driverRepositoryProvider);
  return DriverViewModel(repo);
});
