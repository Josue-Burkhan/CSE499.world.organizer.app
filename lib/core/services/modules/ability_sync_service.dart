import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/abilities_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/ability_model.dart';

class AbilitySyncService {
  final AbilitiesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/abilities';

  AbilitySyncService({
    required AbilitiesDao dao,
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

  Future<void> fetchAndMergeAbilities(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch abilities: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> abilityList = body['abilities'];
      final apiAbilities = abilityList.map((j) => Ability.fromJson(j)).toList();

      for (final apiAbility in apiAbilities) {
        final existing = await _dao.getAbilityByServerId(apiAbility.id);
        
        final companion = AbilitiesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiAbility.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiAbility.name),
          description: d.Value(apiAbility.description),
          type: d.Value(apiAbility.type),
          element: d.Value(apiAbility.element),
          cooldown: d.Value(apiAbility.cooldown),
          cost: d.Value(apiAbility.cost),
          level: d.Value(apiAbility.level),
          requirements: d.Value(apiAbility.requirements),
          effect: d.Value(apiAbility.effect),
          customNotes: d.Value(apiAbility.customNotes),
          tagColor: d.Value(apiAbility.tagColor),
          images: d.Value(apiAbility.images),
          rawCharacters: d.Value(apiAbility.rawCharacters),
          rawPowerSystems: d.Value(apiAbility.rawPowerSystems),
          rawStories: d.Value(apiAbility.rawStories),
          rawEvents: d.Value(apiAbility.rawEvents),
          rawItems: d.Value(apiAbility.rawItems),
          rawReligions: d.Value(apiAbility.rawReligions),
          rawTechnologies: d.Value(apiAbility.rawTechnologies),
          rawCreatures: d.Value(apiAbility.rawCreatures),
          rawRaces: d.Value(apiAbility.rawRaces),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertAbility(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge abilities: $e');
    }
  }

  Future<void> fetchAndMergeSingleAbility(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch ability $serverId: ${response.statusCode}');
      }

      final apiAbility = Ability.fromJson(jsonDecode(response.body));
      if (apiAbility.worldId == null) {
        throw Exception('Ability from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiAbility.worldId!);
      if (world == null) {
        throw Exception('Ability\'s world is not synced locally');
      }

      final existing = await _dao.getAbilityByServerId(apiAbility.id);
      
      final companion = AbilitiesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiAbility.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiAbility.name),
        description: d.Value(apiAbility.description),
        type: d.Value(apiAbility.type),
        element: d.Value(apiAbility.element),
        cooldown: d.Value(apiAbility.cooldown),
        cost: d.Value(apiAbility.cost),
        level: d.Value(apiAbility.level),
        requirements: d.Value(apiAbility.requirements),
        effect: d.Value(apiAbility.effect),
        customNotes: d.Value(apiAbility.customNotes),
        tagColor: d.Value(apiAbility.tagColor),
        images: d.Value(apiAbility.images),
        rawCharacters: d.Value(apiAbility.rawCharacters),
        rawPowerSystems: d.Value(apiAbility.rawPowerSystems),
        rawStories: d.Value(apiAbility.rawStories),
        rawEvents: d.Value(apiAbility.rawEvents),
        rawItems: d.Value(apiAbility.rawItems),
        rawReligions: d.Value(apiAbility.rawReligions),
        rawTechnologies: d.Value(apiAbility.rawTechnologies),
        rawCreatures: d.Value(apiAbility.rawCreatures),
        rawRaces: d.Value(apiAbility.rawRaces),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertAbility(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single ability: $e');
    }
  }

  Future<void> syncDirtyAbilities() async {
    final dirtyAbilities = await _dao.getDirtyAbilities();
    if (dirtyAbilities.isEmpty) return;
    
  }
}