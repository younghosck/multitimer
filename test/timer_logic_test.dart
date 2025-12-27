import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multitimer/models/timer_model.dart';
import 'package:multitimer/providers/active_timer_provider.dart';
import 'package:multitimer/providers/timer_list_provider.dart';
import 'package:multitimer/providers/audio_provider.dart';
import 'package:multitimer/services/audio_service.dart';
import 'package:multitimer/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Timer Logic Unit Tests - Background Execution', () {
    test('Background execution: Timer should calculate elapsed time correctly',
        () async {
      // Arrange: Create mock data
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          timerListProvider.overrideWith((ref) {
            return MockTimerListNotifier(prefs);
          }),
          audioServiceProvider.overrideWith((ref) {
            return MockAudioService();
          }),
        ],
      );

      final notifier = container.read(activeTimerProvider.notifier);
      const initialDuration = Duration(minutes: 20);
      const timerId = 'test-timer-1';

      // Act: Start the timer
      notifier.startTimer(timerId, initialDuration);

      // Verify timer started
      var state = container.read(activeTimerProvider);
      expect(state.isRunning, true);
      expect(state.currentTimerId, timerId);
      expect(state.remainingTime, initialDuration);

      // Simulate app going to background
      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

      state = container.read(activeTimerProvider);
      expect(state.pausedAt, isNotNull, reason: 'pausedAt should be set');

      // Manually set pausedAt to 10 minutes ago
      final tenMinutesAgo =
          DateTime.now().subtract(const Duration(minutes: 10));
      notifier.state = state.copyWith(pausedAt: tenMinutesAgo);

      // Act: Simulate app returning to foreground
      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

      // Assert: Remaining time should be exactly 10 minutes
      final finalState = container.read(activeTimerProvider);
      expect(
        finalState.remainingTime!.inSeconds,
        closeTo(600, 2), // Allow 2 second tolerance
        reason:
            'After 10 minutes in background, remaining time should be ~10 minutes',
      );
      expect(
        finalState.isRunning,
        true,
        reason: 'Timer should still be running after resume',
      );

      container.dispose();
    });

    test('Timer should complete if time ran out during background', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          timerListProvider.overrideWith((ref) {
            return MockTimerListNotifier(prefs);
          }),
          audioServiceProvider.overrideWith((ref) {
            return MockAudioService();
          }),
        ],
      );

      final notifier = container.read(activeTimerProvider.notifier);
      const timerId = 'test-timer-2';
      const initialDuration = Duration(minutes: 5);

      notifier.startTimer(timerId, initialDuration);
      notifier.didChangeAppLifecycleState(AppLifecycleState.paused);

      // Simulate 10 minutes passing (more than timer duration)
      final tenMinutesAgo =
          DateTime.now().subtract(const Duration(minutes: 10));
      notifier.state = notifier.state.copyWith(pausedAt: tenMinutesAgo);

      // Act
      notifier.didChangeAppLifecycleState(AppLifecycleState.resumed);

      // Assert: Timer should be completed and reset
      final state = container.read(activeTimerProvider);
      expect(
        state.isRunning,
        false,
        reason: 'Timer should stop if completed during background',
      );

      container.dispose();
    });

    test('Pause and resume should maintain state correctly', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          timerListProvider.overrideWith((ref) {
            return MockTimerListNotifier(prefs);
          }),
        ],
      );

      final notifier = container.read(activeTimerProvider.notifier);
      notifier.startTimer('test-timer', const Duration(minutes: 15));

      // Act: Pause
      notifier.pauseTimer();

      // Assert: Should be paused
      var state = container.read(activeTimerProvider);
      expect(state.isRunning, false);
      expect(state.currentTimerId, isNotNull);
      expect(state.remainingTime, const Duration(minutes: 15));

      // Act: Resume
      notifier.resumeTimer();

      // Assert: Should be running again
      state = container.read(activeTimerProvider);
      expect(state.isRunning, true);
      expect(state.remainingTime, const Duration(minutes: 15));

      container.dispose();
    });

    test('Stop should completely reset timer state', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          timerListProvider.overrideWith((ref) {
            return MockTimerListNotifier(prefs);
          }),
        ],
      );

      final notifier = container.read(activeTimerProvider.notifier);
      notifier.startTimer('test-timer', const Duration(minutes: 10));

      // Act
      notifier.stopTimer();

      // Assert
      final state = container.read(activeTimerProvider);
      expect(state.isRunning, false);
      expect(state.currentTimerId, null);
      expect(state.remainingTime, null);
      expect(state.playbackMode, PlaybackMode.none);

      container.dispose();
    });
  });
}

/// Mock timer list notifier
class MockTimerListNotifier extends TimerListNotifier {
  MockTimerListNotifier(SharedPreferences prefs)
      : super(MockStorageService(prefs, [
          MeditationTimer(
            id: 'test-timer-1',
            name: 'Timer 1',
            color: TimerColors.softBlue,
            duration: const Duration(minutes: 10),
            soundFileName: MeditationSounds.bellSoft,
          ),
          MeditationTimer(
            id: 'test-timer-2',
            name: 'Timer 2',
            color: TimerColors.coral,
            duration: const Duration(minutes: 15),
            soundFileName: MeditationSounds.chimeGentle,
          ),
          MeditationTimer(
            id: 'timer-1',
            name: 'Timer 1',
            color: TimerColors.mint,
            duration: const Duration(seconds: 10),
            soundFileName: MeditationSounds.gongDeep,
          ),
          MeditationTimer(
            id: 'timer-2',
            name: 'Timer 2',
            color: TimerColors.peach,
            duration: const Duration(seconds: 15),
            soundFileName: MeditationSounds.bellSoft,
          ),
          MeditationTimer(
            id: 'timer-3',
            name: 'Timer 3',
            color: TimerColors.rose,
            duration: const Duration(seconds: 20),
            soundFileName: MeditationSounds.chimeGentle,
          ),
        ]));
}

/// Mock storage service - extends real StorageService
class MockStorageService extends StorageService {
  final List<MeditationTimer> _mockTimers;

  MockStorageService(SharedPreferences prefs, this._mockTimers) : super(prefs);

  @override
  List<MeditationTimer> loadTimers() => _mockTimers;
}

/// Mock audio service
class MockAudioService extends AudioService {
  @override
  Future<void> preloadSounds() async {}

  @override
  Future<void> playSound(String soundFileName) async {}

  @override
  Future<void> stopSound() async {}

  @override
  void dispose() {}
}
