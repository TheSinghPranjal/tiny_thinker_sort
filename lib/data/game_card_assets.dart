import 'package:flutter/material.dart';

import '../theme/sortjoy_theme.dart';

/// Visual assets and colors for home-screen game cards.
abstract final class GameCardAssets {
  static const leafIcon = 'assets/icons/leaf.png';
  static const placeholderImage = 'assets/games/placeholder.png';

  static String imageFor(String gameId) => 'assets/games/$gameId.png';

  static Color titleColorFor(String gameId) => switch (gameId) {
        'fruit_veg_sort' || 'healthy_junk_food_sort' => const Color(0xFF2F8C2F),
        'indoor_outdoor_sort' => const Color(0xFF254A9A),
        'color_sort' || 'color_school_bags' => const Color(0xFF6A4CFF),
        'big_small_sort_tiny' || 'big_small_sort' => const Color(0xFF0288D1),
        'flower_garden' => const Color(0xFFD81B60),
        _ => const Color(0xFF254A9A),
      };

  static Color badgeColorFor(String gameId) => switch (gameId) {
        'fruit_veg_sort' || 'healthy_junk_food_sort' => SortJoyColors.grassDark,
        'indoor_outdoor_sort' => const Color(0xFF4F9EFF),
        'color_sort' || 'color_school_bags' => SortJoyColors.lavender,
        'big_small_sort_tiny' || 'big_small_sort' => SortJoyColors.mint,
        'flower_garden' => SortJoyColors.berry,
        _ => const Color(0xFF4F9EFF),
      };
}
