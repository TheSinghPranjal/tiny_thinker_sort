import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../data/sort_socks_data.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openSortSocksGame(BuildContext context) async {
  final app = context.read<AppState>();
  final s = app.gameSettings.sortSocks;
  final c = s.common;

  final categories = SortSocksData.pickCategories(
    enabledColorIds: s.enabledColors,
    laundryBagCount: s.laundryBagCount,
  );
  final itemPool = SortSocksData.itemsForCategories(categories);
  final itemSize = c.largerTouchTargets ? 140.0 : 120.0;

  final config = SortingEngineConfig(
    gameId: GameCatalog.sortSocksId,
    categories: categories,
    itemPool: itemPool,
    sessionSeconds: c.sessionSeconds,
    maxFloating: 1,
    speedMultiplier: 0.65,
    voiceEnabled: c.narrationEnabled,
    celebrationsEnabled: c.celebrationsEnabled,
    celebrationSubtitle: "You're learning colors!",
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: c.practiceMode,
    snapPadding: c.largerTouchTargets ? 64 : 48,
    itemSize: itemSize,
    sockShape: true,
    categoryEmoji: '🧺',
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
        title: 'Sort Socks',
      ),
    ),
  );
}
