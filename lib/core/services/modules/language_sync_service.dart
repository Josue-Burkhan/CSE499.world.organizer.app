import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/languages_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/language_model.dart';

class LanguageSyncService {
  final LanguagesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/languages';

  LanguageSyncService({
    required LanguagesDao dao,
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

  Future<void> fetchAndMergeLanguages(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch languages: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> languageList = body['languages'];
      final apiLanguages = languageList.map((j) => Language.fromJson(j)).toList();

      for (final apiLanguage in apiLanguages) {
        final existing = await _dao.getLanguageByServerId(apiLanguage.id);
        
        final companion = LanguagesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiLanguage.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiLanguage.name),
          alphabet: d.Value(apiLanguage.alphabet),
          pronunciationRules: d.Value(apiLanguage.pronunciationRules),
          grammarNotes: d.Value(apiLanguage.grammarNotes),
          isSacred: d.Value(apiLanguage.isSacred),
          isExtinct: d.Value(apiLanguage.isExtinct),
          customNotes: d.Value(apiLanguage.customNotes),
          tagColor: d.Value(apiLanguage.tagColor),
          images: d.Value(apiLanguage.images),
          rawRaces: d.Value(apiLanguage.rawRaces),
          rawFactions: d.Value(apiLanguage.rawFactions),
          rawCharacters: d.Value(apiLanguage.rawCharacters),
          rawLocations: d.Value(apiLanguage.rawLocations),
          rawStories: d.Value(apiLanguage.rawStories),
          rawReligions: d.Value(apiLanguage.rawReligions),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertLanguage(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge languages: $e');
    }
  }

  Future<void> fetchAndMergeSingleLanguage(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch language $serverId: ${response.statusCode}');
      }

      final apiLanguage = Language.fromJson(jsonDecode(response.body));
      if (apiLanguage.worldId == null) {
        throw Exception('Language from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiLanguage.worldId!);
      if (world == null) {
        throw Exception('Language\'s world is not synced locally');
      }

      final existing = await _dao.getLanguageByServerId(apiLanguage.id);
      
      final companion = LanguagesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiLanguage.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiLanguage.name),
        alphabet: d.Value(apiLanguage.alphabet),
        pronunciationRules: d.Value(apiLanguage.pronunciationRules),
        grammarNotes: d.Value(apiLanguage.grammarNotes),
        isSacred: d.Value(apiLanguage.isSacred),
        isExtinct: d.Value(apiLanguage.isExtinct),
        customNotes: d.Value(apiLanguage.customNotes),
        tagColor: d.Value(apiLanguage.tagColor),
        images: d.Value(apiLanguage.images),
        rawRaces: d.Value(apiLanguage.rawRaces),
        rawFactions: d.Value(apiLanguage.rawFactions),
        rawCharacters: d.Value(apiLanguage.rawCharacters),
        rawLocations: d.Value(apiLanguage.rawLocations),
        rawStories: d.Value(apiLanguage.rawStories),
        rawReligions: d.Value(apiLanguage.rawReligions),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertLanguage(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single language: $e');
    }
  }

  Future<void> syncDirtyLanguages() async {
    final dirtyLanguages = await _dao.getDirtyLanguages();
    if (dirtyLanguages.isEmpty) return;
    
  }
}