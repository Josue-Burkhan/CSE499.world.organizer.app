import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/languages_dao.dart';
import 'package:worldorganizer_app/core/services/modules/language_sync_service.dart';

class LanguageRepository {
  final LanguagesDao _dao;
  final LanguageSyncService _syncService;

  LanguageRepository({
    required LanguagesDao dao,
    required LanguageSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<LanguageEntity>> watchLanguagesInWorld(String worldLocalId) {
    return _dao.watchLanguagesInWorld(worldLocalId);
  }
  
  Stream<LanguageEntity?> watchLanguageByServerId(String serverId) {
    return _dao.watchLanguageByServerId(serverId);
  }

  Future<LanguageEntity?> getLanguage(String localId) {
    return _dao.getLanguageByLocalId(localId);
  }

  Future<void> createLanguage(LanguagesCompanion language) async {
    await _dao.insertLanguage(language);
    await _syncService.syncDirtyLanguages();
  }

  Future<void> updateLanguage(LanguagesCompanion language) async {
    final localId = language.localId.value;
    final existing = await _dao.getLanguageByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = language;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = language.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = language.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = language.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateLanguage(updatedCompanion);
    await _syncService.syncDirtyLanguages();
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
      await _syncService.syncDirtyLanguages();
    }
  }
}