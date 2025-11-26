import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/stories_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/story_model.dart';

class StorySyncService {
  final StoriesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/stories';

  StorySyncService({
    required StoriesDao dao,
    required WorldsDao worldsDao,
    required FlutterSecureStorage storage,
  })  : _dao = dao,
        _worldsDao = worldsDao,
        _storage = storage;

  Future<String?> _getToken() => _storage.read(key: 'token');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchAndMergeStories(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch stories: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> storyList = body['stories'];
      final apiStories = storyList.map((j) => Story.fromJson(j)).toList();

      for (final apiStory in apiStories) {
        final existing = await _dao.getStoryByServerId(apiStory.id);
        
        final companion = StoriesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiStory.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiStory.name),
          summary: d.Value(apiStory.summary),
          timelineJson: apiStory.timeline != null
              ? d.Value(jsonEncode(apiStory.timeline!.toJson()))
              : const d.Value(null),
          tagColor: d.Value(apiStory.tagColor),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertStory(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge stories: $e');
    }
  }

  Future<void> fetchAndMergeSingleStory(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch story $serverId: ${response.statusCode}');
      }

      final apiStory = Story.fromJson(jsonDecode(response.body));
      if (apiStory.worldId == null) {
        throw Exception('Story from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiStory.worldId!);
      if (world == null) {
        throw Exception('Story\'s world is not synced locally');
      }

      final existing = await _dao.getStoryByServerId(apiStory.id);
      
      final companion = StoriesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiStory.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiStory.name),
        summary: d.Value(apiStory.summary),
        timelineJson: apiStory.timeline != null
            ? d.Value(jsonEncode(apiStory.timeline!.toJson()))
            : const d.Value(null),
        tagColor: d.Value(apiStory.tagColor),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertStory(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single story: $e');
    }
  }

  Future<void> syncDirtyStories() async {
    final dirtyStories = await _dao.getDirtyStories();
    if (dirtyStories.isEmpty) return;
    
  }
}