import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RoomDesignCacheService {
  final SharedPreferences sharedPreferences;

  RoomDesignCacheService({required this.sharedPreferences});

  static const String _cachePrefix = 'room_design_progress_';
  static const String _submittedPrefix = 'submitted_ai_design_';

  String _getKey(int roomId) => '$_cachePrefix$roomId';
  String _getSubmittedKey(int roomId) => '$_submittedPrefix$roomId';

  Future<void> saveSubmittedAiDesignMaterials(int roomId, List<int> materialIds) async {
    final key = _getSubmittedKey(roomId);
    await sharedPreferences.setString(key, json.encode(materialIds));
  }

  List<int>? getSubmittedAiDesignMaterials(int roomId) {
    final key = _getSubmittedKey(roomId);
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        return list.map((e) => (e as num).toInt()).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveRoomDesignProgress({
    required int roomId,
    required List<int> selectedMaterialIds,
    required double selectedMaterialsCost,
    required String? selectedStyle,
    required String notes,
    required bool isCompleted,
  }) async {
    final key = _getKey(roomId);
    final data = {
      'selectedMaterialIds': selectedMaterialIds,
      'selectedMaterialsCost': selectedMaterialsCost,
      'selectedStyle': selectedStyle,
      'notes': notes,
      'isCompleted': isCompleted,
    };
    await sharedPreferences.setString(key, json.encode(data));
  }

  Map<String, dynamic>? getRoomDesignProgress(int roomId) {
    final key = _getKey(roomId);
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      try {
        return json.decode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearRoomDesignProgress(int roomId) async {
    final key = _getKey(roomId);
    await sharedPreferences.remove(key);
  }

  Future<void> clearAllRoomDesignProgress() async {
    final keys = sharedPreferences.getKeys();
    for (final k in keys) {
      if (k.startsWith(_cachePrefix) || k.startsWith(_submittedPrefix)) {
        await sharedPreferences.remove(k);
      }
    }
  }
}
