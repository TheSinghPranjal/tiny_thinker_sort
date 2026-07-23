import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/color_sort_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/sortjoy_background.dart';

Future<void> openColorSortGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;
  final config = SortingEngineConfig(
    gameId: GameCatalog.colorSortId,
    categories: ColorSortData.categoriesForMode(settings.colorSortMode),
    itemPool: ColorSortData.itemsForMode(settings.colorSortMode),
    sessionSeconds: settings.sessionSeconds,
    maxFloating: settings.floatingItemCount.clamp(2, 8),
    speedMultiplier: settings.speedMultiplier,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
    celebrationSubtitle: "You're Becoming a Color Expert!",
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const SortJoyBackground(),
        title: 'Color Sort',
      ),
    ),
  );
}
