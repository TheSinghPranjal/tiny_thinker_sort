import '../models/game_definition.dart';
import '../models/parent_settings.dart';

abstract final class ColorSortData {
  static const red = SortCategory(
    id: 'red',
    label: 'Red Bag',
    emoji: '📕',
    color: 0xFFE53935,
  );

  static const blue = SortCategory(
    id: 'blue',
    label: 'Blue Bag',
    emoji: '📘',
    color: 0xFF1E88E5,
  );

  static const green = SortCategory(
    id: 'green',
    label: 'Green Bag',
    emoji: '📗',
    color: 0xFF43A047,
  );

  static const categories = [red, blue, green];

  static const _red = 0xFFE53935;
  static const _darkRed = 0xFFC62828;
  static const _lightRed = 0xFFEF9A9A;
  static const _cherry = 0xFFD32F2F;
  static const _crimson = 0xFFB71C1C;

  static const _brightBlue = 0xFF1E88E5;
  static const _sky = 0xFF4FC3F7;
  static const _navy = 0xFF1565C0;
  static const _royal = 0xFF3949AB;
  static const _aqua = 0xFF26C6DA;

  static const _brightGreen = 0xFF43A047;
  static const _lime = 0xFFCDDC39;
  static const _forest = 0xFF2E7D32;
  static const _mint = 0xFF66BB6A;
  static const _emerald = 0xFF00C853;

  static const items = <SortableItem>[
    // Red notebooks
    SortableItem(
      id: 'bright_red',
      name: 'Bright Red Notebook',
      voiceName: 'Red',
      emoji: '📕',
      categoryId: 'red',
      accentColor: _red,
    ),
    SortableItem(
      id: 'dark_red',
      name: 'Dark Red Notebook',
      voiceName: 'Red',
      emoji: '❤️',
      categoryId: 'red',
      accentColor: _darkRed,
    ),
    SortableItem(
      id: 'light_red',
      name: 'Light Red Notebook',
      voiceName: 'Red',
      emoji: '🌸',
      categoryId: 'red',
      accentColor: _lightRed,
    ),
    SortableItem(
      id: 'cherry_red',
      name: 'Cherry Red Notebook',
      voiceName: 'Red',
      emoji: '🍒',
      categoryId: 'red',
      accentColor: _cherry,
    ),
    SortableItem(
      id: 'crimson',
      name: 'Crimson Notebook',
      voiceName: 'Red',
      emoji: '⭐',
      categoryId: 'red',
      accentColor: _crimson,
    ),
    SortableItem(
      id: 'red_abc',
      name: 'Red ABC Notebook',
      voiceName: 'Red',
      emoji: '🅰️',
      categoryId: 'red',
      accentColor: _red,
    ),
    SortableItem(
      id: 'red_heart',
      name: 'Red Hearts Notebook',
      voiceName: 'Red',
      emoji: '💕',
      categoryId: 'red',
      accentColor: _cherry,
    ),

    // Blue notebooks
    SortableItem(
      id: 'bright_blue',
      name: 'Bright Blue Notebook',
      voiceName: 'Blue',
      emoji: '📘',
      categoryId: 'blue',
      accentColor: _brightBlue,
    ),
    SortableItem(
      id: 'sky_blue',
      name: 'Sky Blue Notebook',
      voiceName: 'Blue',
      emoji: '☁️',
      categoryId: 'blue',
      accentColor: _sky,
    ),
    SortableItem(
      id: 'navy_blue',
      name: 'Navy Blue Notebook',
      voiceName: 'Blue',
      emoji: '🔷',
      categoryId: 'blue',
      accentColor: _navy,
    ),
    SortableItem(
      id: 'royal_blue',
      name: 'Royal Blue Notebook',
      voiceName: 'Blue',
      emoji: '👑',
      categoryId: 'blue',
      accentColor: _royal,
    ),
    SortableItem(
      id: 'aqua_blue',
      name: 'Aqua Blue Notebook',
      voiceName: 'Blue',
      emoji: '💧',
      categoryId: 'blue',
      accentColor: _aqua,
    ),
    SortableItem(
      id: 'blue_123',
      name: 'Blue Numbers Notebook',
      voiceName: 'Blue',
      emoji: '🔢',
      categoryId: 'blue',
      accentColor: _brightBlue,
    ),
    SortableItem(
      id: 'blue_fish',
      name: 'Blue Fish Notebook',
      voiceName: 'Blue',
      emoji: '🐠',
      categoryId: 'blue',
      accentColor: _sky,
    ),

    // Green notebooks
    SortableItem(
      id: 'bright_green',
      name: 'Bright Green Notebook',
      voiceName: 'Green',
      emoji: '📗',
      categoryId: 'green',
      accentColor: _brightGreen,
    ),
    SortableItem(
      id: 'lime_green',
      name: 'Lime Green Notebook',
      voiceName: 'Green',
      emoji: '🍋',
      categoryId: 'green',
      accentColor: _lime,
    ),
    SortableItem(
      id: 'forest_green',
      name: 'Forest Green Notebook',
      voiceName: 'Green',
      emoji: '🌲',
      categoryId: 'green',
      accentColor: _forest,
    ),
    SortableItem(
      id: 'mint_green',
      name: 'Mint Green Notebook',
      voiceName: 'Green',
      emoji: '🍃',
      categoryId: 'green',
      accentColor: _mint,
    ),
    SortableItem(
      id: 'emerald',
      name: 'Emerald Green Notebook',
      voiceName: 'Green',
      emoji: '💎',
      categoryId: 'green',
      accentColor: _emerald,
    ),
    SortableItem(
      id: 'green_frog',
      name: 'Green Frog Notebook',
      voiceName: 'Green',
      emoji: '🐸',
      categoryId: 'green',
      accentColor: _mint,
    ),
    SortableItem(
      id: 'green_star',
      name: 'Green Stars Notebook',
      voiceName: 'Green',
      emoji: '🌟',
      categoryId: 'green',
      accentColor: _brightGreen,
    ),
  ];

  static List<SortableItem> itemsForMode(ColorSortMode mode) {
    return switch (mode) {
      ColorSortMode.mixed => items,
      ColorSortMode.redOnly =>
        items.where((i) => i.categoryId == 'red').toList(),
      ColorSortMode.blueOnly =>
        items.where((i) => i.categoryId == 'blue').toList(),
      ColorSortMode.greenOnly =>
        items.where((i) => i.categoryId == 'green').toList(),
    };
  }

  static List<SortCategory> categoriesForMode(ColorSortMode mode) {
    return switch (mode) {
      ColorSortMode.mixed => categories,
      ColorSortMode.redOnly => [red],
      ColorSortMode.blueOnly => [blue],
      ColorSortMode.greenOnly => [green],
    };
  }
}
