import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/abilities_dao.dart';
import 'package:worldorganizer_app/core/services/modules/ability_sync_service.dart';

class AbilityRepository {
  final AbilitiesDao _dao;
  final AbilitySyncService _syncService;

  AbilityRepository({
    required AbilitiesDao dao,
    required AbilitySyncService syncService,
    }) : _dao = dao,
         _syncService = syncService;


  Stream<List<AbilityEntity>> watchAbilitiesInWorld(String worldLocalId) {
    return _dao.watchAbilitiesInWorld(worldLocalId);
  }
  
  Stream<AbilityEntity?> watchAbilityByServerId(String serverId) {
    return _dao.watchAbilityByServerId(serverId);
  }

  Future<AbilityEntity?> getAbility(String localId) {
    return _dao.getAbilityByLocalId(localId);
  }

  Future<void> createAbility(AbilitiesCompanion ability) async {
    await _dao.insertAbility(ability);
    await _syncService.syncDirtyAbilities();
  }

  Future<void> updateAbility(AbilitiesCompanion ability) async {
    final localId = ability.localId.value;
    final existing = await _dao.getAbilityByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = ability;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = ability.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = ability.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = ability.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateAbility(updatedCompanion);
    await _syncService.syncDirtyAbilities();
  }

  Future<void> deleteAbility(String localId) async {
    final char = await _dao.getAbilityByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteAbility(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateAbility(companion);
      await _syncService.syncDirtyAbilities();
    }
  }
}