import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsState {
  final ThemeMode themeMode;
  final String language;
  final int autoSyncInterval; // 0 = off
  final bool syncOnWifiOnly;
  final DateTime? lastSyncTime;

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.language = 'en',
    this.autoSyncInterval = 0,
    this.syncOnWifiOnly = false,
    this.lastSyncTime,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? language,
    int? autoSyncInterval,
    bool? syncOnWifiOnly,
    DateTime? lastSyncTime,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      autoSyncInterval: autoSyncInterval ?? this.autoSyncInterval,
      syncOnWifiOnly: syncOnWifiOnly ?? this.syncOnWifiOnly,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0; // 0: System, 1: Light, 2: Dark
    final language = prefs.getString('language') ?? 'en';
    final autoSync = prefs.getInt('autoSync') ?? 0;
    final wifiOnly = prefs.getBool('wifiOnly') ?? false;
    final lastSyncMillis = prefs.getInt('lastSyncTime');

    state = SettingsState(
      themeMode: _indexToThemeMode(themeIndex),
      language: language,
      autoSyncInterval: autoSync,
      syncOnWifiOnly: wifiOnly,
      lastSyncTime: lastSyncMillis != null ? DateTime.fromMillisecondsSinceEpoch(lastSyncMillis) : null,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeModeToIndex(mode));
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<void> setAutoSyncInterval(int interval) async {
    state = state.copyWith(autoSyncInterval: interval);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('autoSync', interval);
  }

  Future<void> setSyncOnWifiOnly(bool enabled) async {
    state = state.copyWith(syncOnWifiOnly: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wifiOnly', enabled);
  }

  Future<void> updateLastSyncTime() async {
    final now = DateTime.now();
    state = state.copyWith(lastSyncTime: now);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSyncTime', now.millisecondsSinceEpoch);
  }

  int _themeModeToIndex(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return 0;
      case ThemeMode.light: return 1;
      case ThemeMode.dark: return 2;
    }
  }

  ThemeMode _indexToThemeMode(int index) {
    switch (index) {
      case 1: return ThemeMode.light;
      case 2: return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}
