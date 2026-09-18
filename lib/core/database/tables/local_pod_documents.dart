import 'package:drift/drift.dart';

class LocalPodDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get transportId => text()();
  TextColumn get fileName => text()();
  TextColumn get storagePath => text()();
  TextColumn get fileType => text()(); // 'PDF', 'IMAGE'
  Int64Column get fileSize => int64()();
  TextColumn get uploadedBy => text().withDefault(const Constant('Super Admin'))();
  DateTimeColumn get uploadedAt => dateTime()();
  TextColumn get fileUrl => text().nullable()();
  TextColumn get localFilePath => text().nullable()(); // Local cached file path when offline

  @override
  Set<Column> get primaryKey => {id};
}
