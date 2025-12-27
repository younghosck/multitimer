import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_model.dart';
import '../providers/timer_list_provider.dart';
import '../providers/active_timer_provider.dart';
import '../widgets/timer_card.dart';
import 'timer_edit_screen.dart';

/// Home screen displaying list of timers with global controls
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timers = ref.watch(timerListProvider);
    final activeState = ref.watch(activeTimerProvider);

    final isPlayAllMode = activeState.playbackMode == PlaybackMode.playAll;
    final hasIndividualTimer =
        activeState.playbackMode == PlaybackMode.individual;
    final isAnyTimerRunning = activeState.isRunning;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Play All button (left)
                  if (timers.isNotEmpty)
                    Opacity(
                      opacity: hasIndividualTimer ? 0.3 : 1.0,
                      child: GestureDetector(
                        onTap: hasIndividualTimer
                            ? null
                            : () {
                                if (isPlayAllMode && isAnyTimerRunning) {
                                  // Stop if playing
                                  ref
                                      .read(activeTimerProvider.notifier)
                                      .stopAllTimers();
                                } else {
                                  // Start fresh
                                  final timerIds =
                                      timers.map((t) => t.id).toList();
                                  ref
                                      .read(activeTimerProvider.notifier)
                                      .startAllTimers(timerIds);
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            isPlayAllMode && isAnyTimerRunning
                                ? Icons.stop
                                : Icons.play_arrow,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  // App title
                  Text(
                    'Timers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),

                  const Spacer(),

                  // Add button (right)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TimerEditScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Unified timer list - ALL timers displayed
            Expanded(
              child: timers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No timers yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to create your first timer',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: timers.length,
                      itemBuilder: (context, index) {
                        final timer = timers[index];
                        final isRunning =
                            activeState.runningTimers.containsKey(timer.id);
                        final remainingTime =
                            activeState.getRemainingTime(timer.id);
                        final isDisabled = isPlayAllMode;

                        return Dismissible(
                          key: Key(timer.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            if (activeState.runningTimers
                                .containsKey(timer.id)) {
                              ref
                                  .read(activeTimerProvider.notifier)
                                  .stopAllTimers();
                            }
                            ref
                                .read(timerListProvider.notifier)
                                .deleteTimer(timer.id);
                          },
                          child: TimerCard(
                            timer: timer,
                            remainingTime: remainingTime,
                            isRunning: isRunning,
                            isDisabled: isDisabled,
                            onPlayPause: () {
                              if (isRunning) {
                                ref
                                    .read(activeTimerProvider.notifier)
                                    .stopAllTimers();
                              } else {
                                ref
                                    .read(activeTimerProvider.notifier)
                                    .startTimer(timer.id, timer.duration);
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimerEditScreen(
                                    timerId: timer.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
