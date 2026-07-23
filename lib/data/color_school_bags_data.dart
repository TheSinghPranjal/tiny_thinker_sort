import 'dart:math';

import '../models/game_definition.dart';

/// Color School Bags — toddler color matching with books and backpacks.
abstract final class ColorSchoolBagsData {
  static const defaultEnabledColorIds = ['red', 'blue', 'green', 'yellow'];

  static const allColorIds = [
    'red',
    'blue',
    'green',
    'yellow',
    'orange',
    'pink',
    'purple',
    'brown',
    'grey',
    'black',
    'white',
    'sky_blue',
    'navy',
    'light_blue',
    'light_green',
    'magenta',
    'lilac',
    'silver',
    'gold',
  ];

  static const _categories = <SortCategory>[
    SortCategory(id: 'red', label: 'Red', emoji: '🎒', color: 0xFFE53935),
    SortCategory(id: 'blue', label: 'Blue', emoji: '🎒', color: 0xFF1E88E5),
    SortCategory(id: 'green', label: 'Green', emoji: '🎒', color: 0xFF43A047),
    SortCategory(id: 'yellow', label: 'Yellow', emoji: '🎒', color: 0xFFFDD835),
    SortCategory(id: 'orange', label: 'Orange', emoji: '🎒', color: 0xFFFB8C00),
    SortCategory(id: 'pink', label: 'Pink', emoji: '🎒', color: 0xFFEC407A),
    SortCategory(id: 'purple', label: 'Purple', emoji: '🎒', color: 0xFF8E24AA),
    SortCategory(id: 'brown', label: 'Brown', emoji: '🎒', color: 0xFF6D4C41),
    SortCategory(id: 'grey', label: 'Grey', emoji: '🎒', color: 0xFF78909C),
    SortCategory(id: 'black', label: 'Black', emoji: '🎒', color: 0xFF37474F),
    SortCategory(id: 'white', label: 'White', emoji: '🎒', color: 0xFFECEFF1),
    SortCategory(id: 'sky_blue', label: 'Sky Blue', emoji: '🎒', color: 0xFF4FC3F7),
    SortCategory(id: 'navy', label: 'Navy', emoji: '🎒', color: 0xFF1565C0),
    SortCategory(
      id: 'light_blue',
      label: 'Light Blue',
      emoji: '🎒',
      color: 0xFF81D4FA,
    ),
    SortCategory(
      id: 'light_green',
      label: 'Light Green',
      emoji: '🎒',
      color: 0xFF81C784,
    ),
    SortCategory(id: 'magenta', label: 'Magenta', emoji: '🎒', color: 0xFFD81B60),
    SortCategory(id: 'lilac', label: 'Lilac', emoji: '🎒', color: 0xFFCE93D8),
    SortCategory(id: 'silver', label: 'Silver', emoji: '🎒', color: 0xFFB0BEC5),
    SortCategory(id: 'gold', label: 'Gold', emoji: '🎒', color: 0xFFFFD54F),
  ];

