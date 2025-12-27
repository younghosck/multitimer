import 'package:flutter/material.dart';
import '../models/timer_model.dart';

/// Button that displays selected sound and opens sound selection sheet
class SoundSelectorButton extends StatelessWidget {
  final String selectedSound;
  final VoidCallback onTap;

  const SoundSelectorButton({
    super.key,
    required this.selectedSound,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_outlined,
              color: Colors.grey[800],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                MeditationSounds.getDisplayName(selectedSound),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[900],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
