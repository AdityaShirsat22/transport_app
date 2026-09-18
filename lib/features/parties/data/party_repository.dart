import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../domain/party_model.dart';

abstract class PartyRepository {
  List<Party> getAll();
  Party? getById(String id);
  void add(Party party);
  void update(Party party);
  void delete(String id);
  Future<void> reloadFromDatabase();
}

class ProductionPartyRepository implements PartyRepository {
  final AppDatabase _db;
  final List<Party> _parties = [];
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionPartyRepository(this._db) {
    _init();
  }

  Future<void> _init() async {
    try {
      await reloadFromDatabase();
    } catch (_) {
      // Safe fallback
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  @override
  Future<void> reloadFromDatabase() async {
    try {
      final rows = await (_db.select(_db.localParties)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (rows.isNotEmpty) {
        _parties.clear();
        for (final row in rows) {
          _parties.add(
            Party(
              id: row.id,
              name: row.partyName,
              mobileNumber: row.customerMobile,
              email: row.email,
              city: row.city,
              isActive: row.isActive,
              createdAt: row.createdAt,
            ),
          );
        }
      }
    } catch (_) {
      // Safe fallback
    }
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
    _parties.insert(0, party);
    _persistToDb(party);
    _enqueueSync(party, 'CREATE');
  }

  @override
  void update(Party party) {
    final index = _parties.indexWhere((p) => p.id == party.id);
    if (index != -1) {
      _parties[index] = party;
      _persistToDb(party);
      _enqueueSync(party, 'UPDATE');
    }
  }

  @override
  void delete(String id) {
    final index = _parties.indexWhere((p) => p.id == id);
    if (index != -1) {
      _parties.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localParties)..where((t) => t.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-pty-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'party',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(Party p) async {
    try {
      await _db.into(_db.localParties).insertOnConflictUpdate(
            LocalPartiesCompanion(
              id: Value(p.id),
              partyName: Value(p.name),
              customerMobile: Value(p.mobileNumber),
              email: Value(p.email),
              city: Value(p.city),
              isActive: Value(p.isActive),
              createdAt: Value(p.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(Party p, String op) {
    _db.enqueueSync(
      id: 'sync-pty-${DateTime.now().millisecondsSinceEpoch}-${p.id}',
      entityType: 'party',
      entityId: p.id,
      operation: op,
      payload: jsonEncode({
        'id': p.id,
        'party_name': p.name,
        'customer_mobile': p.mobileNumber,
        'email': p.email,
        'city': p.city,
        'is_active': p.isActive,
        'created_at': p.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionPartyRepository(db);
});
