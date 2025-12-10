import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';

@DataClassName('StoryEntity')
class Stories extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get timelineJson => text().named('timeline_json').nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();

  @override
  Set<Column> get primaryKey => {localId};
}