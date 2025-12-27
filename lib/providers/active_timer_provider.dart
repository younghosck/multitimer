import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_provider.dart';
import 'timer_list_provider.dart';

/// Enum for timer playback modes
enum PlaybackMode {
  none, // No playback active
  individual, // Single timer playing
  playAll, // All timers playing simultaneously
}

/// State for active timer tracking - now supports multiple timers
class ActiveTimerState {
  // Map of timer ID to remaining time (for simultaneously running timers)
  final Map<String, Duration> runningTimers;
  final PlaybackMode playbackMode;
  final DateTime? pausedAt;

  const ActiveTimerState({
    this.runningTimers = const {},
    this.playbackMode = PlaybackMode.none,
    this.pausedAt,
  });

  bool get isRunning => runningTimers.isNotEmpty;

  // Get current timer ID (for individual mode)
  String? get currentTimerId =>
      playbackMode == PlaybackMode.individual && runningTimers.isNotEmpty
          ? runningTimers.keys.first
          : null;

  // Get remaining time for a specific timer
  Duration? getRemainingTime(String timerId) => runningTimers[timerId];

  ActiveTimerState copyWith({
    Map<String, Duration>? runningTimers,
    PlaybackMode? playbackMode,
    DateTime? pausedAt,
    bool clearPausedAt = false,
  }) {
    return ActiveTimerState(
      runningTimers: runningTimers ?? this.runningTimers,
      playbackMode: playbackMode ?? this.playbackMode,
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
    );
  }
}

