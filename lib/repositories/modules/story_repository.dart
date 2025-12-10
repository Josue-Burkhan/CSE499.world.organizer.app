import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/stories_dao.dart';
import 'package:worldorganizer_app/core/services/modules/story_sync_service.dart';

class StoryRepository {
  final StoriesDao _dao;
  final StorySyncService _syncService;

  StoryRepository({
    required StoriesDao dao,
    required StorySyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<StoryEntity>> watchStoriesInWorld(String worldLocalId) {
    return _dao.watchStoriesInWorld(worldLocalId);
  }
  
  Stream<StoryEntity?> watchStoryByServerId(String serverId) {
    return _dao.watchStoryByServerId(serverId);
  }

  Future<StoryEntity?> getStory(String localId) {
    return _dao.getStoryByLocalId(localId);
  }

  Future<void> createStory(StoriesCompanion story) async {
    await _dao.insertStory(story);
    await _syncService.syncDirtyStories();
  }

  Future<void> updateStory(StoriesCompanion story) async {
    final localId = story.localId.value;
    final existing = await _dao.getStoryByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = story;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = story.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = story.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = story.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateStory(updatedCompanion);
    await _syncService.syncDirtyStories();
  }

  Future<void> deleteStory(String localId) async {
    final char = await _dao.getStoryByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteStory(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateStory(companion);
      await _syncService.syncDirtyStories();
    }
  }
}