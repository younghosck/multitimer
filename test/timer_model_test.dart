import 'package:flutter_test/flutter_test.dart';
import 'package:multitimer/models/timer_model.dart';

void main() {
  group('MeditationTimer Model Tests', () {
    test('Timer should serialize to/from JSON correctly', () {
      // Arrange
      final timer = MeditationTimer(
        id: 'test-id-123',
        name: 'Morning Meditation',
        color: TimerColors.softBlue,
        duration: const Duration(minutes: 20),
        soundFileName: MeditationSounds.bellSoft,
      );

      // Act
      final json = timer.toJson();
      final restored = MeditationTimer.fromJson(json);

      // Assert
      expect(restored.id, timer.id);
      expect(restored.name, timer.name);
      expect(restored.color.value, timer.color.value);
      expect(restored.duration, timer.duration);
      expect(restored.soundFileName, timer.soundFileName);
    });

    test('Timer copyWith should update specified fields only', () {
      // Arrange
      final original = MeditationTimer(
        id: 'test-id',
        name: 'Test Timer',
        color: TimerColors.mint,
        duration: const Duration(minutes: 10),
        soundFileName: MeditationSounds.chimeGentle,
      );

      // Act
      final updated = original.copyWith(
        name: 'Updated Name',
        duration: const Duration(minutes: 15),
      );

      // Assert
      expect(updated.id, original.id); // unchanged
      expect(updated.name, 'Updated Name'); // changed
      expect(updated.color, original.color); // unchanged
      expect(updated.duration, const Duration(minutes: 15)); // changed
      expect(updated.soundFileName, original.soundFileName); // unchanged
    });

    test('Timer equality should be based on ID', () {
      // Arrange
      final timer1 = MeditationTimer(
        id: 'same-id',
        name: 'Timer 1',
        color: TimerColors.coral,
        duration: const Duration(minutes: 5),
        soundFileName: MeditationSounds.gongDeep,
      );

      final timer2 = MeditationTimer(
        id: 'same-id',
        name: 'Timer 2', // different name
        color: TimerColors.lavender, // different color
        duration: const Duration(minutes: 10), // different duration
        soundFileName: MeditationSounds.singingBowl, // different sound
      );

      final timer3 = MeditationTimer(
        id: 'different-id',
        name: 'Timer 1',
        color: TimerColors.coral,
        duration: const Duration(minutes: 5),
        soundFileName: MeditationSounds.gongDeep,
      );

      // Assert
      expect(timer1, timer2); // same ID
      expect(timer1, isNot(timer3)); // different ID
    });
  });

  group('TimerColors Tests', () {
    test('Should have exactly 8 predefined colors', () {
      expect(TimerColors.all.length, 8);
    });

    test('All colors should be unique', () {
      final colorSet = TimerColors.all.toSet();
      expect(colorSet.length, TimerColors.all.length);
    });
  });

  group('MeditationSounds Tests', () {
    test('Should have exactly 5 predefined sounds', () {
      expect(MeditationSounds.all.length, 5);
    });

    test('getDisplayName should return readable names', () {
      expect(
        MeditationSounds.getDisplayName(MeditationSounds.bellSoft),
        'Bell (Soft)',
      );
      expect(
        MeditationSounds.getDisplayName(MeditationSounds.singingBowl),
        'Singing Bowl',
      );
    });

    test('getDisplayName should handle unknown sound gracefully', () {
      expect(
        MeditationSounds.getDisplayName('unknown_sound.mp3'),
        'Unknown Sound',
      );
    });
  });
}
