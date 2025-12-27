import 'package:flutter/material.dart';

/// Represents a single meditation timer with all its properties
class MeditationTimer {
  final String id;
  final String name;
  final Color color;
  final Duration duration;
  final String soundFileName;

  MeditationTimer({
    required this.id,
    required this.name,
    required this.color,
    required this.duration,
    required this.soundFileName,
  });

  /// Creates a copy of this timer with optionally updated fields
  MeditationTimer copyWith({
    String? id,
    String? name,
    Color? color,
    Duration? duration,
    String? soundFileName,
  }) {
    return MeditationTimer(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      soundFileName: soundFileName ?? this.soundFileName,
    );
  }

  /// Converts timer to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value, // Store as integer hex value
      'durationSeconds': duration.inSeconds,
      'soundFileName': soundFileName,
    };
  }

  /// Creates timer from JSON data
  factory MeditationTimer.fromJson(Map<String, dynamic> json) {
    return MeditationTimer(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      duration: Duration(seconds: json['durationSeconds'] as int),
      soundFileName: json['soundFileName'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationTimer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Predefined accent colors for timer tags
class TimerColors {
  static const softBlue = Color(0xFFA8DAFF);
  static const coral = Color(0xFFFFB3B3);
  static const mint = Color(0xFFB3FFDA);
  static const lavender = Color(0xFFD4B3FF);
  static const peach = Color(0xFFFFDAB3);
  static const rose = Color(0xFFFFB3E6);
  static const sage = Color(0xFFC4E5C0);
  static const sky = Color(0xFFB3E5FF);

  static const List<Color> all = [
    softBlue,
    coral,
    mint,
    lavender,
    peach,
    rose,
    sage,
    sky,
  ];
}

/// Available meditation completion sounds
class MeditationSounds {
  static const bellSoft = 'bell_soft.mp3';
  static const bellClear = 'bell_clear.mp3';
  static const chimeGentle = 'chime_gentle.mp3';
  static const gongDeep = 'gong_deep.mp3';
  static const singingBowl = 'singing_bowl.mp3';

  static const List<String> all = [
    bellSoft,
    bellClear,
    chimeGentle,
    gongDeep,
    singingBowl,
  ];

  /// Returns display name for sound file
  static String getDisplayName(String fileName) {
    switch (fileName) {
      case bellSoft:
        return 'Bell (Soft)';
      case bellClear:
        return 'Bell (Clear)';
      case chimeGentle:
        return 'Chime (Gentle)';
      case gongDeep:
        return 'Gong (Deep)';
      case singingBowl:
        return 'Singing Bowl';
      default:
        return 'Unknown Sound';
    }
  }
}
