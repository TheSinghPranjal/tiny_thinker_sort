import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../data/indoor_outdoor_data.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../models/game_modes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openIndoorOutdoorGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.indoorOutdoor;
  final c = s.common;
  final baseSize = c.largerTouchTargets ? 90.0 : 72.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.indoorOutdoorId,
    categories: IndoorOutdoorData.categoriesForMode(s.mode),
    itemPool: IndoorOutdoorData.itemsForMode(s.mode),
    sessionSeconds: c.sessionSeconds,
    maxFloating: s.floatingItemCount.clamp(2, 8),
    speedMultiplier: s.speed.multiplier,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
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
        title: 'Indoor & Outdoor Games Sort',
      ),
    ),
  );
}
