import 'package:drift/drift.dart';

class LocalParties extends Table {
  TextColumn get id => text()();
  TextColumn get partyName => text()();
  TextColumn get customerMobile => text()();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
