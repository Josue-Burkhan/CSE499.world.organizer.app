import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import '../converters/module_link_list_converter.dart';
import '../converters/list_string_converter.dart';

@DataClassName('FactionEntity')
class Factions extends Table {
  TextColumn get localId => text().clientDefault(() => const Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();

  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get symbol => text().nullable()();
  TextColumn get economicSystem => text().nullable()();
  TextColumn get technology => text().nullable()();
  TextColumn get goals => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get history => text().nullable()();
  TextColumn get customNotes => text().nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();

  TextColumn get alliesJson => text().named('allies_json').nullable()();
  TextColumn get enemiesJson => text().named('enemies_json').nullable()();

  TextColumn get rawAllies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEnemies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCharacters => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawHeadquarters => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTerritory => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEvents => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawItems => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawReligions => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLanguages => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawPowerSystems => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {localId};
}