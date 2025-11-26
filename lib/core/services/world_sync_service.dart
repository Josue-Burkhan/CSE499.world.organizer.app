import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/services/api_service.dart';
import 'package:worldorganizer_app/core/services/image_upload_service.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/models/api_models/world_stats_model.dart';
import 'package:worldorganizer_app/models/api_models/world_timeline_model.dart';
import 'package:worldorganizer_app/models/api_models/search_result_model.dart';

class WorldSyncService {
  final WorldsDao _worldsDao;
  final ApiService _apiService;
  final ImageUploadService _imageUploadService;
  final String _endpoint = '/api/worlds';
  final String _searchEndpoint = '/api/search';

  WorldSyncService({
    required WorldsDao worldsDao,
    required ApiService apiService,
    required ImageUploadService imageUploadService,
  })  : _worldsDao = worldsDao,
        _apiService = apiService,
        _imageUploadService = imageUploadService;

  Future<void> fetchAndMergeWorlds() async {
    try {
      final response = await _apiService.authenticatedRequest(_endpoint);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        final apiWorlds = body
            .map((dynamic item) => World.fromJson(item))
            .toList();

        // 1. Update/Insert worlds from server
        final serverIds = <String>{};
        for (final apiWorld in apiWorlds) {
          serverIds.add(apiWorld.id);
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

        // 2. Delete local worlds that are missing from server (and were previously synced)
        final allLocalWorlds = await _worldsDao.getAllWorlds();
        for (final localWorld in allLocalWorlds) {
          // Only delete if it has a serverId (was synced) AND that serverId is NOT in the new list
          if (localWorld.serverId != null && 
              localWorld.syncStatus == SyncStatus.synced && 
              !serverIds.contains(localWorld.serverId)) {
            print('Deleting local world ${localWorld.name} because it is missing from server.');
            await _worldsDao.deleteWorld(localWorld.localId);
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch worlds: $e');
    }
  }

  Future<void> syncDirtyWorlds() async {
    final dirtyWorlds = await _worldsDao.getDirtyWorlds();

    for (final world in dirtyWorlds) {
      try {
        if (world.syncStatus == SyncStatus.created) {
          await _syncCreatedWorld(world);
        } else if (world.syncStatus == SyncStatus.edited) {
          await _syncEditedWorld(world);
        } else if (world.syncStatus == SyncStatus.deleted) {
          await _syncDeletedWorld(world);
        }
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _syncCreatedWorld(WorldEntity world) async {
    String? coverImageUrl = world.coverImage;
    final pendingUpload = await _worldsDao.getPendingUploadForWorld(world.localId);
    
    if (pendingUpload != null) {
      try {
        final file = File(pendingUpload.filePath);
        if (await file.exists()) {
          coverImageUrl = await _imageUploadService.uploadImage(file, pendingUpload.storagePath);
          await _worldsDao.updateWorld(
            world.toCompanion(true).copyWith(coverImage: Value(coverImageUrl))
          );
        }
        await _worldsDao.deletePendingUpload(world.localId);
      } catch (e) {
        // Continue without image if upload fails
      }
    }

    final body = {
      'name': world.name,
      'description': world.description,
      'template': 'custom',
      'modules': world.modules != null ? jsonDecode(world.modules!) : null,
      'coverImage': coverImageUrl,
      'image': coverImageUrl,
    };

    final response = await _apiService.authenticatedRequest(
      _endpoint,
      method: 'POST',
      body: body,
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
      throw Exception('Failed to create world on API: ${response.statusCode}');
    }
  }

  Future<void> _syncEditedWorld(WorldEntity world) async {
    String? coverImageUrl = world.coverImage;
    final pendingUpload = await _worldsDao.getPendingUploadForWorld(world.localId);
    
    if (pendingUpload != null) {
      try {
        final file = File(pendingUpload.filePath);
        if (await file.exists()) {
          coverImageUrl = await _imageUploadService.uploadImage(file, pendingUpload.storagePath);
          await _worldsDao.updateWorld(
            world.toCompanion(true).copyWith(coverImage: Value(coverImageUrl))
          );
        }
        await _worldsDao.deletePendingUpload(world.localId);
      } catch (e) {
        // Continue without image update if upload fails
      }
    }

    final body = {
      'name': world.name,
      'description': world.description,
      'template': 'custom',
      'modules': world.modules != null ? jsonDecode(world.modules!) : null,
      'coverImage': coverImageUrl,
      'image': coverImageUrl,
    };
    
    final response = await _apiService.authenticatedRequest(
      '$_endpoint/${world.serverId}',
      method: 'PUT',
      body: body,
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

  Future<void> _syncDeletedWorld(WorldEntity world) async {
    // Ensure pending upload is deleted if it exists (though cascade should handle DB)
    await _worldsDao.deletePendingUpload(world.localId);

    final response = await _apiService.authenticatedRequest(
      '$_endpoint/${world.serverId}',
      method: 'DELETE',
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _worldsDao.deleteWorld(world.localId);
    } else {
      throw Exception('Failed to delete world on API');
    }
  }

  Future<WorldStats> getStats(String serverId) async {
    final response = await _apiService.authenticatedRequest(
      '$_endpoint/$serverId/stats',
    );
    if (response.statusCode == 200) {
      return WorldStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<List<Activity>> getTimeline(String serverId) async {
    final response = await _apiService.authenticatedRequest(
      '$_endpoint/$serverId/timeline',
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load timeline');
    }
  }

  Future<void> fetchAndMergeSingleWorld(String serverId) async {
    try {
      final response = await _apiService.authenticatedRequest(
        '$_endpoint/$serverId',
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch world $serverId: ${response.statusCode}',
        );
      }

      final apiWorld = World.fromJson(jsonDecode(response.body));
      final existing = await _worldsDao.getWorldByServerId(apiWorld.id);

      if (existing == null) return;

      final companion = WorldsCompanion(
        localId: Value(existing.localId),
        serverId: Value(apiWorld.id),
        name: Value(apiWorld.name),
        description: Value(apiWorld.description),
        modules: Value(apiWorld.modules?.toJson()),
        coverImage: Value(apiWorld.coverImage),
        customImage: Value(apiWorld.customImage),
        syncStatus: const Value(SyncStatus.synced),
      );

      await _worldsDao.insertWorld(companion);
    } catch (e) {
      throw Exception('Failed to fetch/merge single world: $e');
    }
  }

  Future<List<SearchResult>> searchInWorld(String worldId, String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _apiService.authenticatedRequest(
        '$_searchEndpoint?q=$query&worldId=$worldId',
      );
      if (response.statusCode != 200) {
        throw Exception('Search failed: ${response.statusCode}');
      }

      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => SearchResult.fromJson(json)).toList();
    
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}
