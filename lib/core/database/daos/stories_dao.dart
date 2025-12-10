import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/stories.dart';

part 'stories_dao.g.dart';

@DriftAccessor(tables: [Stories])
class StoriesDao extends DatabaseAccessor<AppDatabase> with _$StoriesDaoMixin {
  StoriesDao(AppDatabase db) : super(db);

  Stream<List<StoryEntity>> watchStoriesInWorld(String worldLocalId) {
    return (select(stories)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<StoryEntity?> watchStoryByServerId(String serverId) {
    return (select(stories)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<StoryEntity?> getStoryByServerId(String serverId) {
    return (select(stories)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<StoryEntity>> getDirtyStories() {
    return (select(stories)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertStory(StoriesCompanion story) {
    return into(stories).insert(story, mode: InsertMode.replace);
  }

  Future<void> updateStory(StoriesCompanion story) {
    return update(stories).replace(story);
  }

  Future<void> deleteStory(String localId) {
    return (delete(stories)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<StoryEntity?> getStoryByLocalId(String localId) {
    return (select(stories)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
}