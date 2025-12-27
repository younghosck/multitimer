import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';

/// Provider for audio service singleton
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  
  // Preload sounds on initialization
  audioService.preloadSounds();
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    audioService.dispose();
  });
  
  return audioService;
});
