import '../entities/game_content.dart';

/// Filters a game's items and drop zones for a parent-selected mode.
class ResolveSortingRound {
  const ResolveSortingRound();

  SortingRound call(GameContent content, String modeId) {
    final mode = content.modeById(modeId) ??
        (content.modes.isEmpty ? null : content.modes.first);
    final ids = mode == null || mode.categoryIds.isEmpty
        ? content.categories.map((c) => c.id).toSet()
        : mode.categoryIds.toSet();
    return SortingRound(
      categories: content.categories.where((c) => ids.contains(c.id)).toList(),
      items: content.items.where((i) => ids.contains(i.categoryId)).toList(),
    );
  }
}
