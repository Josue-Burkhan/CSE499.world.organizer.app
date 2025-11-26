import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/abilities_dao.dart';

class AbilityRepository {
  final AbilitiesDao _dao;

  AbilityRepository({required AbilitiesDao dao}) : _dao = dao;

  Stream<List<AbilityEntity>> watchAbilitiesInWorld(String worldLocalId) {
    return _dao.watchAbilitiesInWorld(worldLocalId);
  }
  
  Stream<AbilityEntity?> watchAbilityByServerId(String serverId) {
    return _dao.watchAbilityByServerId(serverId);
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
    }
  }
}