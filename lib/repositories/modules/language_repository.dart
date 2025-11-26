import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/languages_dao.dart';

class LanguageRepository {
  final LanguagesDao _dao;

  LanguageRepository({required LanguagesDao dao}) : _dao = dao;

  Stream<List<LanguageEntity>> watchLanguagesInWorld(String worldLocalId) {
    return _dao.watchLanguagesInWorld(worldLocalId);
  }
  
  Stream<LanguageEntity?> watchLanguageByServerId(String serverId) {
    return _dao.watchLanguageByServerId(serverId);
  }

  Future<void> deleteLanguage(String localId) async {
    final char = await _dao.getLanguageByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteLanguage(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateLanguage(companion);
    }
  }
}