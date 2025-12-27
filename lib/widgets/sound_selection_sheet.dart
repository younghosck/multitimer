import 'package:flutter/material.dart';
import '../models/timer_model.dart';
import '../providers/audio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet for selecting meditation completion sound
class SoundSelectionSheet extends ConsumerWidget {
  final String currentSound;
  final ValueChanged<String> onSoundSelected;

  const SoundSelectionSheet({
    super.key,
    required this.currentSound,
    required this.onSoundSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioService = ref.read(audioServiceProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alarm Sound',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Sound list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: MeditationSounds.all.length,
              itemBuilder: (context, index) {
                final soundFile = MeditationSounds.all[index];
                final isSelected = soundFile == currentSound;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  title: Text(
                    MeditationSounds.getDisplayName(soundFile),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Preview play button
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline),
                        onPressed: () => audioService.playSound(soundFile),
                      ),
                      // Checkmark for selected
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                  onTap: () {
                    onSoundSelected(soundFile);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
