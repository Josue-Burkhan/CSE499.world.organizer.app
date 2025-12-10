import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';

@DataClassName('WorldEntity')
class Worlds extends Table {
  TextColumn get localId => text()
      .clientDefault(() => Uuid().v4())();
      
  TextColumn get serverId => text().nullable()();

  TextColumn get syncStatus =>
      text().map(const SyncStatusConverter())
      .clientDefault(() => 'created')();
      
  TextColumn get name => text()();
  TextColumn get description => text()();
  
  TextColumn get modules => text().nullable()();
  TextColumn get coverImage => text().named('cover_image').nullable()();
  TextColumn get customImage => text().named('custom_image').nullable()();
  
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}
