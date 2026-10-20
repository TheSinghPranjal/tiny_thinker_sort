import 'dart:math';

import '../entities/game_content.dart';

/// Picks a random subset of color categories for one matching session.
class PickMatchCategories {
  const PickMatchCategories();

  SortingRound call({
    required GameContent content,
    required List<String> enabledIds,
    required int count,
    Random? random,
  }) {
    final rng = random ?? Random();
    final known = content.categories.map((c) => c.id).toSet();
    final enabled = enabledIds.where(known.contains).toList();
    final pool = enabled.length >= 2
        ? List<String>.from(enabled)
        : List<String>.from(content.pools.defaultEnabledIds);
    pool.shuffle(rng);
    final take = count.clamp(2, pool.length);
    final categories = pool
        .take(take)
        .map((id) => content.categoryById(id)!)
        .toList();
    final ids = categories.map((c) => c.id).toSet();
    return SortingRound(
      categories: categories,
      items: content.items.where((i) => ids.contains(i.categoryId)).toList(),
    );
  }
}
