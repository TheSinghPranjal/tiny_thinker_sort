import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/flower_garden_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openFlowerGardenGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.flowerGarden;
  final c = s.common;

  final categories = FlowerGardenData.pickCategories(
    enabledColorIds: s.enabledColors,
    potCount: s.potCount,
  );
  final itemPool = FlowerGardenData.itemsForCategories(categories);
  final itemSize = c.largerTouchTargets ? 150.0 : 132.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.flowerGardenId,
    categories: categories,
    itemPool: itemPool,
    sessionSeconds: c.sessionSeconds,
    maxFloating: 1,
    speedMultiplier: 0.6,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle: 'What a beautiful garden!',
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 6,
    unlimitedSession: c.practiceMode,
    snapPadding: c.largerTouchTargets ? 68 : 52,
    itemSize: itemSize,
    flowerShape: true,
    flowerPotShape: true,
    hideCoinHud: true,
    soundEnabled: c.soundEnabled,
    musicEnabled: c.musicEnabled,
    coinRewardsEnabled: c.coinRewardsEnabled,
    hapticsEnabled: c.hapticsEnabled,
    leftHandedLayout: c.leftHandedLayout,
    largerTouchTargets: c.largerTouchTargets,
    reducedMotion: c.reducedMotion,
    rewardMultiplier: c.rewardMultiplier,
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const AppBackground(),
        title: 'Flower Garden',
      ),
    ),
  );
}
