import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_provider.dart';
import 'timer_list_provider.dart';

/// Enum for timer playback modes
enum PlaybackMode {
  none, // No playback active
  individual, // Single timer playing
  sequential, // "Play All" sequential mode
}

/// State for active timer tracking
class ActiveTimerState {
  final String? currentTimerId;
  final Duration? remainingTime;
  final bool isRunning;
  final PlaybackMode playbackMode;
  final List<String>? queuedTimerIds; // For sequential playback
  final DateTime? pausedAt; // For background handling

  const ActiveTimerState({
    this.currentTimerId,
    this.remainingTime,
    this.isRunning = false,
    this.playbackMode = PlaybackMode.none,
    this.queuedTimerIds,
    this.pausedAt,
  });

  ActiveTimerState copyWith({
    String? currentTimerId,
    Duration? remainingTime,
    bool? isRunning,
    PlaybackMode? playbackMode,
    List<String>? queuedTimerIds,
    DateTime? pausedAt,
    bool clearCurrentTimer = false,
    bool clearQueue = false,
    bool clearPausedAt = false,
  }) {
    return ActiveTimerState(
      currentTimerId: clearCurrentTimer ? null : (currentTimerId ?? this.currentTimerId),
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      playbackMode: playbackMode ?? this.playbackMode,
      queuedTimerIds: clearQueue ? null : (queuedTimerIds ?? this.queuedTimerIds),
      pausedAt: clearPausedAt ? null : (pausedAt ?? this.pausedAt),
    );
  }
}

/// StateNotifier for managing active timer countdown and state
class ActiveTimerNotifier extends StateNotifier<ActiveTimerState>
    with WidgetsBindingObserver {
  Timer? _countdownTimer;
  final Ref _ref;

  ActiveTimerNotifier(this._ref) : super(const ActiveTimerState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app lifecycle changes for background execution
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      // App going to background - store timestamp
      if (state.isRunning) {
        state = state.copyWith(pausedAt: DateTime.now());
      }
    } else if (lifecycleState == AppLifecycleState.resumed) {
      // App returning to foreground - calculate elapsed time
      if (state.pausedAt != null && state.isRunning) {
        final elapsed = DateTime.now().difference(state.pausedAt!);
        final newRemainingTime = state.remainingTime! - elapsed;

        if (newRemainingTime.isNegative || newRemainingTime.inSeconds == 0) {
          // Timer completed while in background
          _onTimerComplete();
        } else {
          // Update remaining time
          state = state.copyWith(
            remainingTime: newRemainingTime,
            clearPausedAt: true,
          );
        }
      }
    }
  }

  /// Starts a single timer (individual mode)
  void startTimer(String timerId, Duration duration) {
    _countdownTimer?.cancel();

    state = ActiveTimerState(
      currentTimerId: timerId,
      remainingTime: duration,
      isRunning: true,
      playbackMode: PlaybackMode.individual,
    );

    _startCountdown();
  }

  /// Starts sequential playback of multiple timers
  void startSequentialPlayback(List<String> timerIds) {
    if (timerIds.isEmpty) return;

    _countdownTimer?.cancel();

    // Start with first timer in queue
    final firstTimerId = timerIds.first;
    final timerList = _ref.read(timerListProvider);
    final firstTimer = timerList.firstWhere((t) => t.id == firstTimerId);

    state = ActiveTimerState(
      currentTimerId: firstTimerId,
      remainingTime: firstTimer.duration,
      isRunning: true,
      playbackMode: PlaybackMode.sequential,
      queuedTimerIds: timerIds,
    );

    _startCountdown();
  }

  /// Pauses the current timer
  void pauseTimer() {
    _countdownTimer?.cancel();
    state = state.copyWith(isRunning: false, pausedAt: DateTime.now());
  }

  /// Resumes a paused timer
  void resumeTimer() {
    if (state.remainingTime != null && !state.isRunning) {
      state = state.copyWith(isRunning: true, clearPausedAt: true);
      _startCountdown();
    }
  }

  /// Stops the current timer and resets state
  void stopTimer() {
    _countdownTimer?.cancel();
    state = const ActiveTimerState();
  }

  /// Internal countdown logic
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime == null) {
        timer.cancel();
        return;
      }

      final newTime = state.remainingTime! - const Duration(seconds: 1);

      if (newTime.isNegative || newTime.inSeconds == 0) {
        _onTimerComplete();
      } else {
        state = state.copyWith(remainingTime: newTime);
      }
    });
  }

  /// Handles timer completion
  void _onTimerComplete() {
    _countdownTimer?.cancel();

    // Play completion sound
    final timerList = _ref.read(timerListProvider);
    final completedTimer = timerList.firstWhere(
      (t) => t.id == state.currentTimerId,
      orElse: () => timerList.first,
    );
    _ref.read(audioServiceProvider).playSound(completedTimer.soundFileName);

    // Check if there are more timers in queue (sequential mode)
    if (state.playbackMode == PlaybackMode.sequential &&
        state.queuedTimerIds != null) {
      final currentIndex =
          state.queuedTimerIds!.indexOf(state.currentTimerId!);

      if (currentIndex >= 0 && currentIndex < state.queuedTimerIds!.length - 1) {
        // Start next timer in queue
        final nextTimerId = state.queuedTimerIds![currentIndex + 1];
        final nextTimer = timerList.firstWhere((t) => t.id == nextTimerId);

        state = state.copyWith(
          currentTimerId: nextTimerId,
          remainingTime: nextTimer.duration,
          isRunning: true,
        );

        _startCountdown();
        return;
      }
    }

    // No more timers - reset to idle
    state = const ActiveTimerState();
  }
}

/// Provider for active timer state
final activeTimerProvider =
    StateNotifierProvider<ActiveTimerNotifier, ActiveTimerState>((ref) {
  return ActiveTimerNotifier(ref);
});


