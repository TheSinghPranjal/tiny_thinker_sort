import '../models/game_definition.dart';

/// Learn to Sort — Healthy Food vs Junk Food (ages 1–2).
abstract final class HealthyFoodData {
  static const healthyCategoryId = 'healthy';
  static const junkCategoryId = 'junk';

  static const beginnerItemIds = ['apple', 'banana', 'burger', 'pizza'];

  static const defaultEnabledHealthyIds = [
    'apple',
    'banana',
    'carrot',
    'broccoli',
    'grapes',
    'orange',
    'mango',
    'watermelon',
  ];

  static const defaultEnabledJunkIds = [
    'burger',
    'pizza',
    'fries',
    'donut',
    'soda',
    'chocolate',
    'noodles',
    'cake',
  ];

  static const allHealthyIds = [
    'apple',
    'banana',
    'strawberry',
    'grapes',
    'carrot',
    'broccoli',
    'cucumber',
    'orange',
    'mango',
    'watermelon',
    'pineapple',
    'lettuce',
    'kiwi',
    'corn',
    'potato',
    'pear',
  ];

  static const allJunkIds = [
    'burger',
    'pizza',
    'fries',
    'hot_dog',
    'donut',
    'cookie',
    'chocolate',
    'cake',
    'noodles',
    'soda',
    'candy',
    'cupcake',
    'lollipop',
    'popcorn',
  ];

  static const categories = <SortCategory>[
    SortCategory(
      id: healthyCategoryId,
      label: 'Healthy Food',
      emoji: '🥦',
      color: 0xFF66BB6A,
    ),
    SortCategory(
      id: junkCategoryId,
      label: 'Junk Food',
      emoji: '🍔',
      color: 0xFFFF7043,
    ),
  ];

  static const _items = <SortableItem>[
    // Healthy
    SortableItem(
      id: 'apple',
      name: 'Apple',
      emoji: '🍎',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'banana',
      name: 'Banana',
      emoji: '🍌',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'strawberry',
      name: 'Strawberry',
      emoji: '🍓',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'grapes',
      name: 'Grapes',
      emoji: '🍇',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'carrot',
      name: 'Carrot',
      emoji: '🥕',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'broccoli',
      name: 'Broccoli',
      emoji: '🥦',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'cucumber',
      name: 'Cucumber',
      emoji: '🥒',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'orange',
      name: 'Orange',
      emoji: '🍊',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'mango',
      name: 'Mango',
      emoji: '🥭',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'watermelon',
      name: 'Watermelon',
      emoji: '🍉',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'pineapple',
      name: 'Pineapple',
      emoji: '🍍',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'lettuce',
      name: 'Lettuce',
      emoji: '🥬',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'kiwi',
      name: 'Kiwi',
      emoji: '🥝',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'corn',
      name: 'Corn',
      emoji: '🌽',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'potato',
      name: 'Potato',
      emoji: '🥔',
      categoryId: healthyCategoryId,
    ),
    SortableItem(
      id: 'pear',
      name: 'Pear',
      emoji: '🍐',
      categoryId: healthyCategoryId,
    ),
    // Junk
    SortableItem(
      id: 'burger',
      name: 'Burger',
      emoji: '🍔',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'pizza',
      name: 'Pizza',
      emoji: '🍕',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'fries',
      name: 'French Fries',
      voiceName: 'Fries',
      emoji: '🍟',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'hot_dog',
      name: 'Hot Dog',
      emoji: '🌭',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'donut',
      name: 'Donut',
      emoji: '🍩',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'cookie',
      name: 'Cookie',
      emoji: '🍪',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'chocolate',
      name: 'Chocolate',
      emoji: '🍫',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'cake',
      name: 'Cake',
      emoji: '🍰',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'noodles',
      name: 'Instant Noodles',
      voiceName: 'Noodles',
      emoji: '🍜',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'soda',
      name: 'Soda',
      emoji: '🥤',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'candy',
      name: 'Candy',
      emoji: '🍭',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'cupcake',
      name: 'Cupcake',
      emoji: '🧁',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'lollipop',
      name: 'Lollipop',
      emoji: '🍬',
      categoryId: junkCategoryId,
    ),
    SortableItem(
      id: 'popcorn',
      name: 'Popcorn',
      emoji: '🍿',
      categoryId: junkCategoryId,
    ),
  ];

  static SortableItem? itemById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static String displayName(String id) => itemById(id)?.name ?? id;

  static String categoryLabelFor(String categoryId) => switch (categoryId) {
    healthyCategoryId => 'Healthy Food!',
    junkCategoryId => 'Junk Food!',
    _ => '',
  };

  static String resultLabelFor(String categoryId) => switch (categoryId) {
    healthyCategoryId => 'HEALTHY!',
    junkCategoryId => 'JUNK FOOD',
    _ => '',
  };

  /// Builds the active item pool from parent settings and difficulty.
  static List<SortableItem> itemsForSettings({
    required List<String> enabledHealthyIds,
    required List<String> enabledJunkIds,
    required HealthyFoodDifficulty difficulty,
  }) {
    if (difficulty == HealthyFoodDifficulty.beginner) {
      return _items
          .where((i) => beginnerItemIds.contains(i.id))
          .toList(growable: false);
    }

    final healthyPool = _filterEnabled(enabledHealthyIds, allHealthyIds);
    final junkPool = _filterEnabled(enabledJunkIds, allJunkIds);

    final (healthyCount, junkCount) = switch (difficulty) {
      HealthyFoodDifficulty.beginner => (2, 2),
      HealthyFoodDifficulty.easy => (3, 3),
      HealthyFoodDifficulty.medium => (5, 5),
      HealthyFoodDifficulty.advanced => (healthyPool.length, junkPool.length),
    };

    final healthy = healthyPool.take(healthyCount.clamp(0, healthyPool.length));
    final junk = junkPool.take(junkCount.clamp(0, junkPool.length));

    return [
      ...healthy.map((id) => itemById(id)!),
      ...junk.map((id) => itemById(id)!),
    ];
  }

  static List<String> _filterEnabled(
    List<String> enabled,
    List<String> allIds,
  ) {
    final set = enabled.toSet();
    return allIds.where(set.contains).toList(growable: false);
  }
}

enum HealthyFoodDifficulty { beginner, easy, medium, advanced }

abstract final class HealthyFoodDefaults {
  static const enabledHealthy = HealthyFoodData.defaultEnabledHealthyIds;
  static const enabledJunk = HealthyFoodData.defaultEnabledJunkIds;
}
