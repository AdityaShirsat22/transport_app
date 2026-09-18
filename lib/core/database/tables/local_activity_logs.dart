import 'package:drift/drift.dart';

class LocalActivityLogs extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text().nullable()();
  TextColumn get userId => text().nullable()();
  TextColumn get action => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
