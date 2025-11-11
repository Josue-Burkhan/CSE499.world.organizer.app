import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/character_model.dart';

class CharacterSyncService {
  final CharactersDao _dao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/characters';

  CharacterSyncService({
    required CharactersDao dao,
    required FlutterSecureStorage storage,
  })  : _dao = dao,
        _storage = storage;

  Future<String?> _getToken() => _storage.read(key: 'token');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchAndMergeCharacters(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch characters: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> charList = body['characters'];
      final apiChars = charList.map((j) => Character.fromJson(j)).toList();

      for (final apiChar in apiChars) {
        final existing = await _dao.getCharacterByServerId(apiChar.id);
        
        final companion = CharactersCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiChar.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiChar.name),
          age: d.Value(apiChar.age),
          gender: d.Value(apiChar.gender),
          nickname: d.Value(apiChar.nickname),
          customNotes: d.Value(apiChar.customNotes),
          tagColor: d.Value(apiChar.tagColor),
          appearanceJson: apiChar.appearance != null
              ? d.Value(jsonEncode(apiChar.appearance!.toJson()))
              : const d.Value(null),
          personalityJson: apiChar.personality != null
              ? d.Value(jsonEncode(apiChar.personality!.toJson()))
              : const d.Value(null),
          historyJson: apiChar.history != null
              ? d.Value(jsonEncode(apiChar.history!.toJson()))
              : const d.Value(null),
          images: d.Value(apiChar.images),
          rawFamily: d.Value(apiChar.rawFamily),
          rawFriends: d.Value(apiChar.rawFriends),
          rawEnemies: d.Value(apiChar.rawEnemies),
          rawRomance: d.Value(apiChar.rawRomance),
          rawAbilities: d.Value(apiChar.rawAbilities),
          rawItems: d.Value(apiChar.rawItems),
          rawLanguages: d.Value(apiChar.rawLanguages),
          rawRaces: d.Value(apiChar.rawRaces),
          rawFactions: d.Value(apiChar.rawFactions),
          rawLocations: d.Value(apiChar.rawLocations),
          rawPowerSystems: d.Value(apiChar.rawPowerSystems),
          rawReligions: d.Value(apiChar.rawReligions),
          rawCreatures: d.Value(apiChar.rawCreatures),
          rawEconomies: d.Value(apiChar.rawEconomies),
          rawStories: d.Value(apiChar.rawStories),
          rawTechnologies: d.Value(apiChar.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertCharacter(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge characters: $e');
    }
  }

  Future<void> syncDirtyCharacters() async {
    final dirtyChars = await _dao.getDirtyCharacters();
    if (dirtyChars.isEmpty) return;
    
  }
}