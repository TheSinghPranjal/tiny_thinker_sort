import '../entities/age_world.dart';
import '../entities/game_content.dart';
import '../entities/game_definition.dart';

/// Loads catalog entries and per-game sorting content.
abstract class GameContentRepository {
  List<GameDefinition> get games;

  GameDefinition? byId(String id);

  List<GameDefinition> forWorld(AgeWorld world);

  List<GameDefinition> get withParentControls;

  bool hasContent(String gameId);

  GameContent contentFor(String gameId);
}
