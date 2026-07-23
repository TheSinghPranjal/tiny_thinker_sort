import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/flower_garden_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/sortjoy_background.dart';

Future<void> openFlowerGardenGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;

  final enabledColors = settings.flowerGardenEnabledColors;
  final categories = FlowerGardenData.pickCategories(
    enabledColorIds: enabledColors,
    potCount: settings.flowerGardenPotCount,
  );
  final itemPool = FlowerGardenData.itemsForCategories(categories);

  final sessionSeconds = settings.flowerGardenUnlimitedTime
      ? 0
      : (settings.flowerGardenSessionSeconds > 0
          ? settings.flowerGardenSessionSeconds
          : 60);

  final config = SortingEngineConfig(
    gameId: GameCatalog.flowerGardenId,
    categories: categories,
    itemPool: itemPool,
    sessionSeconds: sessionSeconds,
    maxFloating: 1,
    speedMultiplier: settings.speedMultiplier * 0.6,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
    celebrationSubtitle: 'What a beautiful garden!',
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 6,
    unlimitedSession: settings.flowerGardenUnlimitedTime,
    snapPadding: 52,
    itemSize: 132,
    flowerShape: true,
    flowerPotShape: true,
    hideCoinHud: true,
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const SortJoyBackground(),
        title: 'Flower Garden',
      ),
    ),
  );
}
