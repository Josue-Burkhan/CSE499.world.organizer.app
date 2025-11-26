import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/stories_dao.dart';

class StoryRepository {
  final StoriesDao _dao;

  StoryRepository({required StoriesDao dao}) : _dao = dao;

  Stream<List<StoryEntity>> watchStoriesInWorld(String worldLocalId) {
    return _dao.watchStoriesInWorld(worldLocalId);
  }
  
  Stream<StoryEntity?> watchStoryByServerId(String serverId) {
    return _dao.watchStoryByServerId(serverId);
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
    }
  }
}