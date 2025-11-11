import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/models/api_models/world_stats_model.dart';
import 'package:worldorganizer_app/models/api_models/world_timeline_model.dart';

class WorldSyncService {
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/worlds';

  WorldSyncService({
    required WorldsDao worldsDao,
    required FlutterSecureStorage storage,
  })  : _worldsDao = worldsDao,
        _storage = storage;

  Future<String?> _getToken() => _storage.read(key: 'token');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchAndMergeWorlds() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        final apiWorlds = body
            .map((dynamic item) => World.fromJson(item))
            .toList();

        for (final apiWorld in apiWorlds) {
          final existing = await _worldsDao.getWorldByServerId(apiWorld.id);

          final companion = WorldsCompanion(
            localId: existing != null
                ? Value(existing.localId)
                : const Value.absent(),
            serverId: Value(apiWorld.id),
            name: Value(apiWorld.name),
            description: Value(apiWorld.description),
            modules: Value(apiWorld.modules?.toJson()),
            coverImage: Value(apiWorld.coverImage),
            customImage: Value(apiWorld.customImage),
            syncStatus: const Value(SyncStatus.synced),
          );

          await _worldsDao.insertWorld(companion);
        }
      } else {
        throw Exception('Failed to fetch worlds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch worlds: $e');
    }
  }

  Future<void> syncDirtyWorlds() async {
    final token = await _getToken();
    if (token == null) return;

    final dirtyWorlds = await _worldsDao.getDirtyWorlds();
    final headers = await _getHeaders();

    for (final world in dirtyWorlds) {
      try {
        if (world.syncStatus == SyncStatus.created) {
          await _syncCreatedWorld(world, headers);
        } else if (world.syncStatus == SyncStatus.edited) {
          await _syncEditedWorld(world, headers);
        } else if (world.syncStatus == SyncStatus.deleted) {
          await _syncDeletedWorld(world, headers);
        }
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _syncCreatedWorld(
    WorldEntity world,
    Map<String, String> headers,
  ) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode({
        'name': world.name,
        'description': world.description,
        'modules': world.modules != null ? jsonDecode(world.modules!) : null,
      }),
    );

    if (response.statusCode == 201) {
      final apiWorld = World.fromJson(jsonDecode(response.body));
      final companion = world
          .toCompanion(true)
          .copyWith(
            serverId: Value(apiWorld.id),
            syncStatus: const Value(SyncStatus.synced),
            coverImage: Value(apiWorld.coverImage),
            customImage: Value(apiWorld.customImage),
          );
      await _worldsDao.updateWorld(companion);
    } else {
      throw Exception('Failed to create world on API');
    }
  }

  Future<void> _syncEditedWorld(
    WorldEntity world,
    Map<String, String> headers,
  ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${world.serverId}'),
      headers: headers,
      body: jsonEncode({
        'name': world.name,
        'description': world.description,
        'modules': world.modules != null ? jsonDecode(world.modules!) : null,
      }),
    );

    if (response.statusCode == 200) {
      final companion = world
          .toCompanion(true)
          .copyWith(syncStatus: const Value(SyncStatus.synced));
      await _worldsDao.updateWorld(companion);
    } else {
      throw Exception('Failed to update world on API');
    }
  }

  Future<void> _syncDeletedWorld(
    WorldEntity world,
    Map<String, String> headers,
  ) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/${world.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _worldsDao.deleteWorld(world.localId);
    } else {
      throw Exception('Failed to delete world on API');
    }
  }

  Future<WorldStats> getStats(String serverId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$serverId/stats'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return WorldStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<List<Activity>> getTimeline(String serverId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$serverId/timeline'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load timeline');
    }
  }
}