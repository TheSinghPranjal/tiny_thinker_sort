import '../../domain/entities/game_content.dart';
import '../../domain/entities/sort_category.dart';
import '../../domain/entities/sortable_item.dart';

class GameContentModel {
  static GameContent fromJson(Map<String, dynamic> json) {
    final feedback = json['feedback'];
    final feedbackMap = feedback is Map
        ? Map<String, dynamic>.from(feedback)
        : const <String, dynamic>{};
    final poolsRaw = json['pools'];
    return GameContent(
      gameId: json['gameId'] as String,
      playTitle: json['playTitle'] as String,
      celebrationSubtitle: json['celebrationSubtitle'] as String?,
      categoryEmoji: json['categoryEmoji'] as String?,
      categories: _categories(json['categories']),
      items: _items(json['items']),
      modes: _modes(json['modes']),
      difficulties: _difficulties(json['difficulties']),
      correctLabels: _stringMap(feedbackMap['correctLabels']),
      voiceLabels: _stringMap(feedbackMap['voiceLabels']),
      encouragements: _strings(feedbackMap['encouragements']),
      pools: _pools(
        poolsRaw is Map ? Map<String, dynamic>.from(poolsRaw) : null,
      ),
    );
  }

  static List<SortCategory> _categories(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final entry in raw)
        _category(Map<String, dynamic>.from(entry as Map)),
    ];
  }

  static SortCategory _category(Map<String, dynamic> json) {
    return SortCategory(
      id: json['id'] as String,
      label: json['label'] as String,
      emoji: json['emoji'] as String,
      color: _color(json['color']),
      zoneStyle: json['zoneStyle'] as String? ?? 'basket',
      caption: json['caption'] as String?,
    );
  }

  static List<SortableItem> _items(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final entry in raw) _item(Map<String, dynamic>.from(entry as Map)),
    ];
  }

  static SortableItem _item(Map<String, dynamic> json) {
    return SortableItem(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      categoryId: json['categoryId'] as String,
      voiceName: json['voiceName'] as String?,
      accentColor: json['accentColor'] == null
          ? null
          : _color(json['accentColor']),
      visualScale: (json['visualScale'] as num?)?.toDouble() ?? 1.0,
      imageAsset: json['imageAsset'] as String?,
    );
  }

  static List<ContentMode> _modes(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final entry in raw)
        ContentMode(
          id: (entry as Map)['id'] as String,
          label: entry['label'] as String,
          categoryIds: _strings(entry['categoryIds']),
        ),
    ];
  }

  static List<ContentDifficulty> _difficulties(Object? raw) {
    if (raw is! List) return const [];
    return [
      for (final entry in raw)
        ContentDifficulty(
          id: (entry as Map)['id'] as String,
          label: entry['label'] as String,
          count: (entry['count'] as num?)?.toInt(),
          healthyCount: (entry['healthyCount'] as num?)?.toInt(),
          junkCount: (entry['junkCount'] as num?)?.toInt(),
          useBeginnerSet: entry['useBeginnerSet'] as bool? ?? false,
        ),
    ];
  }

  static ContentPools _pools(Map<String, dynamic>? json) {
    if (json == null) return const ContentPools();
    return ContentPools(
      defaultEnabledIds: _strings(json['defaultEnabledIds']),
      allSelectableIds: _strings(json['allSelectableIds']),
      beginnerItemIds: _strings(json['beginnerItemIds']),
      defaultEnabledHealthyIds: _strings(json['defaultEnabledHealthyIds']),
      defaultEnabledJunkIds: _strings(json['defaultEnabledJunkIds']),
      allHealthyIds: _strings(json['allHealthyIds']),
      allJunkIds: _strings(json['allJunkIds']),
    );
  }

  static Map<String, String> _stringMap(Object? raw) {
    if (raw is! Map) return const {};
    return raw.map((key, value) => MapEntry(key as String, value as String));
  }

  static List<String> _strings(Object? raw) {
    if (raw is! List) return const [];
    return raw.map((e) => e as String).toList();
  }

  static int _color(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    throw FormatException('Expected a color int, got $value');
  }
}
