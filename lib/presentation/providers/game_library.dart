import '../../domain/entities/age_world.dart';
import '../../domain/entities/game_content.dart';
import '../../domain/entities/game_definition.dart';
import '../../domain/entities/sortable_item.dart';
import '../../domain/repositories/game_content_repository.dart';
import '../../domain/usecases/build_healthy_food_pool.dart';
import '../../domain/usecases/pick_match_categories.dart';
import '../../domain/usecases/resolve_sorting_round.dart';

/// Presentation-facing access to catalog content and sorting use cases.
class GameLibrary {
  GameLibrary(this.repository);

  final GameContentRepository repository;
  final ResolveSortingRound _rounds = const ResolveSortingRound();
  final PickMatchCategories _match = const PickMatchCategories();
  final BuildHealthyFoodPool _healthy = const BuildHealthyFoodPool();

  List<GameDefinition> gamesFor(AgeWorld world) => repository.forWorld(world);

  List<GameDefinition> get gamesWithParentControls =>
      repository.withParentControls;

  GameContent content(String gameId) => repository.contentFor(gameId);

  SortingRound roundFor(String gameId, String modeId) =>
      _rounds(content(gameId), modeId);

  SortingRound matchRound({
    required String gameId,
    required List<String> enabledIds,
    required int count,
  }) => _match(content: content(gameId), enabledIds: enabledIds, count: count);

  List<SortableItem> healthyItems({
    required List<String> enabledHealthyIds,
    required List<String> enabledJunkIds,
    required String difficultyId,
    String gameId = healthyFoodGameId,
  }) => _healthy(
    content: content(gameId),
    enabledHealthyIds: enabledHealthyIds,
    enabledJunkIds: enabledJunkIds,
    difficultyId: difficultyId,
  );

  static const healthyFoodGameId = 'healthy_junk_food_sort';
}
