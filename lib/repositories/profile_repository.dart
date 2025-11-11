import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as d;

class ProfileRepository {
  final AppDatabase db;
  final FlutterSecureStorage storage;
  final String _backendUrl = 'https://login.wild-fantasy.com';

  ProfileRepository({required this.db, required this.storage});

  Future<String?> _getToken() => storage.read(key: 'token');
  Future<String?> _getSessionType() => storage.read(key: 'session_type');

  Stream<UserProfileEntity?> watchUserProfile() {
    return db.select(db.userProfile).watchSingleOrNull();
  }

  Future<void> fetchAndSyncProfile() async {
    final token = await _getToken();
    if (token == null) {
      final sessionType = await _getSessionType();
      if (sessionType != 'offline') {
        throw Exception('Not authenticated');
      }
      return;
    }

    try {
      final Uri meUrl = Uri.parse('$_backendUrl/api/account/me');
      final response = await http.get(
        meUrl,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['accountData'];
        await _saveProfileToDb(data);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> _saveProfileToDb(Map<String, dynamic> data) async {
    final profile = UserProfileCompanion(
      serverId: d.Value(data['userId']),
      firstName: d.Value(data['account_firstname'] ?? 'User'),
      email: d.Value(data['email']),
      pictureUrl: d.Value(data['picture']),
      lang: d.Value(data['lang'] ?? 'en'),
      plan: d.Value(data['account_plan']),
      planExpiresAt: data['account_plan_expires_at'] != null
          ? d.Value(DateTime.parse(data['account_plan_expires_at']))
          : const d.Value(null),
      autoRenew: d.Value(data['account_auto_renew'] ?? false),
    );

    await db.into(db.userProfile).insert(
          profile, 
          mode: d.InsertMode.replace
        );
  }

  Future<void> updateUserProfile(String name, String lang) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final Uri meUrl = Uri.parse('$_backendUrl/api/account/me');
    final response = await http.put(
      meUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'lang': lang}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['accountData'];
      await _saveProfileToDb(data);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    await db.deleteAllData();
  }
}