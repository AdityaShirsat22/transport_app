import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/mock_data/demo_seed_data.dart';
import '../domain/party_model.dart';

abstract class PartyRepository {
  List<Party> getAll();
  Party? getById(String id);
  void add(Party party);
  void update(Party party);
  void delete(String id);
}

class MockPartyRepository implements PartyRepository {
  final List<Party> _parties = [];

  MockPartyRepository() {
    _parties.addAll(DemoSeedData.getParties());
  }

  @override
  List<Party> getAll() => List.unmodifiable(_parties);

  @override
  Party? getById(String id) {
    try {
      return _parties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Party party) {
    _parties.add(party);
  }

  @override
  void update(Party party) {
    final index = _parties.indexWhere((p) => p.id == party.id);
    if (index != -1) {
      _parties[index] = party;
    }
  }

  @override
  void delete(String id) {
    _parties.removeWhere((p) => p.id == id);
  }
}

final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  return MockPartyRepository();
});
