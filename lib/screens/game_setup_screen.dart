import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_catalog.dart';
import '../games/big_small/big_small_game.dart';
import '../games/clean_dirty/clean_dirty_game.dart';
import '../games/color_school_bags/color_school_bags_game.dart';
import '../games/flower_garden/flower_garden_game.dart';
import '../games/healthy_food/healthy_food_game.dart';
import '../games/color_sort/color_sort_game.dart';
import '../games/fruit_veg/fruit_veg_game.dart';
import '../games/indoor_outdoor/indoor_outdoor_game.dart';
import '../games/sort_socks/sort_socks_game.dart';
import '../models/game_definition.dart';
import '../models/rewards.dart';
import '../state/app_state.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';

class GameSetupScreen extends StatelessWidget {
  const GameSetupScreen({super.key, required this.game});

  final GameDefinition game;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final remaining = app.remainingPlays(game.id);
    final canPlay = game.implemented && app.canPlayGame(game.id);

    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              const Spacer(),
              Text(game.emoji, textAlign: TextAlign.center, style: const TextStyle(fontSize: 88)),
              const SizedBox(height: 12),
              Text(
                game.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                game.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: SortJoyColors.inkSoft,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: game.skills
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        backgroundColor: SortJoyColors.mint.withValues(alpha: 0.2),
                        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  late final String message;
                  if (!game.implemented) {
                    message = 'This sorting adventure is almost ready!';
                  } else if (!app.settings.isPremium) {
                    message =
                        '$remaining of ${RewardsState.freePlaysPerGame} free plays left today';
                  } else {
                    final common = app.gameSettings.commonFor(game.id);
                    message = common.practiceMode
                        ? 'Unlimited practice · no timer'
                        : 'Unlimited play · ${common.sessionSeconds}s sessions';
                  }
                  return Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: SortJoyColors.inkSoft,
                    ),
                  );
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: !canPlay
                    ? null
                    : () async {
                        if (game.id == GameCatalog.fruitVegId) {
                          await openFruitVegGame(context);
                        } else if (game.id == GameCatalog.indoorOutdoorId) {
                          await openIndoorOutdoorGame(context);
                        } else if (game.id == GameCatalog.colorSortId) {
                          await openColorSortGame(context);
                        } else if (game.id == GameCatalog.bigSmallId) {
                          await openBigSmallGame(context);
                        } else if (game.id == GameCatalog.colorSchoolBagsId) {
                          await openColorSchoolBagsGame(context);
                        } else if (game.id == GameCatalog.sortSocksId) {
                          await openSortSocksGame(context);
                        } else if (game.id == GameCatalog.flowerGardenId) {
                          await openFlowerGardenGame(context);
                        } else if (game.id == GameCatalog.healthyFoodId) {
                          await openHealthyFoodGame(context);
                        } else if (game.id == GameCatalog.cleanDirtyId) {
                          await openCleanDirtyGame(context);
                        }
                      },
                child: Text(game.implemented ? 'Play' : 'Coming Soon'),
              ),
              if (game.implemented && !canPlay) ...[
                const SizedBox(height: 8),
                Text(
                  'Free play limit reached. Premium unlocks unlimited sorting!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SortJoyColors.coral.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
