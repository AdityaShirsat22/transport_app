import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/enums/port_cfs_type.dart';
import '../domain/port_cfs_model.dart';

abstract class PortCfsRepository {
  List<PortCfs> getAll();
  PortCfs? getById(String id);
  void add(PortCfs portCfs);
  void update(PortCfs portCfs);
  void delete(String id);
  Future<void> reloadFromDatabase();
}

class ProductionPortCfsRepository implements PortCfsRepository {
  final AppDatabase _db;
  final List<PortCfs> _items = [];
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionPortCfsRepository(this._db) {
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
      final rows = await (_db.select(_db.localPortsCfs)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (rows.isNotEmpty) {
        _items.clear();
        for (final row in rows) {
          _items.add(
            PortCfs(
              id: row.id,
              name: row.name,
              type: PortCfsType.fromCode(row.type),
              location: row.location,
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
  List<PortCfs> getAll() => List.unmodifiable(_items);

  @override
  PortCfs? getById(String id) {
    try {
      return _items.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(PortCfs portCfs) {
    _items.insert(0, portCfs);
    _persistToDb(portCfs);
    _enqueueSync(portCfs, 'CREATE');
  }

  @override
  void update(PortCfs portCfs) {
    final index = _items.indexWhere((p) => p.id == portCfs.id);
    if (index != -1) {
      _items[index] = portCfs;
      _persistToDb(portCfs);
      _enqueueSync(portCfs, 'UPDATE');
    }
  }

  @override
  void delete(String id) {
    final index = _items.indexWhere((p) => p.id == id);
    if (index != -1) {
      _items.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localPortsCfs)..where((t) => t.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-cfs-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'port_cfs',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(PortCfs pc) async {
    try {
      await _db.into(_db.localPortsCfs).insertOnConflictUpdate(
            LocalPortsCfsCompanion(
              id: Value(pc.id),
              name: Value(pc.name),
              type: Value(pc.type.code),
              location: Value(pc.location),
              isActive: Value(pc.isActive),
              createdAt: Value(pc.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(PortCfs pc, String op) {
    _db.enqueueSync(
      id: 'sync-pc-${DateTime.now().millisecondsSinceEpoch}-${pc.id}',
      entityType: 'port_cfs',
      entityId: pc.id,
      operation: op,
      payload: jsonEncode({
        'id': pc.id,
        'name': pc.name,
        'type': pc.type.code,
        'location': pc.location,
        'is_active': pc.isActive,
        'created_at': pc.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final portCfsRepositoryProvider = Provider<PortCfsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionPortCfsRepository(db);
});
