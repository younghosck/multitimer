import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/timer_model.dart';
import '../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return StorageService(prefs);
});

/// StateNotifier for managing the list of meditation timers
class TimerListNotifier extends StateNotifier<List<MeditationTimer>> {
  final StorageService _storageService;
  final Uuid _uuid = const Uuid();

  TimerListNotifier(this._storageService) : super([]) {
    _loadTimers();
  }

  /// Loads timers from storage on initialization
  void _loadTimers() {
    state = _storageService.loadTimers();
  }

  /// Adds a new timer to the list
  Future<void> addTimer(MeditationTimer timer) async {
    state = [...state, timer];
    await _storageService.saveTimers(state);
  }

  /// Updates an existing timer
  Future<void> updateTimer(String id, MeditationTimer updatedTimer) async {
    state = [
      for (final timer in state)
        if (timer.id == id) updatedTimer else timer,
    ];
    await _storageService.saveTimers(state);
  }

  /// Deletes a timer by ID
  Future<void> deleteTimer(String id) async {
    state = state.where((timer) => timer.id != id).toList();
    await _storageService.saveTimers(state);
  }

  /// Creates a new timer with generated ID
  String createNewTimerId() {
    return _uuid.v4();
  }

  /// Finds a timer by ID
  MeditationTimer? findTimerById(String id) {
    try {
      return state.firstWhere((timer) => timer.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Provider for the timer list
final timerListProvider =
    StateNotifierProvider<TimerListNotifier, List<MeditationTimer>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return TimerListNotifier(storageService);
});
