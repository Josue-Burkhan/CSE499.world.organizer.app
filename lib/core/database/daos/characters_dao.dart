import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/characters.dart';
import '../tables/worlds.dart';

part 'characters_dao.g.dart';

@DriftAccessor(tables: [Characters])
class CharactersDao extends DatabaseAccessor<AppDatabase> with _$CharactersDaoMixin {
  CharactersDao(AppDatabase db) : super(db);

  Stream<List<CharacterEntity>> watchCharactersInWorld(String worldLocalId) {
    return (select(characters)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<CharacterEntity?> watchCharacterByServerId(String serverId) {
    return (select(characters)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<CharacterEntity?> getCharacterByServerId(String serverId) {
    return (select(characters)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<CharacterEntity>> getDirtyCharacters() {
    return (select(characters)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertCharacter(CharactersCompanion char) {
    return into(characters).insert(char, mode: InsertMode.replace);
  }

  Future<void> updateCharacter(CharactersCompanion char) {
    return update(characters).replace(char);
  }

  Future<void> deleteCharacter(String localId) {
    return (delete(characters)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<CharacterEntity?> getCharacterByLocalId(String localId) {
    return (select(characters)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}
