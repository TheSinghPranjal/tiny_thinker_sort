import '../../domain/entities/age_world.dart';
import '../../domain/entities/game_content.dart';
import '../../domain/entities/game_definition.dart';
import '../../domain/repositories/game_content_repository.dart';
import '../datasources/asset_game_json_data_source.dart';
import '../models/catalog_model.dart';
import '../models/game_content_model.dart';

class AssetGameContentRepository implements GameContentRepository {
  AssetGameContentRepository._(this._games, this._content);

  final List<GameDefinition> _games;
  final Map<String, GameContent> _content;

  static Future<AssetGameContentRepository> load({
    AssetGameJsonDataSource? source,
  }) async {
    final dataSource = source ?? const AssetGameJsonDataSource();
    final catalog = CatalogEntryModel.listFromJson(
      await dataSource.loadMap('assets/data/catalog.json'),
    );
    final content = <String, GameContent>{};
    for (final entry in catalog) {
      final path = entry.contentAsset;
      if (path == null) continue;
      content[entry.game.id] = GameContentModel.fromJson(
        await dataSource.loadMap(path),
      );
    }
    for (final entry in catalog) {
      if (entry.game.implemented && !content.containsKey(entry.game.id)) {
        throw StateError(
          'Implemented game ${entry.game.id} has no content JSON',
        );
      }
    }
    return AssetGameContentRepository._(
      catalog.map((entry) => entry.game).toList(),
      content,
    );
  }

  @override
  List<GameDefinition> get games => List.unmodifiable(_games);

  @override
  GameDefinition? byId(String id) {
    for (final game in _games) {
      if (game.id == id) return game;
    }
    return null;
  }

  @override
  List<GameDefinition> forWorld(AgeWorld world) =>
      _games.where((game) => game.ageWorld == world).toList();

  @override
  List<GameDefinition> get withParentControls => _games
      .where((game) => game.hasParentControls && game.implemented)
      .toList();

  @override
  bool hasContent(String gameId) => _content.containsKey(gameId);

  @override
  GameContent contentFor(String gameId) {
    final content = _content[gameId];
    if (content == null) {
      throw StateError('No sorting content for $gameId');
    }
    return content;
  }
}
