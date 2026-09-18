import 'package:drift/drift.dart';

class LocalLocations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get locationType => text()(); // 'CUSTOMER', 'FACTORY', 'WAREHOUSE', 'PORT', 'CFS', 'OTHER'
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
