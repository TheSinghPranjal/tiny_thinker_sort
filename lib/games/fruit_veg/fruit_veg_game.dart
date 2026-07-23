import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/fruit_veg_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import 'farm_background.dart';

Future<void> openFruitVegGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;
  final config = SortingEngineConfig(
    gameId: GameCatalog.fruitVegId,
    categories: FruitVegData.categoriesForMode(settings.fruitVegMode),
    itemPool: FruitVegData.itemsForMode(settings.fruitVegMode),
    sessionSeconds: settings.sessionSeconds,
    maxFloating: settings.floatingItemCount.clamp(2, 8),
    speedMultiplier: settings.speedMultiplier,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const FarmBackground(),
        title: 'Fruit & Vegetable Sort',
      ),
    ),
  );
}
