import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/clean_dirty_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../models/game_modes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openCleanDirtyGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.cleanDirty;
  final c = s.common;
  final baseSize = c.largerTouchTargets ? 96.0 : 84.0;

  final categories = CleanDirtyData.categoriesForMode(s.mode);
  final itemPool = CleanDirtyData.itemsForMode(s.mode);

  final config = SortingEngineConfig(
    gameId: GameCatalog.cleanDirtyId,
    categories: categories,
    itemPool: itemPool,
    sessionSeconds: c.sessionSeconds,
    maxFloating: s.floatingItemCount.clamp(3, 8),
    speedMultiplier: s.speed.multiplier,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle: "You're a Laundry Superstar!",
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
    correctCategoryLabels: {
      CleanDirtyData.dirtyCategoryId: 'All Clean!',
      CleanDirtyData.cleanCategoryId: 'Neatly Stored!',
    },
    categoryVoiceLabels: {
      CleanDirtyData.dirtyCategoryId: 'Into the wash!',
      CleanDirtyData.cleanCategoryId: 'Into the cupboard!',
    },
    encouragements: const [
      'Great Job!',
      'Wonderful!',
      'Fantastic!',
      'Amazing!',
      'Excellent!',
      'Nice Sorting!',
      'Super Helper!',
      "You're Amazing!",
      'Awesome!',
      'Laundry Hero!',
      'Sparkling Clean!',
      'Keep Going!',
      'Brilliant!',
      'Perfect Choice!',
    ],
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const AppBackground(),
        title: 'Clean & Dirty Clothes',
      ),
    ),
  );
}
