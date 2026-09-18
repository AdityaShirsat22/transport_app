import 'package:drift/drift.dart';

class LocalTransportStatusHistory extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text()();
  TextColumn get status => text()();
  TextColumn get remarks => text().nullable()();
  TextColumn get changedBy => text().withDefault(const Constant('Super Admin'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
