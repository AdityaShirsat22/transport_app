import 'package:drift/drift.dart';

class LocalDriverAssignments extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text()();
  TextColumn get driverId => text()();
  DateTimeColumn get assignedAt => dateTime()();
  TextColumn get assignedBy => text().withDefault(const Constant('Super Admin'))();
  DateTimeColumn get releasedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
