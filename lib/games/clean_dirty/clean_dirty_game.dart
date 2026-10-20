import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../models/game_modes.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../presentation/providers/game_library.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openCleanDirtyGame(BuildContext context) async {
  final app = context.read<AppState>();
  final library = context.read<GameLibrary>();
  final s = app.gameSettings.cleanDirty;
  final c = s.common;
  final content = library.content(GameCatalog.cleanDirtyId);
  final round = library.roundFor(GameCatalog.cleanDirtyId, s.mode.name);
  final baseSize = c.largerTouchTargets ? 96.0 : 84.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.cleanDirtyId,
    categories: round.categories,
    itemPool: round.items,
    sessionSeconds: c.sessionSeconds,
    maxFloating: s.floatingItemCount.clamp(3, 8),
    speedMultiplier: s.speed.multiplier,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle:
        content.celebrationSubtitle ?? "You're Becoming a Super Sorter!",
    unlimitedSession: c.practiceMode,
    itemSize: baseSize,
    snapPadding: c.largerTouchTargets ? 36 : 20,
    soundEnabled: c.soundEnabled,
    musicEnabled: c.musicEnabled,
    coinRewardsEnabled: c.coinRewardsEnabled,
    hapticsEnabled: c.hapticsEnabled,
    leftHandedLayout: c.leftHandedLayout,
    largerTouchTargets: c.largerTouchTargets,
    reducedMotion: c.reducedMotion,
    floatingAnimation: s.floatingAnimation,
    rewardMultiplier: c.rewardMultiplier,
    laundryZones: true,
    clothesChipShape: true,
    bubbleEffects: s.bubbleEffects,
    respawnDelayMs: 1000,
    celebrateEveryN: 5,
    correctCategoryLabels: content.correctLabels,
    categoryVoiceLabels: content.voiceLabels,
    encouragements: content.encouragements,
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
