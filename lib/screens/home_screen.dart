import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_model.dart';
import '../providers/timer_list_provider.dart';
import '../providers/active_timer_provider.dart';
import '../widgets/timer_card.dart';
import 'timer_edit_screen.dart';

/// Home screen displaying list of timers with global controls
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedSegment = 0; // 0: All, 1: Active

  void _startIndividualTimer(MeditationTimer timer) {
    final activeState = ref.read(activeTimerProvider);
    
    // If this timer is currently running, pause it
    if (activeState.currentTimerId == timer.id && activeState.isRunning) {
      ref.read(activeTimerProvider.notifier).pauseTimer();
    }
    // If this timer is paused, resume it
    else if (activeState.currentTimerId == timer.id && !activeState.isRunning) {
      ref.read(activeTimerProvider.notifier).resumeTimer();
    }
    // Start new timer
    else {
      ref.read(activeTimerProvider.notifier).startTimer(timer.id, timer.duration);
    }
  }

  void _startSequentialPlayback() {
    final timers = ref.read(timerListProvider);
    if (timers.isEmpty) return;

    final timerIds = timers.map((t) => t.id).toList();
    ref.read(activeTimerProvider.notifier).startSequentialPlayback(timerIds);
  }

  void _pauseSequentialPlayback() {
    ref.read(activeTimerProvider.notifier).pauseTimer();
  }

  void _stopSequentialPlayback() {
    ref.read(activeTimerProvider.notifier).stopTimer();
  }

  void _deleteTimer(String timerId) {
    // Stop timer if it's currently running
    final activeState = ref.read(activeTimerProvider);
    if (activeState.currentTimerId == timerId) {
      ref.read(activeTimerProvider.notifier).stopTimer();
    }
    
    ref.read(timerListProvider.notifier).deleteTimer(timerId);
  }

  @override
  Widget build(BuildContext context) {
    final timers = ref.watch(timerListProvider);
    final activeState = ref.watch(activeTimerProvider);

    final isSequentialMode = activeState.playbackMode == PlaybackMode.sequential;
    final hasIndividualTimer = activeState.playbackMode == PlaybackMode.individual;

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
                        onTap: hasIndividualTimer ? null : () {
                          if (isSequentialMode) {
                            if (activeState.isRunning) {
                              _pauseSequentialPlayback();
                            } else {
                              ref.read(activeTimerProvider.notifier).resumeTimer();
                            }
                          } else {
                            _startSequentialPlayback();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                isSequentialMode && activeState.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.blue,
                                size: 28,
                              ),
                              if (isSequentialMode && activeState.isRunning) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _stopSequentialPlayback,
                                  child: const Icon(
                                    Icons.stop,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Segmented control
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildSegment('All', 0),
                        _buildSegment('Active', 1),
                      ],
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

            // Timer list
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
                      itemCount: timers.length,
                      itemBuilder: (context, index) {
                        final timer = timers[index];
                        final isCurrentTimer =
                            activeState.currentTimerId == timer.id;
                        final isDisabled = isSequentialMode;

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
                          onDismissed: (_) => _deleteTimer(timer.id),
                          child: TimerCard(
                            timer: timer,
                            remainingTime: isCurrentTimer
                                ? activeState.remainingTime
                                : null,
                            isRunning: isCurrentTimer && activeState.isRunning,
                            isDisabled: isDisabled,
                            onPlayPause: () => _startIndividualTimer(timer),
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

  Widget _buildSegment(String title, int index) {
    final isSelected = _selectedSegment == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSegment = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
