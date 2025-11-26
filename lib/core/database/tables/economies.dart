import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';

@DataClassName('EconomyEntity')
class Economies extends Table {
  TextColumn get localId => text().clientDefault(() => const Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get currencyJson => text().named('currency_json').nullable()();
  TextColumn get tradeGoods => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get keyIndustries => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get economicSystem => text()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCharacters => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFactions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawItems => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawRaces => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {localId};
}