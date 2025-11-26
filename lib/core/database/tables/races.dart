import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';

@DataClassName('RaceEntity')
class Races extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get traits => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get lifespan => text().nullable()();
  TextColumn get averageHeight => text().nullable()();
  TextColumn get averageWeight => text().nullable()();
  TextColumn get culture => text().nullable()();
  BoolColumn get isExtinct => boolean().withDefault(const Constant(false))();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  
  TextColumn get rawLanguages => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCharacters => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawReligions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEvents => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawPowerSystems => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {localId};
}