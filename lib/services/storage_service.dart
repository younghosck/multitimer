import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_model.dart';

/// Handles data persistence using SharedPreferences
class StorageService {
  static const String _timersKey = 'meditation_timers';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Saves list of timers to persistent storage
  Future<void> saveTimers(List<MeditationTimer> timers) async {
    final jsonList = timers.map((timer) => timer.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_timersKey, jsonString);
  }

  /// Loads saved timers from storage
  List<MeditationTimer> loadTimers() {
    final jsonString = _prefs.getString(_timersKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => MeditationTimer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      // This prevents app crash on corrupted data
      return [];
    }
  }

  /// Clears all saved timers (useful for testing/reset)
  Future<void> clearTimers() async {
    await _prefs.remove(_timersKey);
  }
}
