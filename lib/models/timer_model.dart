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

/// Predefined pastel rainbow colors for timer tags (빨주노초파남보)
class TimerColors {
  static const pastelRed = Color(0xFFFFB3B3); // 빨강
  static const pastelOrange = Color(0xFFFFD1A4); // 주황
  static const pastelYellow = Color(0xFFFFFFA5); // 노랑
  static const pastelGreen = Color(0xFFB4F8C8); // 초록
  static const pastelBlue = Color(0xFFA0E7E5); // 파랑
  static const pastelIndigo = Color(0xFF9E97F0); // 남색
  static const pastelViolet = Color(0xFFD0A9F5); // 보라

  static const List<Color> all = [
    pastelRed,
    pastelOrange,
    pastelYellow,
    pastelGreen,
    pastelBlue,
    pastelIndigo,
    pastelViolet,
  ];

  // Legacy compatibility aliases
  static const softBlue = pastelBlue;
  static const coral = pastelRed;
  static const mint = pastelGreen;
  static const lavender = pastelViolet;
  static const peach = pastelOrange;
  static const rose = pastelRed;
  static const sage = pastelGreen;
  static const sky = pastelBlue;
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
