import 'package:drift/drift.dart';

class LocalVehicles extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleNumber => text()();
  TextColumn get vehicleType => text()();
  TextColumn get capacity => text()(); // '20 FT' or '40 FT'
  TextColumn get status => text().withDefault(const Constant('AVAILABLE'))();
  TextColumn get assignedDriverId => text().nullable()();
  TextColumn get assignedDriverName => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
