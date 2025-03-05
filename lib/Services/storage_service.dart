import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/settings.dart';

class StorageService {
  static const String _settingsKey = 'settings';

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);

    if (settingsJson == null) {
      return Settings();
    }

    try {
      return Settings.fromJson(jsonDecode(settingsJson));
    } catch (e) {
      return Settings();
    }
  }
}
