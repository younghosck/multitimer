import 'package:just_audio/just_audio.dart';
import '../models/timer_model.dart';

/// Manages audio playback for timer completion sounds
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final Map<String, AudioSource> _preloadedSounds = {};

  /// Preloads all meditation sounds into memory for instant playback
  Future<void> preloadSounds() async {
    for (final soundFile in MeditationSounds.all) {
      try {
        final source = AudioSource.asset('assets/sounds/$soundFile');
        _preloadedSounds[soundFile] = source;
      } catch (e) {
        // Log error but continue - don't crash if a sound file is missing
        print('Warning: Could not preload sound $soundFile: $e');
      }
    }
  }

  /// Plays a specific meditation sound
  Future<void> playSound(String soundFileName) async {
    try {
      final source = _preloadedSounds[soundFileName];
      if (source != null) {
        await _player.setAudioSource(source);
        await _player.play();
      } else {
        // Fallback: Try to load and play directly (slower)
        await _player.setAsset('assets/sounds/$soundFileName');
        await _player.play();
      }
    } catch (e) {
      // Graceful error handling - don't crash if sound playback fails
      print('Error playing sound $soundFileName: $e');
    }
  }

  /// Stops currently playing sound
  Future<void> stopSound() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  /// Releases audio resources - call when app is disposed
  void dispose() {
    _player.dispose();
  }
}
