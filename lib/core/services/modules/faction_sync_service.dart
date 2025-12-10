import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/faction_model.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/factions_dao.dart';

class FactionSyncService {
  final FactionsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/factions';

  FactionSyncService({
    required FactionsDao dao,
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

  Future<void> fetchAndMergeFactions(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch factions: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> factionList = body['factions'];
      final apiFactions = factionList.map((j) => Faction.fromJson(j)).toList();

      for (final apiFaction in apiFactions) {
        final existing = await _dao.getFactionByServerId(apiFaction.id);
        
        final companion = FactionsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiFaction.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiFaction.name),
          description: d.Value(apiFaction.description),
          type: d.Value(apiFaction.type),
          symbol: d.Value(apiFaction.symbol),
          economicSystem: d.Value(apiFaction.economicSystem),
          technology: d.Value(apiFaction.technology),
          goals: d.Value(apiFaction.goals),
          history: d.Value(apiFaction.history),
          customNotes: d.Value(apiFaction.customNotes),
          tagColor: d.Value(apiFaction.tagColor),

          alliesJson: const d.Value.absent(),
          enemiesJson: const d.Value.absent(),

          images: d.Value(apiFaction.images),
          rawCharacters: d.Value(apiFaction.rawCharacters),
          rawLocations: d.Value(apiFaction.rawLocations),
          rawHeadquarters: d.Value(apiFaction.rawHeadquarters),
          rawTerritory: d.Value(apiFaction.rawTerritory),
          rawEvents: d.Value(apiFaction.rawEvents),
          rawItems: d.Value(apiFaction.rawItems),
          rawStories: d.Value(apiFaction.rawStories),
          rawReligions: d.Value(apiFaction.rawReligions),
          rawTechnologies: d.Value(apiFaction.rawTechnologies),
          rawLanguages: d.Value(apiFaction.rawLanguages),
          rawPowerSystems: d.Value(apiFaction.rawPowerSystems),

          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertFaction(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge factions: $e');
    }
  }

  Future<void> fetchAndMergeSingleFaction(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch faction $serverId: ${response.statusCode}');
      }

      final apiFaction = Faction.fromJson(jsonDecode(response.body));
      if (apiFaction.worldId == null) {
        throw Exception('Faction from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiFaction.worldId!);
      if (world == null) {
        throw Exception('Faction\'s world is not synced locally');
      }

      final existing = await _dao.getFactionByServerId(apiFaction.id);
      
      final companion = FactionsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiFaction.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiFaction.name),
        description: d.Value(apiFaction.description),
        type: d.Value(apiFaction.type),
        symbol: d.Value(apiFaction.symbol),
        economicSystem: d.Value(apiFaction.economicSystem),
        technology: d.Value(apiFaction.technology),
        goals: d.Value(apiFaction.goals),
        history: d.Value(apiFaction.history),
        customNotes: d.Value(apiFaction.customNotes),
        tagColor: d.Value(apiFaction.tagColor),

        alliesJson: d.Value(jsonEncode(apiFaction.allies.map((e) => e.toJson()).toList())),
        enemiesJson: d.Value(jsonEncode(apiFaction.enemies.map((e) => e.toJson()).toList())),
        
        images: d.Value(apiFaction.images),
        rawCharacters: d.Value(apiFaction.rawCharacters),
        rawLocations: d.Value(apiFaction.rawLocations),
        rawHeadquarters: d.Value(apiFaction.rawHeadquarters),
        rawTerritory: d.Value(apiFaction.rawTerritory),
        rawEvents: d.Value(apiFaction.rawEvents),
        rawItems: d.Value(apiFaction.rawItems),
        rawStories: d.Value(apiFaction.rawStories),
        rawReligions: d.Value(apiFaction.rawReligions),
        rawTechnologies: d.Value(apiFaction.rawTechnologies),
        rawLanguages: d.Value(apiFaction.rawLanguages),
        rawPowerSystems: d.Value(apiFaction.rawPowerSystems),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertFaction(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single faction: $e');
    }
  }

  Future<void> syncDirtyFactions() async {
    final dirtyFactions = await _dao.getDirtyFactions();
    if (dirtyFactions.isEmpty) return;
    for (final faction in dirtyFactions) {
      try {
        if (faction.syncStatus == SyncStatus.created) {
          await _syncCreatedFaction(faction);
        } else if (faction.syncStatus == SyncStatus.edited) {
          await _syncEditedFaction(faction);
        } else if (faction.syncStatus == SyncStatus.deleted) {
          await _syncDeletedFaction(faction);
        }
      } catch (e) {
        print('Error syncing faction ${faction.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedFaction(FactionEntity faction) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(faction.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync faction for unsynced world');
    }

    final body = _createBodyFromEntity(faction, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiFaction = Faction.fromJson(jsonDecode(response.body));
      final companion = faction.toCompanion(true).copyWith(
        serverId: d.Value(apiFaction.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateFaction(companion);
    } else {
      throw Exception('Failed to create faction: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedFaction(FactionEntity faction) async {
    if (faction.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(faction.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(faction, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${faction.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = faction.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateFaction(companion);
    } else {
      throw Exception('Failed to update faction: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedFaction(FactionEntity faction) async {
    if (faction.serverId == null) {
      await _dao.deleteFaction(faction.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${faction.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteFaction(faction.localId);
    } else {
      throw Exception('Failed to delete faction: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(FactionEntity faction, String worldServerId) {
    return {
      'world': worldServerId,
      'name': faction.name,
      'description': faction.description,
      'type': faction.type,
      'symbol': faction.symbol,
      'economicSystem': faction.economicSystem,
      'technology': faction.technology,
      'goals': faction.goals,
      'history': faction.history,
      'customNotes': faction.customNotes,
      'tagColor': faction.tagColor,
      'images': faction.images,
      
      'allies': faction.alliesJson != null ? jsonDecode(faction.alliesJson!) : [],
      'enemies': faction.enemiesJson != null ? jsonDecode(faction.enemiesJson!) : [],
      
      'rawCharacters': faction.rawCharacters.map((e) => e.name).toList(),
      'rawLocations': faction.rawLocations.map((e) => e.name).toList(),
      'rawHeadquarters': faction.rawHeadquarters.map((e) => e.name).toList(),
      'rawTerritory': faction.rawTerritory.map((e) => e.name).toList(),
      'rawEvents': faction.rawEvents.map((e) => e.name).toList(),
      'rawItems': faction.rawItems.map((e) => e.name).toList(),
      'rawStories': faction.rawStories.map((e) => e.name).toList(),
      'rawReligions': faction.rawReligions.map((e) => e.name).toList(),
      'rawTechnologies': faction.rawTechnologies.map((e) => e.name).toList(),
      'rawLanguages': faction.rawLanguages.map((e) => e.name).toList(),
      'rawPowerSystems': faction.rawPowerSystems.map((e) => e.name).toList(),
    };
  }


}