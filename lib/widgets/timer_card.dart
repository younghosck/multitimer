import 'package:flutter/material.dart';
import '../models/timer_model.dart';

/// Individual timer card displaying time and controls
class TimerCard extends StatelessWidget {
  final MeditationTimer timer;
  final Duration? remainingTime;
  final bool isRunning;
  final bool isDisabled;
  final VoidCallback onPlayPause;
  final VoidCallback? onTap;

  const TimerCard({
    super.key,
    required this.timer,
    this.remainingTime,
    this.isRunning = false,
    this.isDisabled = false,
    required this.onPlayPause,
    this.onTap,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDuration = remainingTime ?? timer.duration;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: timer.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: timer.color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Timer icon
            Icon(
              Icons.hourglass_empty,
              color: Colors.grey[700],
              size: 28,
            ),
            const SizedBox(width: 16),
            
            // Timer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (timer.name.isNotEmpty)
                    Text(
                      timer.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Text(
                    _formatDuration(displayDuration),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            
            // Play/Pause button
            Opacity(
              opacity: isDisabled ? 0.3 : 1.0,
              child: GestureDetector(
                onTap: isDisabled ? null : onPlayPause,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
