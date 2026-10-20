import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_card_assets.dart';
import '../data/game_catalog.dart';
import '../games/big_small/big_small_game.dart';
import '../games/clean_dirty/clean_dirty_game.dart';
import '../games/color_school_bags/color_school_bags_game.dart';
import '../games/flower_garden/flower_garden_game.dart';
import '../games/healthy_food/healthy_food_game.dart';
import '../games/color_sort/color_sort_game.dart';
import '../games/fruit_veg/fruit_veg_game.dart';
import '../games/indoor_outdoor/indoor_outdoor_game.dart';
import '../games/pet_wild/pet_wild_game.dart';
import '../games/sort_socks/sort_socks_game.dart';
import '../models/game_definition.dart';
import '../models/game_duration.dart';
import '../models/rewards.dart';
import '../state/app_state.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/clay_surface.dart';
import '../widgets/gradient_scaffold.dart';

class GameSetupScreen extends StatelessWidget {
  const GameSetupScreen({super.key, required this.game});

  final GameDefinition game;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final remaining = app.remainingPlays(game.id);
    final canPlay = game.implemented && app.canPlayGame(game.id);

    late final String playsMessage;
    if (!game.implemented) {
      playsMessage = 'This sorting adventure is almost ready!';
    } else if (!app.settings.isPremium) {
      playsMessage =
          '$remaining of ${RewardsState.freePlaysPerGame} free plays left today';
    } else {
      final common = app.gameSettings.commonFor(game.id);
      playsMessage = common.practiceMode
          ? 'Unlimited practice · no timer'
          : 'Unlimited play · ${GameDuration.label(common.sessionSeconds)} sessions';
    }

