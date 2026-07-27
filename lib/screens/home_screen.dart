import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_catalog.dart';
import '../models/age_world.dart';
import '../models/game_definition.dart';
import '../state/app_state.dart';
import '../data/game_card_assets.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/game_card.dart';
import '../widgets/sortjoy_logo.dart';
import '../widgets/switch_button.dart';
import 'game_setup_screen.dart';
import 'parent_zone_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final world = app.ageWorld ?? AgeWorld.tinyLearners;
    final games = GameCatalog.forWorld(world);

    return GradientScaffold(
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SortJoyLogo(height: 40),
                          SizedBox(height: 4),
                          Text(
                            'Sparkles, smiles, zero scolding',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: SortJoyColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RewardPill(
                      emoji: '🪙',
                      value: '${app.rewards.coins}',
                    ),
                    const SizedBox(width: 8),
                    _RewardPill(
                      emoji: '⭐',
                      value: '${app.rewards.stars}',
                    ),
                    IconButton(
                      tooltip: 'Parent Zone',
                      onPressed: () => _openParentGate(context),
                      icon: const Icon(Icons.family_restroom_rounded),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(world.emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              world.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${world.ageLabel} · streak ${app.rewards.dailyStreak}🔥',
                              style: const TextStyle(
                                color: SortJoyColors.inkSoft,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SwitchButton(
                        onPressed: () => _openParentGate(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LearningPathCard(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Games',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final isTablet = width >= 700;
                  final crossAxisCount = isTablet ? 4 : 2;
                  final spacing = isTablet ? 16.0 : 14.0;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 22,
                      crossAxisSpacing: spacing,
                      // Taller cells so image + 2-line title/subtitle fit.
                      childAspectRatio: isTablet ? 0.72 : 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _GameCard(game: games[index]),
                      childCount: games.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openParentGate(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ParentZoneScreen()),
    );
  }
}

class _LearningPathCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SortJoyColors.berry.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [SortJoyColors.lavender, SortJoyColors.berry],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Row(
          children: [
            const Text('🗺', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort Journey',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Guided path through your age world',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Premium\ncoming soon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final GameDefinition game;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final remaining = app.remainingPlays(game.id);

    final badge = !game.implemented
        ? 'Soon'
        : app.settings.isPremium
            ? ''
            : '$remaining left';

    return PressableGameCard(
      image: GameCardAssets.imageFor(game.id),
      title: game.title,
      subtitle: game.subtitle,
      badge: badge,
      badgeColor: GameCardAssets.badgeColorFor(game.id),
      titleColor: GameCardAssets.titleColorFor(game.id),
      placeholderEmoji: game.emoji,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GameSetupScreen(game: game)),
        );
      },
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.emoji, required this.value});

  final String emoji;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

