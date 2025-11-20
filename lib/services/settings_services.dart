import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyUsername = 'username';
  static const _keyEnableNotifications = 'enableNotifications';
  static const _keyDefaultLanguage = 'defaultLanguage';

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<void> setUsername(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, value);
  }

  Future<bool> getEnableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEnableNotifications) ?? false;
  }

  Future<void> setEnableNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnableNotifications, value);
  }

  Future<String?> getDefaultLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDefaultLanguage) ?? 'en';
  }

  Future<void> setDefaultLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDefaultLanguage, value);
  }
}