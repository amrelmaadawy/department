import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsModel?> getCachedGeneralSettings();
  Future<void> cacheGeneralSettings(SettingsModel settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _settingsKey = 'CACHED_GENERAL_SETTINGS';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SettingsModel?> getCachedGeneralSettings() async {
    final jsonString = sharedPreferences.getString(_settingsKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return SettingsModel.fromJson(jsonMap);
      } catch (e) {
        return null; // Invalid cache
      }
    }
    return null;
  }

  @override
  Future<void> cacheGeneralSettings(SettingsModel settings) async {
    final jsonString = json.encode(settings.toJson());
    await sharedPreferences.setString(_settingsKey, jsonString);
  }
}
