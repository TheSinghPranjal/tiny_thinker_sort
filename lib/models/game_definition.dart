import 'age_world.dart';

enum InteractionStyle { tap, drag, tapOrDrag }

class GameDefinition {
  const GameDefinition({
    required this.id,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.ageWorld,
    required this.skills,
    required this.interaction,
    this.implemented = false,
  });

  final String id;
  final String title;
  final String emoji;
  final String subtitle;
  final AgeWorld ageWorld;
  final List<String> skills;
  final InteractionStyle interaction;
  final bool implemented;
}

class SortCategory {
  const SortCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
  });

  final String id;
  final String label;
  final String emoji;
  final int color;
}

class SortableItem {
  const SortableItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.categoryId,
    this.voiceName,
    this.accentColor,
    this.visualScale = 1.0,
  });

  final String id;
  final String name;
  final String emoji;
  final String categoryId;

  /// Spoken label (e.g. "Red!"); falls back to [name].
  final String? voiceName;

  /// Optional tint for the floating chip (used by Color Sort notebooks).
  final int? accentColor;

  /// Relative chip size (e.g. big vs small objects).
  final double visualScale;

  String get spokenName => voiceName ?? name;
}
