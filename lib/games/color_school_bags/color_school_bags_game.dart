import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../presentation/providers/game_library.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openColorSchoolBagsGame(BuildContext context) async {
  final app = context.read<AppState>();
  final library = context.read<GameLibrary>();
  final s = app.gameSettings.colorSchoolBags;
  final c = s.common;
  final content = library.content(GameCatalog.colorSchoolBagsId);
  final round = library.matchRound(
    gameId: GameCatalog.colorSchoolBagsId,
    enabledIds: s.enabledColors,
    count: s.backpackCount,
  );
  final itemSize = c.largerTouchTargets ? 140.0 : 120.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.colorSchoolBagsId,
    categories: round.categories,
    itemPool: round.items,
    sessionSeconds: c.sessionSeconds,
    maxFloating: 1,
    speedMultiplier: 0.65,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle:
        content.celebrationSubtitle ?? "You're Becoming a Super Sorter!",
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: c.practiceMode,
    snapPadding: c.largerTouchTargets ? 64 : 48,
    itemSize: itemSize,
    bookShape: true,
    categoryEmoji: content.categoryEmoji,
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
        title: content.playTitle,
      ),
    ),
  );
}