/// StateNotifier for managing active timers - supports multiple simultaneous timers
class ActiveTimerNotifier extends StateNotifier<ActiveTimerState>
    with WidgetsBindingObserver {
  // Map of timer ID to Timer object
  final Map<String, Timer> _countdownTimers = {};
  final Ref _ref;

  ActiveTimerNotifier(this._ref) : super(const ActiveTimerState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _cancelAllTimers();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _cancelAllTimers() {
    for (var timer in _countdownTimers.values) {
      timer.cancel();
    }
    _countdownTimers.clear();
  }

  /// Handle app lifecycle changes for background execution
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      // App going to background
      if (state.isRunning) {
        state = state.copyWith(pausedAt: DateTime.now());
      }
    } else if (lifecycleState == AppLifecycleState.resumed) {
      // App returning to foreground
      if (state.pausedAt != null && state.isRunning) {
        final elapsed = DateTime.now().difference(state.pausedAt!);
        final updatedTimers = <String, Duration>{};

        // Update all running timers
        for (var entry in state.runningTimers.entries) {
          final newTime = entry.value - elapsed;
          if (newTime.isNegative || newTime.inSeconds == 0) {
            _onTimerComplete(entry.key);
          } else {
            updatedTimers[entry.key] = newTime;
          }
        }

        state = state.copyWith(
          runningTimers: updatedTimers,
          clearPausedAt: true,
        );
      }
    }
  }

  /// Starts a single timer (individual mode)
  void startTimer(String timerId, Duration duration) {
    debugPrint('▶️ Starting individual timer: $timerId');
    _cancelAllTimers();

    state = ActiveTimerState(
      runningTimers: {timerId: duration},
      playbackMode: PlaybackMode.individual,
    );

    _startCountdown(timerId, duration);
  }

  /// Starts ALL timers simultaneously (Play All mode)
  void startAllTimers(List<String> timerIds) {
    debugPrint('====================================');
    debugPrint('🎬 Starting ALL timers simultaneously');
    debugPrint('   Timer count: ${timerIds.length}');

    if (timerIds.isEmpty) {
      debugPrint('❌ No timers to start');
      return;
    }

    _cancelAllTimers();

    final timerList = _ref.read(timerListProvider);
    final runningTimers = <String, Duration>{};

    // Start all timers at once
    for (var timerId in timerIds) {
      try {
        final timer = timerList.firstWhere((t) => t.id == timerId);
        runningTimers[timerId] = timer.duration;
        debugPrint('   ✅ Added timer: ${timer.name} (${timer.duration})');

        // Start countdown for this timer
        _startCountdown(timerId, timer.duration);
      } catch (e) {
        debugPrint('   ❌ Timer not found: $timerId');
      }
    }

    state = ActiveTimerState(
      runningTimers: runningTimers,
      playbackMode: PlaybackMode.playAll,
    );

    debugPrint('🚀 All ${runningTimers.length} timers started!');
    debugPrint('====================================');
  }

  /// Pauses all running timers
  void pauseAllTimers() {
    debugPrint('⏸️ Pausing all timers');
    _cancelAllTimers();
    state = state.copyWith(pausedAt: DateTime.now());
  }

  /// Resumes all paused timers
  void resumeAllTimers() {
    debugPrint('▶️ Resuming all timers');
    if (state.runningTimers.isEmpty) return;

    final timerList = _ref.read(timerListProvider);

    for (var entry in state.runningTimers.entries) {
      try {
        final timer = timerList.firstWhere((t) => t.id == entry.key);
        _startCountdown(entry.key, entry.value);
        debugPrint('   Resumed: ${timer.name}');
      } catch (e) {
        debugPrint('   ❌ Could not resume timer: ${entry.key}');
      }
    }

    state = state.copyWith(clearPausedAt: true);
  }

  /// Stops all timers and resets state
  void stopAllTimers() {
    debugPrint('🛑 Stopping all timers');
    _cancelAllTimers();
    state = const ActiveTimerState();
  }

  /// Internal countdown logic for a single timer
  void _startCountdown(String timerId, Duration initialDuration) {
    // Cancel existing timer for this ID if any
    _countdownTimers[timerId]?.cancel();

    debugPrint('🔄 Starting countdown: $timerId (${initialDuration})');

    _countdownTimers[timerId] = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final currentTime = state.runningTimers[timerId];
        if (currentTime == null) {
          timer.cancel();
          _countdownTimers.remove(timerId);
          return;
        }

        final newTime = currentTime - const Duration(seconds: 1);

        if (newTime.isNegative || newTime.inSeconds == 0) {
          debugPrint('✅ Timer $timerId COMPLETED!');
          timer.cancel();
          _countdownTimers.remove(timerId);
          _onTimerComplete(timerId);
        } else {
          // Update this timer's remaining time
          final updatedTimers = Map<String, Duration>.from(state.runningTimers);
          updatedTimers[timerId] = newTime;
          state = state.copyWith(runningTimers: updatedTimers);
        }
      },
    );
  }

  /// Handles timer completion
  void _onTimerComplete(String timerId) {
    debugPrint('🎯 Timer completed: $timerId');

    // Play completion sound
    final timerList = _ref.read(timerListProvider);
    try {
      final completedTimer = timerList.firstWhere((t) => t.id == timerId);
      debugPrint('🔔 Playing sound: ${completedTimer.soundFileName}');
      _ref.read(audioServiceProvider).playSound(completedTimer.soundFileName);
    } catch (e) {
      debugPrint('⚠️ Could not find timer for sound: $e');
    }

    // Remove this timer from running timers
    final updatedTimers = Map<String, Duration>.from(state.runningTimers);
    updatedTimers.remove(timerId);

    if (updatedTimers.isEmpty) {
      // All timers completed
      debugPrint('🏁 All timers completed!');
      state = const ActiveTimerState();
    } else {
      // Some timers still running
      debugPrint('   ${updatedTimers.length} timer(s) still running');
      state = state.copyWith(runningTimers: updatedTimers);
    }
  }
}

/// Provider for active timer state
final activeTimerProvider =
    StateNotifierProvider<ActiveTimerNotifier, ActiveTimerState>((ref) {
  return ActiveTimerNotifier(ref);
});
