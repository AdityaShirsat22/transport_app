import 'package:drift/drift.dart';

class LocalDrivers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get mobileNumber => text()();
  TextColumn get status => text().withDefault(const Constant('AVAILABLE'))();
  TextColumn get currentVehicleId => text().nullable()();
  TextColumn get currentVehicleNumber => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
