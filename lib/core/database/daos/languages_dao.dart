import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/languages.dart';

part 'languages_dao.g.dart';

@DriftAccessor(tables: [Languages])
class LanguagesDao extends DatabaseAccessor<AppDatabase> with _$LanguagesDaoMixin {
  LanguagesDao(AppDatabase db) : super(db);

  Stream<List<LanguageEntity>> watchLanguagesInWorld(String worldLocalId) {
    return (select(languages)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<LanguageEntity?> watchLanguageByServerId(String serverId) {
    return (select(languages)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<LanguageEntity?> getLanguageByServerId(String serverId) {
    return (select(languages)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<LanguageEntity>> getDirtyLanguages() {
    return (select(languages)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertLanguage(LanguagesCompanion language) {
    return into(languages).insert(language, mode: InsertMode.replace);
  }

  Future<void> updateLanguage(LanguagesCompanion language) {
    return update(languages).replace(language);
  }

  Future<void> deleteLanguage(String localId) {
    return (delete(languages)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<LanguageEntity?> getLanguageByLocalId(String localId) {
    return (select(languages)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}