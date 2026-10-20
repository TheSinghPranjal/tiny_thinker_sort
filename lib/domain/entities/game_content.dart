import 'sort_category.dart';
import 'sortable_item.dart';

/// One parent-selectable filter over a game's categories.
class ContentMode {
  const ContentMode({
    required this.id,
    required this.label,
    required this.categoryIds,
  });

  final String id;
  final String label;
  final List<String> categoryIds;
}

/// Difficulty step described by content (label + how many targets to show).
class ContentDifficulty {
  const ContentDifficulty({
    required this.id,
    required this.label,
    this.count,
    this.healthyCount,
    this.junkCount,
    this.useBeginnerSet = false,
  });

  final String id;
  final String label;
  final int? count;
  final int? healthyCount;
  final int? junkCount;
  final bool useBeginnerSet;
}

/// Id lists parents can toggle. Empty when a game does not use them.
class ContentPools {
  const ContentPools({
    this.defaultEnabledIds = const [],
    this.allSelectableIds = const [],
    this.beginnerItemIds = const [],
    this.defaultEnabledHealthyIds = const [],
    this.defaultEnabledJunkIds = const [],
    this.allHealthyIds = const [],
    this.allJunkIds = const [],
  });

  final List<String> defaultEnabledIds;
  final List<String> allSelectableIds;
  final List<String> beginnerItemIds;
  final List<String> defaultEnabledHealthyIds;
  final List<String> defaultEnabledJunkIds;
  final List<String> allHealthyIds;
  final List<String> allJunkIds;
}

/// Items, categories, modes, and labels for one sorting game.
class GameContent {
  const GameContent({
    required this.gameId,
    required this.playTitle,
    required this.categories,
    required this.items,
    this.celebrationSubtitle,
    this.categoryEmoji,
    this.modes = const [],
    this.difficulties = const [],
    this.correctLabels = const {},
    this.voiceLabels = const {},
    this.encouragements = const [],
    this.pools = const ContentPools(),
  });

  final String gameId;
  final String playTitle;
  final String? celebrationSubtitle;
  final String? categoryEmoji;
  final List<SortCategory> categories;
  final List<SortableItem> items;
  final List<ContentMode> modes;
  final List<ContentDifficulty> difficulties;
  final Map<String, String> correctLabels;
  final Map<String, String> voiceLabels;
  final List<String> encouragements;
  final ContentPools pools;

  ContentMode? modeById(String id) {
    for (final mode in modes) {
      if (mode.id == id) return mode;
    }
    return null;
  }

  ContentDifficulty? difficultyById(String id) {
    for (final difficulty in difficulties) {
      if (difficulty.id == id) return difficulty;
    }
    return null;
  }

  SortCategory? categoryById(String id) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  SortableItem? itemById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  String displayName(String id) =>
      categoryById(id)?.label ?? itemById(id)?.name ?? id;
}

/// Categories and items for a single play session.
class SortingRound {
  const SortingRound({required this.categories, required this.items});

  final List<SortCategory> categories;
  final List<SortableItem> items;
}
