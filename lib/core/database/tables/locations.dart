import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';

@DataClassName('LocationEntity')
class Locations extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get climate => text().nullable()();
  TextColumn get terrain => text().nullable()();
  RealColumn get population => real().nullable()();
  TextColumn get economy => text().nullable()();
  TextColumn get customNotes => text().nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  
  TextColumn get rawLocations => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFactions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEvents => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCharacters => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawItems => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCreatures => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLanguages => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawReligions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}