  static const _items = <SortableItem>[
    SortableItem(
      id: 'book_red',
      name: 'Red Book',
      voiceName: 'Red',
      emoji: '📕',
      categoryId: 'red',
      accentColor: 0xFFE53935,
    ),
    SortableItem(
      id: 'book_blue',
      name: 'Blue Book',
      voiceName: 'Blue',
      emoji: '📘',
      categoryId: 'blue',
      accentColor: 0xFF1E88E5,
    ),
    SortableItem(
      id: 'book_green',
      name: 'Green Book',
      voiceName: 'Green',
      emoji: '📗',
      categoryId: 'green',
      accentColor: 0xFF43A047,
    ),
    SortableItem(
      id: 'book_yellow',
      name: 'Yellow Book',
      voiceName: 'Yellow',
      emoji: '📒',
      categoryId: 'yellow',
      accentColor: 0xFFFDD835,
    ),
    SortableItem(
      id: 'book_orange',
      name: 'Orange Book',
      voiceName: 'Orange',
      emoji: '📙',
      categoryId: 'orange',
      accentColor: 0xFFFB8C00,
    ),
    SortableItem(
      id: 'book_pink',
      name: 'Pink Book',
      voiceName: 'Pink',
      emoji: '🌸',
      categoryId: 'pink',
      accentColor: 0xFFEC407A,
    ),
    SortableItem(
      id: 'book_purple',
      name: 'Purple Book',
      voiceName: 'Purple',
      emoji: '💜',
      categoryId: 'purple',
      accentColor: 0xFF8E24AA,
    ),
    SortableItem(
      id: 'book_brown',
      name: 'Brown Book',
      voiceName: 'Brown',
      emoji: '🤎',
      categoryId: 'brown',
      accentColor: 0xFF6D4C41,
    ),
    SortableItem(
      id: 'book_grey',
      name: 'Grey Book',
      voiceName: 'Grey',
      emoji: '🩶',
      categoryId: 'grey',
      accentColor: 0xFF78909C,
    ),
    SortableItem(
      id: 'book_black',
      name: 'Black Book',
      voiceName: 'Black',
      emoji: '⚫',
      categoryId: 'black',
      accentColor: 0xFF37474F,
    ),
    SortableItem(
      id: 'book_white',
      name: 'White Book',
      voiceName: 'White',
      emoji: '⚪',
      categoryId: 'white',
      accentColor: 0xFFECEFF1,
    ),
    SortableItem(
      id: 'book_sky_blue',
      name: 'Sky Blue Book',
      voiceName: 'Sky Blue',
      emoji: '🩵',
      categoryId: 'sky_blue',
      accentColor: 0xFF4FC3F7,
    ),
    SortableItem(
      id: 'book_navy',
      name: 'Navy Book',
      voiceName: 'Navy',
      emoji: '🔵',
      categoryId: 'navy',
      accentColor: 0xFF1565C0,
    ),
    SortableItem(
      id: 'book_light_blue',
      name: 'Light Blue Book',
      voiceName: 'Light Blue',
      emoji: '🔷',
      categoryId: 'light_blue',
      accentColor: 0xFF81D4FA,
    ),
    SortableItem(
      id: 'book_light_green',
      name: 'Light Green Book',
      voiceName: 'Light Green',
      emoji: '🟢',
      categoryId: 'light_green',
      accentColor: 0xFF81C784,
    ),
    SortableItem(
      id: 'book_magenta',
      name: 'Magenta Book',
      voiceName: 'Magenta',
      emoji: '💖',
      categoryId: 'magenta',
      accentColor: 0xFFD81B60,
    ),
    SortableItem(
      id: 'book_lilac',
      name: 'Lilac Book',
      voiceName: 'Lilac',
      emoji: '💜',
      categoryId: 'lilac',
      accentColor: 0xFFCE93D8,
    ),
    SortableItem(
      id: 'book_silver',
      name: 'Silver Book',
      voiceName: 'Silver',
      emoji: '🥈',
      categoryId: 'silver',
      accentColor: 0xFFB0BEC5,
    ),
    SortableItem(
      id: 'book_gold',
      name: 'Gold Book',
      voiceName: 'Gold',
      emoji: '🥇',
      categoryId: 'gold',
      accentColor: 0xFFFFD54F,
    ),
  ];

  static SortCategory? categoryById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  static String displayName(String id) =>
      categoryById(id)?.label ?? id;

  /// Picks [backpackCount] categories from parent-enabled colors.
  static List<SortCategory> pickCategories({
    required List<String> enabledColorIds,
    required int backpackCount,
    Random? random,
  }) {
    final rng = random ?? Random();
    final enabled = enabledColorIds
        .where((id) => categoryById(id) != null)
        .toList();
    final pool = enabled.length >= 2
        ? List<String>.from(enabled)
        : List<String>.from(defaultEnabledColorIds);
    pool.shuffle(rng);
    final count = backpackCount.clamp(2, pool.length);
    return pool
        .take(count)
        .map((id) => categoryById(id)!)
        .toList();
  }

  static List<SortableItem> itemsForCategories(List<SortCategory> categories) {
    final ids = categories.map((c) => c.id).toSet();
    return _items.where((i) => ids.contains(i.categoryId)).toList();
  }
}
