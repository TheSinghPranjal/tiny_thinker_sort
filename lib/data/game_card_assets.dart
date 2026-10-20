import 'package:flutter/material.dart';

import '../theme/sortjoy_theme.dart';

/// Visual assets and colors for home-screen game cards.
abstract final class GameCardAssets {
  static const leafIcon = 'assets/icons/leaf.png';
  static const placeholderImage = 'assets/games/placeholder.png';

  static String imageFor(String gameId) => 'assets/games/$gameId.png';

  static Color titleColorFor(String gameId) => switch (gameId) {
        'fruit_veg_sort' || 'healthy_junk_food_sort' => const Color(0xFF1E6B1E),
        'indoor_outdoor_sort' => const Color(0xFF1B3A7A),
        'color_sort' || 'color_school_bags' || 'sort_socks' =>
          const Color(0xFF2E2160),
        'big_small_sort_tiny' || 'big_small_sort' => const Color(0xFF16324F),
        'animal_sort' => const Color(0xFF1B5E20),
        'flower_garden' => const Color(0xFFD81B60),
        'clean_dirty_sort' => const Color(0xFF0277BD),
        _ => const Color(0xFF254A9A),
      };

  static Color badgeColorFor(String gameId) => switch (gameId) {
        'fruit_veg_sort' || 'healthy_junk_food_sort' => SortJoyColors.grassDark,
        'indoor_outdoor_sort' => const Color(0xFF3B8BF5),
        'color_sort' || 'color_school_bags' || 'sort_socks' =>
          const Color(0xFF9B6BFA),
        'big_small_sort_tiny' || 'big_small_sort' => const Color(0xFF26B5A8),
        'animal_sort' => const Color(0xFF43A047),
        'flower_garden' => SortJoyColors.berry,
        'clean_dirty_sort' => const Color(0xFF4FC3F7),
        _ => const Color(0xFF4F9EFF),
      };
}
