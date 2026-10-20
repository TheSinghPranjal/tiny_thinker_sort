import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../presentation/providers/game_library.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openHealthyFoodGame(BuildContext context) async {
  final app = context.read<AppState>();
  final library = context.read<GameLibrary>();
  final s = app.gameSettings.healthyFood;
  final c = s.common;
  final content = library.content(GameCatalog.healthyFoodId);
  final itemPool = library.healthyItems(
    enabledHealthyIds: s.enabledHealthyIds,
    enabledJunkIds: s.enabledJunkIds,
    difficultyId: s.difficulty.name,
  );
  final itemSize = c.largerTouchTargets ? 150.0 : 132.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.healthyFoodId,
    categories: content.categories,
    itemPool: itemPool,
    sessionSeconds: c.sessionSeconds,
    maxFloating: 1,
    speedMultiplier: 0.55,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle:
        content.celebrationSubtitle ?? "You're Becoming a Super Sorter!",
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: c.practiceMode,
    snapPadding: c.largerTouchTargets ? 72 : 56,
    itemSize: itemSize,
    foodBubbleShape: true,
    toddlerZones: true,
    wrongDropMessage: 'Not this one!',
    correctCategoryLabels: content.correctLabels,
    categoryVoiceLabels: content.voiceLabels,
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
        title: content.playTitle,
      ),
    ),
  );
}
