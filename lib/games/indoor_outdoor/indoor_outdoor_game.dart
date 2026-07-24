import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/game_catalog.dart';
import '../../data/indoor_outdoor_data.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/app_background.dart';

Future<void> openIndoorOutdoorGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;
  final config = SortingEngineConfig(
    gameId: GameCatalog.indoorOutdoorId,
    categories: IndoorOutdoorData.categoriesForMode(settings.indoorOutdoorMode),
    itemPool: IndoorOutdoorData.itemsForMode(settings.indoorOutdoorMode),
    sessionSeconds: settings.sessionSeconds,
    maxFloating: settings.floatingItemCount.clamp(2, 8),
    speedMultiplier: settings.speedMultiplier,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
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
