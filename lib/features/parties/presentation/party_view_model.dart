import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/sync/sync_engine.dart';
import '../../transport/data/transport_repository.dart';
import '../data/party_repository.dart';
import '../domain/party_model.dart';

class PartyWithTripStats {
  final Party party;
  final int totalTrips;
  final int completedTrips;
  final int activeTrips;
  final int cancelledTrips;

  const PartyWithTripStats({
    required this.party,
    required this.totalTrips,
    required this.completedTrips,
    required this.activeTrips,
    required this.cancelledTrips,
  });
}

class PartyState {
  final List<PartyWithTripStats> parties;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const PartyState({
    this.parties = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  List<PartyWithTripStats> get filteredParties {
    if (searchQuery.isEmpty) return parties;
    final q = searchQuery.toLowerCase();
    return parties.where((p) {
      return p.party.name.toLowerCase().contains(q) ||
          p.party.mobileNumber.contains(q) ||
          p.party.city.toLowerCase().contains(q);
    }).toList();
  }

  PartyState copyWith({
    List<PartyWithTripStats>? parties,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PartyState(
      parties: parties ?? this.parties,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class PartyViewModel extends StateNotifier<PartyState> {
  final PartyRepository _partyRepo;
  final TransportRepository _transportRepo;
  final void Function() _autoSync;

  PartyViewModel(this._partyRepo, this._transportRepo, this._autoSync)
      : super(const PartyState()) {
    loadParties();
    _partyRepo.addListener(_onRepoChanged);
    _partyRepo.initialized.then((_) {
      if (mounted) loadParties();
    });
  }

  void _onRepoChanged() {
    if (mounted) {
      loadParties();
    }
  }

  @override
  void dispose() {
    _partyRepo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void loadParties() {
    final rawParties = _partyRepo.getAll();
    final allTransports = _transportRepo.getAll();

    final List<PartyWithTripStats> list = rawParties.map((p) {
      final transports = allTransports.where((t) => t.partyId == p.id || t.partyName == p.name).toList();
      final total = transports.length;
      final completed = transports.where((t) => t.status.isCompleted).length;
      final cancelled = transports.where((t) => t.status.isCancelled).length;
      final active = total - completed - cancelled;

      return PartyWithTripStats(
        party: p,
        totalTrips: total,
        completedTrips: completed,
        activeTrips: active,
        cancelledTrips: cancelled,
      );
    }).toList();

    state = state.copyWith(parties: list);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  bool addParty({
    required String name,
    required String mobileNumber,
    String email = '',
    String city = '',
  }) {
    final newParty = Party(
      id: 'pty-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      mobileNumber: mobileNumber.trim(),
      email: email.trim(),
      city: city.trim(),
      createdAt: DateTime.now(),
    );

    _partyRepo.add(newParty);
    loadParties();
    _autoSync();
    return true;
  }

  bool updateParty(Party party) {
    _partyRepo.update(party);
    loadParties();
    _autoSync();
    return true;
  }

  void deleteParty(String id) {
    _partyRepo.delete(id);
    loadParties();
    _autoSync();
  }
}

final partyViewModelProvider =
    StateNotifierProvider<PartyViewModel, PartyState>((ref) {
  final partyRepo = ref.watch(partyRepositoryProvider);
  final transportRepo = ref.watch(transportRepositoryProvider);
  final sync = ref.read(syncEngineProvider.notifier);
  return PartyViewModel(partyRepo, transportRepo, () => sync.triggerAutoSync());
});
