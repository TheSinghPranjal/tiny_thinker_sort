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
  final settings = app.settings;

  final itemPool = HealthyFoodData.itemsForSettings(
    enabledHealthyIds: settings.healthyFoodEnabledHealthyIds,
    enabledJunkIds: settings.healthyFoodEnabledJunkIds,
    difficulty: settings.healthyFoodDifficulty,
  );

  final sessionSeconds = settings.healthyFoodUnlimitedTime
      ? 0
      : (settings.healthyFoodSessionSeconds > 0
          ? settings.healthyFoodSessionSeconds
          : 60);

  final config = SortingEngineConfig(
    gameId: GameCatalog.healthyFoodId,
    categories: HealthyFoodData.categories,
    itemPool: itemPool,
    sessionSeconds: sessionSeconds,
    maxFloating: 1,
    speedMultiplier: settings.speedMultiplier * 0.55,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
    celebrationSubtitle: 'You know healthy and junk food!',
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: settings.healthyFoodUnlimitedTime,
    snapPadding: 56,
    itemSize: 132,
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
