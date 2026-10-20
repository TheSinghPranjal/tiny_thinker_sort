import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../models/game_modes.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../presentation/providers/game_library.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openFruitVegGame(BuildContext context) async {
  final app = context.read<AppState>();
  final library = context.read<GameLibrary>();
  final s = app.gameSettings.fruitVeg;
  final c = s.common;
  final content = library.content(GameCatalog.fruitVegId);
  final round = library.roundFor(GameCatalog.fruitVegId, s.mode.name);
  final baseSize = c.largerTouchTargets ? 124.0 : 106.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.fruitVegId,
    categories: round.categories,
    itemPool: round.items,
    sessionSeconds: c.sessionSeconds,
    maxFloating: s.floatingItemCount.clamp(2, 8),
    speedMultiplier: s.speed.multiplier,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    unlimitedSession: c.practiceMode,
    itemSize: baseSize,
    snapPadding: c.largerTouchTargets ? 32 : 16,
    soapBubbleShape: true,
    wickerBasketZones: true,
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
        title: content.playTitle,
      ),
    ),
  );
}
