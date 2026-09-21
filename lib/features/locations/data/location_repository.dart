import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/location_type.dart';
import '../domain/location_model.dart';

abstract class LocationRepository {
  List<Location> getAll();
  Location? getById(String id);
  void add(Location location);
  void update(Location location);
  void delete(String id);
  Future<void> reloadFromDatabase();
  Future<void> get initialized;
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

class ProductionLocationRepository implements LocationRepository {
  final AppDatabase _db;
  final List<Location> _locations = [];
  final List<void Function()> _listeners = [];
  final Completer<void> _initCompleter = Completer<void>();

  @override
  Future<void> get initialized => _initCompleter.future;

  ProductionLocationRepository(this._db) {
    _init();
  }

  @override
  void addListener(void Function() listener) => _listeners.add(listener);

  @override
  void removeListener(void Function() listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final l in List<void Function()>.from(_listeners)) {
      l();
    }
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
      final rows = await (_db.select(_db.localLocations)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      _locations.clear();
      for (final row in rows) {
        _locations.add(
          Location(
            id: row.id,
            name: row.name,
            type: LocationType.fromString(row.locationType),
            isActive: row.isActive,
            createdAt: row.createdAt,
          ),
        );
      }
      _notifyListeners();
    } catch (_) {
      // Safe fallback
    }
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
    _locations.insert(0, location);
    _persistToDb(location);
    _enqueueSync(location, 'CREATE');
    _notifyListeners();
  }

  @override
  void update(Location location) {
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      _locations[index] = location;
      _persistToDb(location);
      _enqueueSync(location, 'UPDATE');
      _notifyListeners();
    }
  }

  @override
  void delete(String id) {
    final index = _locations.indexWhere((l) => l.id == id);
    if (index != -1) {
      _locations.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
      _notifyListeners();
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localLocations)..where((t) => t.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-loc-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'location',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(Location l) async {
    try {
      await _db.into(_db.localLocations).insertOnConflictUpdate(
            LocalLocationsCompanion(
              id: Value(l.id),
              name: Value(l.name),
              locationType: Value(l.type.name),
              isActive: Value(l.isActive),
              createdAt: Value(l.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(Location l, String op) {
    _db.enqueueSync(
      id: 'sync-loc-${DateTime.now().millisecondsSinceEpoch}-${l.id}',
      entityType: 'location',
      entityId: l.id,
      operation: op,
      payload: jsonEncode({
        'id': l.id,
        'name': l.name,
        'location_type': l.type.name,
        'is_active': l.isActive,
        'created_at': l.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionLocationRepository(db);
});
