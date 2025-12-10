import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/characters_dao.dart';

import 'package:worldorganizer_app/core/services/modules/character_sync_service.dart';

class CharacterRepository {
  final CharactersDao _dao;
  final CharacterSyncService _syncService;

  CharacterRepository({
    required CharactersDao dao,
    required CharacterSyncService syncService,
  })  : _dao = dao,
        _syncService = syncService;

  Stream<List<CharacterEntity>> watchCharactersInWorld(String worldLocalId) {
    return _dao.watchCharactersInWorld(worldLocalId);
  }
  
  Stream<CharacterEntity?> watchCharacterByServerId(String serverId) {
    return _dao.watchCharacterByServerId(serverId);
  }

  Future<CharacterEntity?> getCharacter(String localId) {
    return _dao.getCharacterByLocalId(localId);
  }

  Future<void> createCharacter(CharactersCompanion character) async {
    await _dao.insertCharacter(character);
    await _syncService.syncDirtyCharacters();
  }

  Future<void> updateCharacter(CharactersCompanion character) async {
    final localId = character.localId.value;
    final existing = await _dao.getCharacterByLocalId(localId);
    
    if (existing == null) return;

    var updatedCompanion = character;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = character.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = character.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = character.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateCharacter(updatedCompanion);
    await _syncService.syncDirtyCharacters();
  }

  Future<void> deleteCharacter(String localId) async {
    final char = await _dao.getCharacterByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteCharacter(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateCharacter(companion);
      await _syncService.syncDirtyCharacters();
    }
  }
}