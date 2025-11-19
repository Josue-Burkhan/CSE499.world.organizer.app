import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/core/services/api_service.dart';

class ProfileRepository {
  final AppDatabase db;
  final FlutterSecureStorage storage;
  
  final ApiService _apiService = ApiService();

  ProfileRepository({required this.db, required this.storage});

  Future<String?> _getSessionType() => storage.read(key: 'session_type');

  Stream<UserProfileEntity?> watchUserProfile() {
    return db.select(db.userProfile).watchSingleOrNull();
  }

  Future<void> fetchAndSyncProfile() async {
    try {
      final sessionType = await _getSessionType();
      
      if (sessionType == 'offline') return;

      final response = await _apiService.authenticatedRequest('/api/account/me');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['accountData'];
        await _saveProfileToDb(data);
      } else {
        print('Sync failed: ${response.statusCode}');
      }
    } catch (e) {
       print('Sync error: $e');
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

    await db.into(db.userProfile).insert(profile, mode: d.InsertMode.replace);
  }

  Future<void> updateUserProfile(String name, String lang) async {
    try {
      final response = await _apiService.authenticatedRequest(
        '/api/account/me',
        method: 'PUT',
        body: {'name': name, 'lang': lang},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accountData = data['accountData'];
        
        await _saveProfileToDb(accountData);
        
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
    await db.delete(db.userProfile).go(); 
  }
}