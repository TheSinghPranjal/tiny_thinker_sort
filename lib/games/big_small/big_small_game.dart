import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/big_small_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import 'learning_park_background.dart';

Future<void> openBigSmallGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;
  final config = SortingEngineConfig(
    gameId: GameCatalog.bigSmallId,
    categories: BigSmallData.categoriesForMode(settings.bigSmallMode),
    itemPool: BigSmallData.itemsForMode(settings.bigSmallMode),
    sessionSeconds: settings.sessionSeconds,
    maxFloating: settings.floatingItemCount.clamp(2, 8),
    speedMultiplier: settings.speedMultiplier,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
    celebrationSubtitle: "You're Becoming a Size Expert!",
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const LearningParkBackground(),
        title: 'Big & Small Sort',
      ),
    ),
  );
}
