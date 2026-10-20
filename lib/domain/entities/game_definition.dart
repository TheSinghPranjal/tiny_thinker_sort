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
    this.hasParentControls = false,
  });

  final String id;
  final String title;
  final String emoji;
  final String subtitle;
  final AgeWorld ageWorld;
  final List<String> skills;
  final InteractionStyle interaction;
  final bool implemented;

  /// When true, the game appears in Parent Zone with its own settings card.
  final bool hasParentControls;
}
