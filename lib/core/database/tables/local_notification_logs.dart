import 'package:drift/drift.dart';

class LocalNotificationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text()();
  TextColumn get partyId => text().nullable()();
  TextColumn get recipientName => text()();
  TextColumn get recipientMobile => text()();
  TextColumn get channel => text().withDefault(const Constant('WhatsApp'))();
  TextColumn get messageBody => text()();
  TextColumn get status => text().withDefault(const Constant('READY'))();
  DateTimeColumn get sentAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
