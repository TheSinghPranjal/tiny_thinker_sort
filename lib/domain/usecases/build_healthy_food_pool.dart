import '../entities/game_content.dart';
import '../entities/sortable_item.dart';

/// Builds the healthy/junk item pool for the selected difficulty.
class BuildHealthyFoodPool {
  const BuildHealthyFoodPool();

  List<SortableItem> call({
    required GameContent content,
    required List<String> enabledHealthyIds,
    required List<String> enabledJunkIds,
    required String difficultyId,
  }) {
    final difficulty = content.difficultyById(difficultyId);
    if (difficulty?.useBeginnerSet ?? difficultyId == 'beginner') {
      final ids = content.pools.beginnerItemIds.toSet();
      return content.items
          .where((item) => ids.contains(item.id))
          .toList(growable: false);
    }

    final healthyPool = _filter(enabledHealthyIds, content.pools.allHealthyIds);
    final junkPool = _filter(enabledJunkIds, content.pools.allJunkIds);
    final healthyCount = difficulty?.healthyCount ?? healthyPool.length;
    final junkCount = difficulty?.junkCount ?? junkPool.length;
    final healthy = healthyPool.take(healthyCount.clamp(0, healthyPool.length));
    final junk = junkPool.take(junkCount.clamp(0, junkPool.length));
    return [
      for (final id in healthy) content.itemById(id)!,
      for (final id in junk) content.itemById(id)!,
    ];
  }

  List<String> _filter(List<String> enabled, List<String> allIds) {
    final set = enabled.toSet();
    return allIds.where(set.contains).toList(growable: false);
  }
}
