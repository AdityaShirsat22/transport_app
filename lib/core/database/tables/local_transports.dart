import 'package:drift/drift.dart';

class LocalTransports extends Table {
  TextColumn get id => text()();
  TextColumn get transportNumber => text()();
  TextColumn get bookingNumber => text()();
  TextColumn get containerNumber => text()();
  TextColumn get sealNumber => text()();
  TextColumn get containerSize => text()(); // '20 FT', '40 FT'
  TextColumn get shipmentType => text()(); // 'EXPORT', 'IMPORT'

  // Foreign keys
  TextColumn get partyId => text()();
  TextColumn get partyName => text()();
  TextColumn get partyMobile => text().nullable()();
  TextColumn get bookingPartyId => text()();
  TextColumn get bookingPartyName => text()();
  TextColumn get shippingLineId => text()();
  TextColumn get shippingLineName => text()();

  TextColumn get fromLocationId => text()();
  TextColumn get fromLocationName => text()();
  TextColumn get toLocationId => text()();
  TextColumn get toLocationName => text()();
  TextColumn get portCfsId => text()();
  TextColumn get portCfsName => text()();

  // Assignment
  TextColumn get vehicleId => text().nullable()();
  TextColumn get vehicleNumber => text().nullable()();
  TextColumn get driverId => text().nullable()();
  TextColumn get driverName => text().nullable()();
  TextColumn get driverMobile => text().nullable()();

  // Status & Timestamps
  TextColumn get status => text().withDefault(const Constant('NEW'))();
  TextColumn get exceptionReason => text().nullable()();

  DateTimeColumn get vehicleReportedAt => dateTime().nullable()();
  DateTimeColumn get containerPickedUpAt => dateTime().nullable()();
  DateTimeColumn get inTransitAt => dateTime().nullable()();
  DateTimeColumn get atPortCfsAt => dateTime().nullable()();
  DateTimeColumn get containerDeliveredAt => dateTime().nullable()();
  DateTimeColumn get podReceivedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
