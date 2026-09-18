import 'package:drift/drift.dart';

class LocalSyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // 'vehicle', 'driver', 'party', 'shipping_line', 'location', 'port_cfs', 'transport', 'assignment', 'history', 'pod'
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // 'CREATE', 'UPDATE', 'DELETE'
  TextColumn get payload => text()(); // JSON payload of the entity
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('PENDING'))(); // 'PENDING', 'SYNCING', 'SYNCED', 'FAILED'

  @override
  Set<Column> get primaryKey => {id};
}
