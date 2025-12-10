import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/abilities.dart';

part 'abilities_dao.g.dart';

@DriftAccessor(tables: [Abilities])
class AbilitiesDao extends DatabaseAccessor<AppDatabase> with _$AbilitiesDaoMixin {
  AbilitiesDao(AppDatabase db) : super(db);

  Stream<List<AbilityEntity>> watchAbilitiesInWorld(String worldLocalId) {
    return (select(abilities)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<AbilityEntity?> watchAbilityByServerId(String serverId) {
    return (select(abilities)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<AbilityEntity?> getAbilityByServerId(String serverId) {
    return (select(abilities)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<AbilityEntity>> getDirtyAbilities() {
    return (select(abilities)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertAbility(AbilitiesCompanion ability) {
    return into(abilities).insert(ability, mode: InsertMode.replace);
  }

  Future<void> updateAbility(AbilitiesCompanion ability) {
    return update(abilities).replace(ability);
  }

  Future<void> deleteAbility(String localId) {
    return (delete(abilities)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<AbilityEntity?> getAbilityByLocalId(String localId) {
    return (select(abilities)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}