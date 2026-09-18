import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/vehicle_status.dart';
import '../data/vehicle_repository.dart';
import '../domain/vehicle_model.dart';

class VehicleState {
  final List<Vehicle> vehicles;
  final String searchQuery;
  final VehicleStatus? statusFilter;
  final String? typeFilter;
  final bool isLoading;
  final String? errorMessage;

  const VehicleState({
    this.vehicles = const [],
    this.searchQuery = '',
    this.statusFilter,
    this.typeFilter,
    this.isLoading = false,
    this.errorMessage,
  });

  List<Vehicle> get filteredVehicles {
    return vehicles.where((v) {
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchNum = v.vehicleNumber.toLowerCase().contains(q);
        final matchType = v.vehicleType.toLowerCase().contains(q);
        final matchDriver = v.assignedDriverName?.toLowerCase().contains(q) ?? false;
        if (!matchNum && !matchType && !matchDriver) return false;
      }
      if (statusFilter != null && v.status != statusFilter) {
        return false;
      }
      if (typeFilter != null && typeFilter!.isNotEmpty && v.vehicleType != typeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  VehicleState copyWith({
    List<Vehicle>? vehicles,
    String? searchQuery,
    VehicleStatus? statusFilter,
    String? typeFilter,
    bool? isLoading,
    String? errorMessage,
    bool clearStatusFilter = false,
    bool clearTypeFilter = false,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class VehicleViewModel extends StateNotifier<VehicleState> {
  final VehicleRepository _repo;

  VehicleViewModel(this._repo) : super(const VehicleState()) {
    loadVehicles();
  }

  void loadVehicles() {
    state = state.copyWith(vehicles: _repo.getAll());
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(VehicleStatus? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
  }

  void setTypeFilter(String? type) {
    if (type == null || type.isEmpty) {
      state = state.copyWith(clearTypeFilter: true);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  bool addVehicle({
    required String vehicleNumber,
    required String vehicleType,
    required String capacity,
    required VehicleStatus status,
  }) {
    // Check uniqueness
    final existing = _repo.getByNumber(vehicleNumber);
    if (existing != null) {
      state = state.copyWith(errorMessage: 'Vehicle number already exists');
      return false;
    }

    final newVeh = Vehicle(
      id: 'veh-${DateTime.now().millisecondsSinceEpoch}',
      vehicleNumber: vehicleNumber.trim().toUpperCase(),
      vehicleType: vehicleType,
      capacity: capacity,
      status: status,
      createdAt: DateTime.now(),
    );

    _repo.add(newVeh);
    loadVehicles();
    return true;
  }

  bool updateVehicle(Vehicle updated) {
    _repo.update(updated);
    loadVehicles();
    return true;
  }

  void updateStatus(String id, VehicleStatus status) {
    _repo.updateStatus(id, status);
    loadVehicles();
  }

  bool deleteVehicle(String id) {
    final veh = _repo.getById(id);
    if (veh != null && (veh.status == VehicleStatus.onTrip || veh.assignedDriverId != null)) {
      state = state.copyWith(errorMessage: 'Cannot deactivate vehicle while actively assigned to an ongoing trip.');
      return false;
    }
    _repo.delete(id);
    loadVehicles();
    return true;
  }
}

final vehicleViewModelProvider =
    StateNotifierProvider<VehicleViewModel, VehicleState>((ref) {
  final repo = ref.watch(vehicleRepositoryProvider);
  return VehicleViewModel(repo);
});
