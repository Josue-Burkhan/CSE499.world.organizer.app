import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';

@DataClassName('ReligionEntity')
class Religions extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get deityNames => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get originStory => text().nullable()();
  TextColumn get practices => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get taboos => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get sacredTexts => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get festivals => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get symbols => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get customNotes => text().nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  
  TextColumn get rawCharacters => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFactions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCreatures => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEvents => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawPowerSystems => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {localId};
}