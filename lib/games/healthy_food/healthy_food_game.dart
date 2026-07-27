import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../data/healthy_food_data.dart';
import '../../widgets/app_background.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';

Future<void> openHealthyFoodGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.healthyFood;
  final c = s.common;

  final itemPool = HealthyFoodData.itemsForSettings(
    enabledHealthyIds: s.enabledHealthyIds,
    enabledJunkIds: s.enabledJunkIds,
    difficulty: s.difficulty,
  );
  final itemSize = c.largerTouchTargets ? 150.0 : 132.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.healthyFoodId,
    categories: HealthyFoodData.categories,
    itemPool: itemPool,
    sessionSeconds: c.sessionSeconds,
    maxFloating: 1,
    speedMultiplier: 0.55,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle: 'You know healthy and junk food!',
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: c.practiceMode,
    snapPadding: c.largerTouchTargets ? 72 : 56,
    itemSize: itemSize,
    foodBubbleShape: true,
    toddlerZones: true,
    wrongDropMessage: 'Not this one!',
    correctCategoryLabels: {
      HealthyFoodData.healthyCategoryId:
          HealthyFoodData.resultLabelFor(HealthyFoodData.healthyCategoryId),
      HealthyFoodData.junkCategoryId:
          HealthyFoodData.resultLabelFor(HealthyFoodData.junkCategoryId),
    },
    categoryVoiceLabels: {
      HealthyFoodData.healthyCategoryId:
          HealthyFoodData.categoryLabelFor(HealthyFoodData.healthyCategoryId),
      HealthyFoodData.junkCategoryId:
          HealthyFoodData.categoryLabelFor(HealthyFoodData.junkCategoryId),
    },
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
        title: 'Learn to Sort',
      ),
    ),
  );
}