    return GradientScaffold(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _BackButton(onTap: () => Navigator.pop(context)),
                      ),
                      _Hero(
                        emoji: game.emoji,
                        width: constraints.maxWidth - 40,
                      ),
                      _TitleCard(game: game),
                      const SizedBox(height: 22),
                      _SkillTiles(
                        skills: game.skills,
                        width: constraints.maxWidth - 40,
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: _PlaysPill(
                          message: playsMessage,
                          showTicket: game.implemented,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      _PlayButton(
                        label: game.implemented ? 'Play' : 'Coming Soon',
                        enabled: canPlay,
                        onTap: () => _launch(context),
                      ),
                      if (game.implemented && !canPlay) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Free play limit reached. Premium unlocks unlimited sorting!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: SortJoyColors.coral.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch(BuildContext context) async {
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
    } else if (game.id == GameCatalog.healthyFoodId ||
        game.id == GameCatalog.healthyTreatsId) {
      await openHealthyFoodGame(context, gameId: game.id);
    } else if (game.id == GameCatalog.cleanDirtyId) {
      await openCleanDirtyGame(context);
    } else if (game.id == GameCatalog.animalSortId) {
      await openPetWildGame(context);
    }
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        onTap: onTap,
        child: const SizedBox(
          width: 54,
          height: 54,
          child: ClaySurface(
            color: Color(0xFFFFF8EC),
            radius: 27,
            depth: 0.45,
            child: Center(
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F6E6A),
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Big glowing game emoji with gently floating sparkles, leaves and hearts.
class _Hero extends StatefulWidget {
  const _Hero({required this.emoji, required this.width});

  final String emoji;

  /// Content width — passed in because LayoutBuilder can't sit under the
  /// screen's IntrinsicHeight.
  final double width;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  // (emoji, x as fraction of width, y in px, size, phase)
  static const _decor = [
    ('✨', 0.22, 40.0, 26.0, 0.0),
    ('🍃', 0.12, 120.0, 30.0, 1.2),
    ('🍃', 0.20, 70.0, 22.0, 2.1),
    ('🍃', 0.88, 52.0, 28.0, 2.7),
    ('✨', 0.72, 150.0, 18.0, 0.9),
    ('✨', 0.90, 140.0, 16.0, 2.4),
    ('✨', 0.30, 160.0, 14.0, 1.5),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _bob.stop();
    } else if (!_bob.isAnimating) {
      _bob.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Builder(
        builder: (context) {
          final w = widget.width;
          return AnimatedBuilder(
            animation: _bob,
            builder: (context, _) {
              final t = Curves.easeInOut.transform(_bob.value);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Warm glow behind the hero.
                  Center(
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.95),
                            const Color(0xFFFFF59D).withValues(alpha: 0.55),
                            const Color(0xFFFFF59D).withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                  for (final (e, fx, y, size, phase) in _decor)
                    Positioned(
                      left: w * fx - size / 2,
                      top: y + sin(t * pi + phase) * 6,
                      child: Text(e, style: TextStyle(fontSize: size)),
                    ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, -6 + t * 10),
                      child: Text(
                        widget.emoji,
                        style: TextStyle(
                          fontSize: 120,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 18,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Cream clay plaque with an outlined two-tone title and flower corners.
class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.game});

  final GameDefinition game;

  static const _accent = Color(0xFFE07A12);

  @override
  Widget build(BuildContext context) {
    final mainColor = GameCardAssets.titleColorFor(game.id);
    final words = game.title.split(' ');
    final head = words.length > 1
        ? '${words.sublist(0, words.length - 1).join(' ')} '
        : game.title;
    final tail = words.length > 1 ? words.last : '';

    TextSpan span({Paint? stroke}) => TextSpan(
      style: TextStyle(
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w800,
        foreground: stroke,
        color: stroke == null ? mainColor : null,
      ),
      children: [
        TextSpan(text: head),
        if (tail.isNotEmpty)
          TextSpan(
            text: tail,
            style: TextStyle(color: stroke == null ? _accent : null),
          ),
      ],
    );

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClaySurface(
          color: const Color(0xFFFFF6E6),
          radius: 36,
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
          child: Column(
            children: [
              // One line, shrinking for long titles.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text.rich(span(stroke: outline), softWrap: false),
                    Text.rich(span(), softWrap: false),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                game.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D4A5C),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: -6,
          bottom: 10,
          child: Text('🌼', style: TextStyle(fontSize: 30)),
        ),
        const Positioned(
          right: -6,
          bottom: 10,
          child: Text('🌼', style: TextStyle(fontSize: 30)),
        ),
        const Positioned(
          left: 22,
          top: -14,
          child: Text('🍃', style: TextStyle(fontSize: 24)),
        ),
        const Positioned(
          right: 22,
          top: -14,
          child: Text('🍃', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }
}

/// Pastel clay tiles — one per skill the game teaches.
class _SkillTiles extends StatelessWidget {
  const _SkillTiles({required this.skills, required this.width});

  final List<String> skills;
  final double width;

  static const _tints = [
    Color(0xFFCDF2D6), // mint
    Color(0xFFFFEDB8), // butter
    Color(0xFFE2D6FF), // lavender
    Color(0xFFCFE8FF), // sky
  ];

  static const _labelColors = [
    Color(0xFF1E5631),
    Color(0xFF7A3E00),
    Color(0xFF3A2A8C),
    Color(0xFF1B3A7A),
  ];

  static String _emojiFor(String skill) => switch (skill) {
    'Categories' => '🧺',
    'Food' => '🍎',
    'Vocabulary' => '📖',
    'Colors' => '🎨',
    'Matching' => '🧩',
    'Fine Motor' => '✋',
    'Size' => '📏',
    'Compare' => '⚖️',
    'Games' => '🎲',
    'Nature' => '🌿',
    'Healthy Eating' => '🥗',
    'Hygiene' => '🧼',
    'Sorting' => '🗂️',
    'Everyday Life' => '🏠',
    'Observation' => '🔍',
    'Animals' => '🐾',
    'Shapes' => '🔺',
    _ => '⭐',
  };

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        const gap = 12.0;
        // Four skills share one row so the Play button stays on screen.
        final cols = skills.length >= 4 ? 4 : 3;
        final tile = (width - gap * (cols - 1)) / cols;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < skills.length; i++)
              SizedBox(
                width: tile,
                height: cols == 4 ? tile * 1.05 : tile * 0.88,
                child: ClaySurface(
                  color: _tints[i % _tints.length],
                  radius: 26,
                  depth: 0.6,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _emojiFor(skills[i]),
                        style: TextStyle(fontSize: cols == 4 ? 36 : 46),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          skills[i],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: _labelColors[i % _labelColors.length],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlaysPill extends StatelessWidget {
  const _PlaysPill({required this.message, required this.showTicket});

  final String message;
  final bool showTicket;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFFFFF8EC),
      radius: 999,
      depth: 0.45,
      padding: const EdgeInsets.fromLTRB(18, 10, 22, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(showTicket ? '🎟️' : '🌱', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3A4F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Big glossy green clay Play button with a squish on press.
class _PlayButton extends StatefulWidget {
  const _PlayButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onTap();
              }
            : null,
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: _pressed ? 100 : 420),
          curve: _pressed ? Curves.easeOut : Curves.elasticOut,
          scale: _pressed ? 0.95 : 1,
          child: SizedBox(
            height: 84,
            child: ClaySurface(
              color: enabled
                  ? const Color(0xFF1FC27A)
                  : const Color(0xFFB8C2C0),
              radius: 42,
              pressed: _pressed,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (enabled) ...[
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: Color(0x40005A30),
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
