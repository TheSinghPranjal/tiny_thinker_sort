import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/color_school_bags_data.dart';
import '../../data/game_catalog.dart';
import '../../games/sorting_engine/sorting_engine.dart';
import '../../games/sorting_engine/sorting_play_screen.dart';
import '../../state/app_state.dart';
import '../../widgets/sortjoy_background.dart';

Future<void> openColorSchoolBagsGame(BuildContext context) async {
  final app = context.read<AppState>();
  final settings = app.settings;

  final enabledColors = settings.colorSchoolBagsEnabledColors;
  final categories = ColorSchoolBagsData.pickCategories(
    enabledColorIds: enabledColors,
    backpackCount: settings.colorSchoolBagsBackpackCount,
  );
  final itemPool = ColorSchoolBagsData.itemsForCategories(categories);

  final sessionSeconds = settings.colorSchoolBagsUnlimitedTime
      ? 0
      : (settings.colorSchoolBagsSessionSeconds > 0
          ? settings.colorSchoolBagsSessionSeconds
          : 60);

  final config = SortingEngineConfig(
    gameId: GameCatalog.colorSchoolBagsId,
    categories: categories,
    itemPool: itemPool,
    sessionSeconds: sessionSeconds,
    maxFloating: 1,
    speedMultiplier: settings.speedMultiplier * 0.65,
    voiceEnabled: settings.voiceEnabled,
    celebrationsEnabled: settings.celebrationsEnabled,
    celebrationSubtitle: "You're learning colors!",
    starsPerCorrectSort: 10,
    coinsPerCorrectSort: 10,
    celebrateEveryN: 5,
    unlimitedSession: settings.colorSchoolBagsUnlimitedTime,
    snapPadding: 48,
    itemSize: 120,
    bookShape: true,
    categoryEmoji: '🎒',
    hideCoinHud: true,
  );

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SortingPlayScreen(
        config: config,
        background: const SortJoyBackground(),
        title: 'Color School Bags',
      ),
    ),
  );
}
