import 'package:drift/drift.dart';

class LocalTransportAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text()();
  IntColumn get slotIndex => integer()();
  TextColumn get vehicleId => text()();
  TextColumn get vehicleNumber => text()();
  TextColumn get driverId => text().nullable()();
  TextColumn get driverName => text().nullable()();
  TextColumn get driverMobile => text().nullable()();
  TextColumn get containerNumber => text().nullable()(); // per-slot container
  TextColumn get sealNumber => text().nullable()(); // per-slot seal
  DateTimeColumn get assignedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
