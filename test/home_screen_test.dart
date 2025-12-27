import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multitimer/models/timer_model.dart';
import 'package:multitimer/providers/timer_list_provider.dart';
import 'package:multitimer/screens/home_screen.dart';
import 'package:multitimer/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeScreen Widget Tests - Play All Logic', () {
    late List<MeditationTimer> mockTimers;

    setUp(() async {
      // Create mock timers for testing
      mockTimers = [
        MeditationTimer(
          id: 'timer-1',
          name: 'Timer 1',
          color: TimerColors.softBlue,
          duration: const Duration(seconds: 10),
          soundFileName: MeditationSounds.bellSoft,
        ),
        MeditationTimer(
          id: 'timer-2',
          name: 'Timer 2',
          color: TimerColors.coral,
          duration: const Duration(seconds: 15),
          soundFileName: MeditationSounds.chimeGentle,
        ),
        MeditationTimer(
          id: 'timer-3',
          name: 'Timer 3',
          color: TimerColors.mint,
          duration: const Duration(seconds: 20),
          soundFileName: MeditationSounds.gongDeep,
        ),
      ];
    });

    testWidgets('Play All button should disable individual timer controls',
        (WidgetTester tester) async {
      // Arrange: Create overrides for providers with mock data
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            timerListProvider.overrideWith((ref) {
              return TimerListNotifier(
                MockStorageService(prefs, mockTimers),
              );
            }),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify timers are displayed
      expect(find.text('Timer 1'), findsOneWidget);
      expect(find.text('Timer 2'), findsOneWidget);
      expect(find.text('Timer 3'), findsOneWidget);

      // Find individual play buttons (should be enabled initially)
      final playButtons = find.byIcon(Icons.play_arrow);
      expect(playButtons, findsNWidgets(4)); // 3 individual + 1 global

      // Act: Tap the global "Play All" button (top-left)
      final globalPlayButton = playButtons.first;
      await tester.tap(globalPlayButton);
      await tester.pumpAndSettle();

      // Assert: Global button should change to pause/stop icons
      expect(
        find.byIcon(Icons.pause),
        findsWidgets,
        reason: 'Play All should show pause icon when running',
      );
      expect(
        find.byIcon(Icons.stop),
        findsWidgets,
        reason: 'Stop button should appear during sequential playback',
      );

      // Assert: Individual timer play buttons should be disabled (opacity = 0.3)
      // We check this by verifying the Opacity widget exists with value 0.3
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final disabledButtons = opacityWidgets.where((w) => w.opacity == 0.3);
      expect(
        disabledButtons.length,
        greaterThan(0),
        reason: 'Individual play buttons should be disabled (opacity 0.3)',
      );

      // Act: Stop the sequential playback
      final stopButton = find.byIcon(Icons.stop);
      await tester.tap(stopButton);
      await tester.pumpAndSettle();

      // Assert: Individual buttons should be enabled again (opacity = 1.0)
      final enabledOpacityWidgets =
          tester.widgetList<Opacity>(find.byType(Opacity));
      final enabledButtons =
          enabledOpacityWidgets.where((w) => w.opacity == 1.0);
      expect(
        enabledButtons.length,
        greaterThan(0),
        reason: 'Individual play buttons should be enabled after stopping',
      );
    });

    testWidgets('Individual timer play should disable Play All button',
        (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            timerListProvider.overrideWith((ref) {
              return TimerListNotifier(
                MockStorageService(prefs, mockTimers),
              );
            }),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act: Tap an individual timer's play button
      final individualPlayButtons = find.byIcon(Icons.play_arrow);
      // Skip the first one (global), tap the second one (first timer)
      await tester.tap(individualPlayButtons.at(1));
      await tester.pumpAndSettle();

      // Assert: Global "Play All" button should be disabled
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final disabledGlobal = opacityWidgets.where((w) => w.opacity == 0.3);
      expect(
        disabledGlobal.length,
        greaterThan(0),
        reason: 'Play All should be disabled when individual timer is playing',
      );
    });

    testWidgets('Empty state should show helpful message',
        (WidgetTester tester) async {
      // Arrange: Empty timer list
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            timerListProvider.overrideWith((ref) {
              return TimerListNotifier(
                MockStorageService(prefs, []),
              );
            }),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert: Empty state message should be shown
      expect(find.text('No timers yet'), findsOneWidget);
      expect(find.text('Tap + to create your first timer'), findsOneWidget);
      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    });
  });
}

/// Mock storage service for testing - extends real StorageService
class MockStorageService extends StorageService {
  final List<MeditationTimer> _mockTimers;

  MockStorageService(SharedPreferences prefs, this._mockTimers) : super(prefs);

  @override
  List<MeditationTimer> loadTimers() {
    return _mockTimers;
  }
}
