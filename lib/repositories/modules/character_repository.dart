import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';

class CharacterRepository {
  final CharactersDao _dao;

  CharacterRepository({required CharactersDao dao}) : _dao = dao;

  Stream<List<CharacterEntity>> watchCharactersInWorld(String worldLocalId) {
    return _dao.watchCharactersInWorld(worldLocalId);
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
    }
  }
}