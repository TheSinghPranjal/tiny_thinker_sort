import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_catalog.dart';
import '../models/age_world.dart';
import '../models/game_definition.dart';
import '../state/app_state.dart';
import '../data/game_card_assets.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/clay_surface.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/game_card.dart';
import '../widgets/sortjoy_logo.dart';
import '../widgets/switch_button.dart';
import 'game_setup_screen.dart';
import 'parent_zone_screen.dart';

/// Navy used for header copy and headings.
const _navy = Color(0xFF1F2F55);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final world = app.ageWorld ?? AgeWorld.tinyLearners;
    final games = GameCatalog.forWorld(world);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return GradientScaffold(
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    coins: app.rewards.coins,
                    stars: app.rewards.stars,
                    onParent: () => _openParentGate(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: _AgeWorldCard(
                      world: world,
                      streak: app.currentStreak,
                      onSwitch: () => _openParentGate(context),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: _LearningPathCard(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 22, 20, 12),
                    child: Row(
                      children: [
                        Text(
                          'Games',
                          style: TextStyle(
                            fontSize: 32,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('🍃', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  // Room for the floating nav bar.
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 120 + bottomInset),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final isTablet = width >= 700;
                      final crossAxisCount = isTablet ? 4 : 2;

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 18,
                          crossAxisSpacing: 16,
                          // Image well + 2-line title + 2-line subtitle.
                          childAspectRatio: isTablet ? 0.78 : 0.74,
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
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset + 12,
            child: _HomeNavBar(
              onJourney: () => _showSoon(context),
              onRewards: () => _showRewards(context, app),
              onParent: () => _openParentGate(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openParentGate(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ParentZoneScreen()));
  }

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 120),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: SortJoyColors.lavender,
          content: const Text(
            'Sort Journey is coming soon! 🗺️',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      );
  }

  void _showRewards(BuildContext context, AppState app) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RewardsSheet(app: app),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.coins,
    required this.stars,
    required this.onParent,
  });

  final int coins;
  final int stars;
  final VoidCallback onParent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SortJoyLogo(height: 60),
                SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Sparkles, smiles, '),
                        TextSpan(
                          text: 'zero scolding',
                          style: TextStyle(color: Color(0xFF2F7BEA)),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _RewardPill(icon: const _CoinIcon(), value: '$coins'),
          const SizedBox(width: 8),
          _RewardPill(
            icon: const Text('⭐', style: TextStyle(fontSize: 18)),
            value: '$stars',
          ),
          const SizedBox(width: 8),
          _ParentButton(onTap: onParent),
        ],
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.icon, required this.value});

  final Widget icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFFFFF6E3),
      radius: 999,
      depth: 0.4,
      padding: const EdgeInsets.fromLTRB(8, 5, 12, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold coin with an inner rim — matches the reward HUD art.
class _CoinIcon extends StatelessWidget {
  const _CoinIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE27A), Color(0xFFF2A900)],
        ),
        border: Border.all(color: const Color(0xFFD98E00), width: 1.4),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 11,
        height: 11,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFF3B8), width: 1.6),
        ),
      ),
    );
  }
}

class _ParentButton extends StatelessWidget {
  const _ParentButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Parent Zone',
      child: GestureDetector(
        onTap: onTap,
        child: const SizedBox(
          width: 50,
          height: 50,
          child: ClaySurface(
            color: Colors.white,
            radius: 25,
            depth: 0.45,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.family_restroom_rounded,
                    color: _navy,
                    size: 28,
                  ),
                ),
                Positioned(
                  right: 7,
                  bottom: 7,
                  child: Icon(
                    Icons.lock_rounded,
                    color: Color(0xFFF2A900),
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero cards
// ---------------------------------------------------------------------------

class _AgeWorldCard extends StatelessWidget {
  const _AgeWorldCard({
    required this.world,
    required this.streak,
    required this.onSwitch,
  });

  final AgeWorld world;
  final int streak;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFFFDF1DE),
      radius: 30,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      child: Row(
        children: [
          Text(world.emoji, style: const TextStyle(fontSize: 46)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    world.title,
                    style: const TextStyle(
                      fontSize: 25,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      color: SortJoyColors.ink,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${world.ageLabel} · Streak $streak🔥',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      color: SortJoyColors.inkSoft,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SwitchButton(onPressed: onSwitch),
        ],
      ),
    );
  }
}

class _LearningPathCard extends StatelessWidget {
  const _LearningPathCard();

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFF9B6BFA),
      radius: 30,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        children: [
          const Text('🗺️', style: TextStyle(fontSize: 56)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort Journey',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    height: 1.15,
                    shadows: [
                      Shadow(
                        color: Color(0x40311A80),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Guided path through your age world',
                  style: TextStyle(
                    color: Color(0xFFF3ECFF),
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('👑', style: TextStyle(fontSize: 18)),
                SizedBox(width: 6),
                Text(
                  'Premium\ncoming soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Games grid
// ---------------------------------------------------------------------------

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
      playable: game.implemented,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => GameSetupScreen(game: game)));
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom navigation
// ---------------------------------------------------------------------------

class _HomeNavBar extends StatelessWidget {
  const _HomeNavBar({
    required this.onJourney,
    required this.onRewards,
    required this.onParent,
  });

  final VoidCallback onJourney;
  final VoidCallback onRewards;
  final VoidCallback onParent;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFFFBF7EC),
      radius: 32,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Expanded(
            child: _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: true,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.map_outlined,
              label: 'Journey',
              onTap: onJourney,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.star_outline_rounded,
              label: 'Rewards',
              onTap: onRewards,
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.settings_rounded,
              label: 'Parent',
              onTap: onParent,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  static const _active = Color(0xFF2F7BEA);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _active : const Color(0xFF4A5568);
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 30),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: selected
            ? ClaySurface(
                color: const Color(0xFFDDEEFF),
                radius: 24,
                depth: 0.3,
                child: content,
              )
            : content,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rewards sheet
// ---------------------------------------------------------------------------

class _RewardsSheet extends StatelessWidget {
  const _RewardsSheet({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    final r = app.rewards;
    final stats = [
      ('🌱', 'Level', '${app.profileLevel}'),
      ('🪙', 'Coins', '${r.coins}'),
      ('⭐', 'Stars', '${r.stars}'),
      ('✨', 'XP', '${r.xp}'),
      ('🔥', 'Streak', '${app.currentStreak}'),
      ('🏅', 'Badges', '${r.badges.length}'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClaySurface(
          color: const Color(0xFFFFF8EC),
          radius: 32,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My Rewards',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: [
                  for (final (emoji, label, value) in stats)
                    ClaySurface(
                      color: Colors.white,
                      radius: 22,
                      depth: 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 26)),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 20,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: SortJoyColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (r.badges.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final b in r.badges)
                      Chip(
                        avatar: const Text('🏅'),
                        label: Text(_badgeLabel(b)),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _badgeLabel(String id) => switch (id) {
    'sorter_5' => 'Super Sorter',
    'sorter_15' => 'Sorting Star',
    'streak_5' => 'Hot Streak',
    'daily_3' => '3-Day Sparkle',
    'coins_100' => 'Coin Collector',
    _ => id,
  };
}
