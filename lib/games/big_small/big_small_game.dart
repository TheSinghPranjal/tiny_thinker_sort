import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/big_small_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../models/game_modes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openBigSmallGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.bigSmall;
  final c = s.common;
  final baseSize = c.largerTouchTargets ? 90.0 : 72.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.bigSmallId,
    categories: BigSmallData.categoriesForMode(s.mode),
    itemPool: BigSmallData.itemsForMode(s.mode),
    sessionSeconds: c.sessionSeconds,
    maxFloating: s.floatingItemCount.clamp(2, 8),
    speedMultiplier: s.speed.multiplier,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle: "You're Becoming a Size Expert!",
    unlimitedSession: c.practiceMode,
    itemSize: baseSize,
    snapPadding: c.largerTouchTargets ? 24 : 0,
    soundEnabled: c.soundEnabled,
    musicEnabled: c.musicEnabled,
    coinRewardsEnabled: c.coinRewardsEnabled,
    hapticsEnabled: c.hapticsEnabled,
    leftHandedLayout: c.leftHandedLayout,
    largerTouchTargets: c.largerTouchTargets,
    reducedMotion: c.reducedMotion,
    floatingAnimation: s.floatingAnimation,
    rewardMultiplier: c.rewardMultiplier,
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const AppBackground(),
        title: 'Big & Small Sort',
      ),
    ),
  );
}
