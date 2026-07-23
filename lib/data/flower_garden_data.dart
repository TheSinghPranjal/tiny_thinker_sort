import 'dart:math';

import '../models/game_definition.dart';

/// Flower Garden — toddler color matching with flowers and flower pots.
abstract final class FlowerGardenData {
  static const defaultEnabledColorIds = ['pink', 'yellow', 'red'];

  static const allColorIds = ['pink', 'yellow', 'red', 'orange', 'purple'];

  static const _categories = <SortCategory>[
    SortCategory(id: 'pink', label: 'Pink', emoji: '🌸', color: 0xFFF48FB1),
    SortCategory(id: 'yellow', label: 'Yellow', emoji: '🌼', color: 0xFFFFD54F),
    SortCategory(id: 'red', label: 'Red', emoji: '🌹', color: 0xFFE53935),
    SortCategory(id: 'orange', label: 'Orange', emoji: '🌺', color: 0xFFFF9800),
    SortCategory(id: 'purple', label: 'Purple', emoji: '💜', color: 0xFFAB47BC),
  ];

  static const _items = <SortableItem>[
    SortableItem(
      id: 'flower_pink',
      name: 'Pink Flower',
      voiceName: 'Pink',
      emoji: '🌸',
      categoryId: 'pink',
      accentColor: 0xFFF48FB1,
    ),
    SortableItem(
      id: 'flower_yellow',
      name: 'Yellow Flower',
      voiceName: 'Yellow',
      emoji: '🌼',
      categoryId: 'yellow',
      accentColor: 0xFFFFD54F,
    ),
    SortableItem(
      id: 'flower_red',
      name: 'Red Flower',
      voiceName: 'Red',
      emoji: '🌹',
      categoryId: 'red',
      accentColor: 0xFFE53935,
    ),
    SortableItem(
      id: 'flower_orange',
      name: 'Orange Flower',
      voiceName: 'Orange',
      emoji: '🌺',
      categoryId: 'orange',
      accentColor: 0xFFFF9800,
    ),
    SortableItem(
      id: 'flower_purple',
      name: 'Purple Flower',
      voiceName: 'Purple',
      emoji: '💜',
      categoryId: 'purple',
      accentColor: 0xFFAB47BC,
    ),
  ];

  static SortCategory? categoryById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  static String displayName(String id) => categoryById(id)?.label ?? id;

  /// Picks [potCount] categories from parent-enabled colors.
  static List<SortCategory> pickCategories({
    required List<String> enabledColorIds,
    required int potCount,
    Random? random,
  }) {
    final rng = random ?? Random();
    final enabled =
        enabledColorIds.where((id) => categoryById(id) != null).toList();
    final pool = enabled.length >= 2
        ? List<String>.from(enabled)
        : List<String>.from(defaultEnabledColorIds);
    pool.shuffle(rng);
    final count = potCount.clamp(2, pool.length);
    return pool.take(count).map((id) => categoryById(id)!).toList();
  }

  static List<SortableItem> itemsForCategories(List<SortCategory> categories) {
    final ids = categories.map((c) => c.id).toSet();
    return _items.where((i) => ids.contains(i.categoryId)).toList();
  }
}
