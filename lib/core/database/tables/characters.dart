import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';
import '../converters/module_link_list_converter.dart';

@DataClassName('CharacterEntity')
class Characters extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();

  TextColumn get name => text()();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get nickname => text().nullable()();
  TextColumn get customNotes => text().nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();

  TextColumn get appearanceJson => text().named('appearance_json').nullable()();
  TextColumn get personalityJson => text().named('personality_json').nullable()();
  TextColumn get historyJson => text().named('history_json').nullable()();

  TextColumn get familyJson => text().named('family_json').nullable()();
  TextColumn get friendsJson => text().named('friends_json').nullable()();
  TextColumn get enemiesJson => text().named('enemies_json').nullable()();
  TextColumn get romanceJson => text().named('romance_json').nullable()();
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFamily => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFriends => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEnemies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawRomance => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawAbilities => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawItems => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLanguages => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawRaces => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFactions => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawPowerSystems => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawReligions => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCreatures => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEconomies => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ModuleLinkListConverter()).withDefault(const Constant('[]'))();
  
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}
