import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import 'worlds.dart';
import '../converters/list_string_converter.dart';

@DataClassName('ItemEntity')
class Items extends Table {
  TextColumn get localId => text().clientDefault(() => const Uuid().v4())();
  TextColumn get serverId => text().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).clientDefault(() => 'created')();
  TextColumn get worldLocalId => text().references(Worlds, #localId)();
  
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get origin => text().nullable()();
  TextColumn get material => text().nullable()();
  RealColumn get weight => real().nullable()();
  TextColumn get value => text().nullable()();
  TextColumn get rarity => text().nullable()();
  TextColumn get magicalProperties => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get technologicalFeatures => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get customEffects => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  BoolColumn get isUnique => boolean().withDefault(const Constant(false))();
  BoolColumn get isDestroyed => boolean().withDefault(const Constant(false))();
  TextColumn get customNotes => text().nullable()();
  TextColumn get tagColor => text().withDefault(const Constant('neutral'))();
  
  TextColumn get images => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCreatedBy => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawUsedBy => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawCurrentOwnerCharacter => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawFactions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawEvents => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawStories => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLocations => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawReligions => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawTechnologies => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawPowerSystems => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawLanguages => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();
  TextColumn get rawAbilities => text().map(const ListStringConverter()).withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {localId};
}