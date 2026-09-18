import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../domain/shipping_line_model.dart';

abstract class ShippingLineRepository {
  List<ShippingLine> getAll();
  ShippingLine? getById(String id);
  void add(ShippingLine shippingLine);
  void update(ShippingLine shippingLine);
  void delete(String id);
  Future<void> reloadFromDatabase();
}

class ProductionShippingLineRepository implements ShippingLineRepository {
  final AppDatabase _db;
  final List<ShippingLine> _shippingLines = [];
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get initialized => _initCompleter.future;

  ProductionShippingLineRepository(this._db) {
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
      final rows = await (_db.select(_db.localShippingLines)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

      if (rows.isNotEmpty) {
        _shippingLines.clear();
        for (final row in rows) {
          _shippingLines.add(
            ShippingLine(
              id: row.id,
              name: row.name,
              code: row.code,
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
  List<ShippingLine> getAll() => List.unmodifiable(_shippingLines);

  @override
  ShippingLine? getById(String id) {
    try {
      return _shippingLines.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(ShippingLine shippingLine) {
    _shippingLines.insert(0, shippingLine);
    _persistToDb(shippingLine);
    _enqueueSync(shippingLine, 'CREATE');
  }

  @override
  void update(ShippingLine shippingLine) {
    final index = _shippingLines.indexWhere((s) => s.id == shippingLine.id);
    if (index != -1) {
      _shippingLines[index] = shippingLine;
      _persistToDb(shippingLine);
      _enqueueSync(shippingLine, 'UPDATE');
    }
  }

  @override
  void delete(String id) {
    final index = _shippingLines.indexWhere((s) => s.id == id);
    if (index != -1) {
      _shippingLines.removeAt(index);
      _deleteFromDb(id);
      _enqueueSyncDelete(id);
    }
  }

  Future<void> _deleteFromDb(String id) async {
    try {
      await (_db.delete(_db.localShippingLines)..where((t) => t.id.equals(id))).go();
    } catch (_) {}
  }

  void _enqueueSyncDelete(String id) {
    _db.enqueueSync(
      id: 'sync-shp-del-${DateTime.now().millisecondsSinceEpoch}-$id',
      entityType: 'shipping_line',
      entityId: id,
      operation: 'DELETE',
      payload: jsonEncode({'id': id}),
    );
  }

  Future<void> _persistToDb(ShippingLine s) async {
    try {
      await _db.into(_db.localShippingLines).insertOnConflictUpdate(
            LocalShippingLinesCompanion(
              id: Value(s.id),
              name: Value(s.name),
              code: Value(s.code),
              isActive: Value(s.isActive),
              createdAt: Value(s.createdAt),
              updatedAt: Value(DateTime.now()),
            ),
          );
    } catch (_) {
      // Safe fallback
    }
  }

  void _enqueueSync(ShippingLine s, String op) {
    _db.enqueueSync(
      id: 'sync-shl-${DateTime.now().millisecondsSinceEpoch}-${s.id}',
      entityType: 'shipping_line',
      entityId: s.id,
      operation: op,
      payload: jsonEncode({
        'id': s.id,
        'name': s.name,
        'code': s.code,
        'is_active': s.isActive,
        'created_at': s.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );
  }
}

final shippingLineRepositoryProvider = Provider<ShippingLineRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProductionShippingLineRepository(db);
});
