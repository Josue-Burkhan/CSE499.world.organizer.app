import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/creatures_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/creature_model.dart';

class CreatureSyncService {
  final CreaturesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/creatures';

  CreatureSyncService({
    required CreaturesDao dao,
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

  Future<void> fetchAndMergeCreatures(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch creatures: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> creatureList = body['creatures'];
      final apiCreatures = creatureList.map((j) => Creature.fromJson(j)).toList();

      for (final apiCreature in apiCreatures) {
        final existing = await _dao.getCreatureByServerId(apiCreature.id);
        
        final companion = CreaturesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiCreature.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiCreature.name),
          speciesType: d.Value(apiCreature.speciesType),
          description: d.Value(apiCreature.description),
          habitat: d.Value(apiCreature.habitat),
          weaknesses: d.Value(apiCreature.weaknesses),
          domesticated: d.Value(apiCreature.domesticated),
          customNotes: d.Value(apiCreature.customNotes),
          tagColor: d.Value(apiCreature.tagColor),
          images: d.Value(apiCreature.images),
          rawCharacters: d.Value(apiCreature.rawCharacters),
          rawAbilities: d.Value(apiCreature.rawAbilities),
          rawFactions: d.Value(apiCreature.rawFactions),
          rawEvents: d.Value(apiCreature.rawEvents),
          rawStories: d.Value(apiCreature.rawStories),
          rawLocations: d.Value(apiCreature.rawLocations),
          rawPowerSystems: d.Value(apiCreature.rawPowerSystems),
          rawReligions: d.Value(apiCreature.rawReligions),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertCreature(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge creatures: $e');
    }
  }

  Future<void> fetchAndMergeSingleCreature(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch creature $serverId: ${response.statusCode}');
      }

      final apiCreature = Creature.fromJson(jsonDecode(response.body));
      if (apiCreature.worldId == null) {
        throw Exception('Creature from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiCreature.worldId!);
      if (world == null) {
        throw Exception('Creature\'s world is not synced locally');
      }

      final existing = await _dao.getCreatureByServerId(apiCreature.id);
      
      final companion = CreaturesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiCreature.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiCreature.name),
        speciesType: d.Value(apiCreature.speciesType),
        description: d.Value(apiCreature.description),
        habitat: d.Value(apiCreature.habitat),
        weaknesses: d.Value(apiCreature.weaknesses),
        domesticated: d.Value(apiCreature.domesticated),
        customNotes: d.Value(apiCreature.customNotes),
        tagColor: d.Value(apiCreature.tagColor),
        images: d.Value(apiCreature.images),
        rawCharacters: d.Value(apiCreature.rawCharacters),
        rawAbilities: d.Value(apiCreature.rawAbilities),
        rawFactions: d.Value(apiCreature.rawFactions),
        rawEvents: d.Value(apiCreature.rawEvents),
        rawStories: d.Value(apiCreature.rawStories),
        rawLocations: d.Value(apiCreature.rawLocations),
        rawPowerSystems: d.Value(apiCreature.rawPowerSystems),
        rawReligions: d.Value(apiCreature.rawReligions),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertCreature(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single creature: $e');
    }
  }

  Future<void> syncDirtyCreatures() async {
    final dirtyCreatures = await _dao.getDirtyCreatures();
    if (dirtyCreatures.isEmpty) return;
    for (final creature in dirtyCreatures) {
      try {
        if (creature.syncStatus == SyncStatus.created) {
          await _syncCreatedCreature(creature);
        } else if (creature.syncStatus == SyncStatus.edited) {
          await _syncEditedCreature(creature);
        } else if (creature.syncStatus == SyncStatus.deleted) {
          await _syncDeletedCreature(creature);
        }
      } catch (e) {
        print('Error syncing creature ${creature.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedCreature(CreatureEntity creature) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(creature.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync creature for unsynced world');
    }

    final body = _createBodyFromEntity(creature, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiCreature = Creature.fromJson(jsonDecode(response.body));
      final companion = creature.toCompanion(true).copyWith(
        serverId: d.Value(apiCreature.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateCreature(companion);
    } else {
      throw Exception('Failed to create creature: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedCreature(CreatureEntity creature) async {
    if (creature.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(creature.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(creature, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${creature.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = creature.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateCreature(companion);
    } else {
      throw Exception('Failed to update creature: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedCreature(CreatureEntity creature) async {
    if (creature.serverId == null) {
      await _dao.deleteCreature(creature.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${creature.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteCreature(creature.localId);
    } else {
      throw Exception('Failed to delete creature: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(CreatureEntity creature, String worldServerId) {
    return {
      'world': worldServerId,
      'name': creature.name,
      'speciesType': creature.speciesType,
      'description': creature.description,
      'habitat': creature.habitat,
      'weaknesses': creature.weaknesses,
      'domesticated': creature.domesticated,
      'customNotes': creature.customNotes,
      'tagColor': creature.tagColor,
      'images': creature.images,
      
      'rawCharacters': creature.rawCharacters,
      'rawAbilities': creature.rawAbilities,
      'rawFactions': creature.rawFactions,
      'rawEvents': creature.rawEvents,
      'rawStories': creature.rawStories,
      'rawLocations': creature.rawLocations,
      'rawPowerSystems': creature.rawPowerSystems,
      'rawReligions': creature.rawReligions,
    };
  }
}