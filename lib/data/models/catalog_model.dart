import '../../domain/entities/age_world.dart';
import '../../domain/entities/game_definition.dart';

class CatalogEntryModel {
  const CatalogEntryModel({required this.game, this.contentAsset});

  final GameDefinition game;
  final String? contentAsset;

  static List<CatalogEntryModel> listFromJson(Map<String, dynamic> json) {
    final raw = json['games'];
    if (raw is! List) {
      throw const FormatException('catalog.json is missing a games array');
    }
    return [
      for (final entry in raw)
        fromJson(Map<String, dynamic>.from(entry as Map)),
    ];
  }

  static CatalogEntryModel fromJson(Map<String, dynamic> json) {
    final skillsRaw = json['skills'];
    return CatalogEntryModel(
      game: GameDefinition(
        id: json['id'] as String,
        title: json['title'] as String,
        emoji: json['emoji'] as String,
        subtitle: json['subtitle'] as String,
        ageWorld: AgeWorld.values.byName(json['ageWorld'] as String),
        skills: skillsRaw is List
            ? skillsRaw.map((e) => e as String).toList()
            : const [],
        interaction: InteractionStyle.values.byName(
          json['interaction'] as String,
        ),
        implemented: json['implemented'] as bool? ?? false,
        hasParentControls: json['hasParentControls'] as bool? ?? false,
      ),
      contentAsset: json['contentAsset'] as String?,
    );
  }
}
