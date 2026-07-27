import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/color_school_bags_data.dart';
import '../data/flower_garden_data.dart';
import '../data/game_catalog.dart';
import '../data/sort_socks_data.dart';
import '../models/age_world.dart';
import '../models/game_modes.dart';
import '../models/rewards.dart';
import '../state/app_state.dart';
import '../state/game_settings_store.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/parent/game_controls/floating_sort_controls.dart';
import '../widgets/parent/game_controls/healthy_food_controls.dart';
import '../widgets/parent/game_controls/match_color_controls.dart';
import '../widgets/parent/parent_game_settings_card.dart';
import '../widgets/parent/premium_upsell_card.dart';

/// Adult-only Parent Zone: child lock → dashboard with per-game controls.
class ParentZoneScreen extends StatefulWidget {
  const ParentZoneScreen({
    super.key,
    this.expandGameId,
    this.startUnlocked = false,
  });

  /// When set, expands that game’s settings card after unlock.
  final String? expandGameId;

  /// Skip the lock when deep-linking mid-session after an existing unlock flow.
  final bool startUnlocked;

  @override
  State<ParentZoneScreen> createState() => _ParentZoneScreenState();
}

class _ParentZoneScreenState extends State<ParentZoneScreen> {
  late bool _unlocked;

  @override
  void initState() {
    super.initState();
    _unlocked = widget.startUnlocked;
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return _ParentLockScreen(
        onUnlocked: () => setState(() => _unlocked = true),
        onCancel: () => Navigator.pop(context),
      );
    }
    return _ParentDashboard(expandGameId: widget.expandGameId);
  }
}

// ── Child lock ───────────────────────────────────────────────────────────────

class _ParentLockScreen extends StatefulWidget {
  const _ParentLockScreen({
    required this.onUnlocked,
    required this.onCancel,
  });

  final VoidCallback onUnlocked;
  final VoidCallback onCancel;

  @override
  State<_ParentLockScreen> createState() => _ParentLockScreenState();
}

class _ParentLockScreenState extends State<_ParentLockScreen> {
  late int _a;
  late int _b;
  final _controller = TextEditingController();
  final _random = Random();

  DateTime? _pressStarted;
  Timer? _pressTimer;
  double _pressProgress = 0;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  @override
  void dispose() {
    _pressTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _newQuestion() {
    setState(() {
      _a = 2 + _random.nextInt(8); // 2–9
      _b = 2 + _random.nextInt(8);
      _controller.clear();
    });
  }

  Future<void> _tryAgain() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Try Again'),
        content: const Text(
          'That wasn’t quite right. Here’s a fresh question for you.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    _newQuestion();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == _a * _b) {
      HapticFeedback.mediumImpact();
      widget.onUnlocked();
    } else {
      HapticFeedback.lightImpact();
      _tryAgain();
    }
  }

  void _onLockPressStart() {
    _pressStarted = DateTime.now();
    _pressTimer?.cancel();
    _pressTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final started = _pressStarted;
      if (started == null) return;
      final elapsed = DateTime.now().difference(started).inMilliseconds;
      final progress = (elapsed / 3000).clamp(0.0, 1.0);
      setState(() => _pressProgress = progress);
      if (elapsed >= 500 && elapsed % 500 < 60) {
        HapticFeedback.selectionClick();
      }
      if (elapsed >= 3000) {
        _pressTimer?.cancel();
        HapticFeedback.heavyImpact();
        widget.onUnlocked();
      }
    });
  }

  void _onLockPressEnd() {
    _pressTimer?.cancel();
    _pressStarted = null;
    setState(() => _pressProgress = 0);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filledTonal(
                  onPressed: widget.onCancel,
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTapDown: (_) => _onLockPressStart(),
                onTapUp: (_) => _onLockPressEnd(),
                onTapCancel: _onLockPressEnd,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _pressProgress,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                        color: SortJoyColors.mint,
                      ),
                    ),
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        size: 44,
                        color: SortJoyColors.lavender,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Parents Only',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Solve a quick question, or press and hold the lock for 3 seconds.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: SortJoyColors.inkSoft,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      'What is $_a × $_b?',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Answer',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Unlock'),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dashboard ────────────────────────────────────────────────────────────────

class _ParentDashboard extends StatefulWidget {
  const _ParentDashboard({this.expandGameId});

  final String? expandGameId;

  @override
  State<_ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<_ParentDashboard> {
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    final id = widget.expandGameId;
    if (id != null) _expanded.add(id);
  }

  String _playsLabel(AppState app, String gameId) {
    if (app.settings.isPremium) return 'Unlimited today';
    final n = app.playsTodayFor(gameId);
    final left = app.remainingPlays(gameId);
    return '$n played · $left left';
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final gs = app.gameSettings;
    final isPremium = app.settings.isPremium;
    final games = GameCatalog.withParentControls;

    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Parent Zone',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Calm controls that apply the next time your child starts a game.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: SortJoyColors.inkSoft,
              ),
            ),
            const SizedBox(height: 16),
            PremiumUpsellCard(
              isPremium: isPremium,
              onTogglePremium: (v) => app.setPremium(v),
            ),
            const SizedBox(height: 12),
            _ChildStatsCard(app: app),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Age world',
              child: Column(
                children: [
                  for (final world in AgeWorld.values)
                    ListTile(
                      leading:
                          Text(world.emoji, style: const TextStyle(fontSize: 28)),
                      title: Text(world.title),
                      subtitle: Text(world.ageLabel),
                      trailing: Icon(
                        app.ageWorld == world
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.setAgeWorld(world),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Game controls',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            for (final game in games) ...[
              ParentGameSettingsCard(
                emoji: game.emoji,
                title: game.title,
                subtitle: game.subtitle,
                sessionSeconds: gs.sessionSecondsFor(game.id),
                includeInLearningPath: gs.includeInLearningPath(game.id),
                playsTodayLabel: _playsLabel(app, game.id),
                isPremium: isPremium,
                expanded: _expanded.contains(game.id),
                initiallyHighlight: widget.expandGameId == game.id,
                onExpansionChanged: (open) {
                  setState(() {
                    if (open) {
                      _expanded.add(game.id);
                    } else {
                      _expanded.remove(game.id);
                    }
                  });
                },
                onSessionSecondsChanged: (secs) =>
                    gs.setSessionSeconds(game.id, secs),
                onLearningPathChanged: (v) => gs.patchCommon(
                  game.id,
                  (c) => c.copyWith(includeInLearningPath: v),
                ),
                controlsChild: _controlsFor(game.id, gs),
              ),
              const SizedBox(height: 12),
            ],
            _SectionCard(
              title: 'Progress',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Level ${app.profileLevel} · XP ${app.rewards.xp} · '
                    'Badges ${app.rewards.badges.length}',
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset progress?'),
                          content: const Text(
                            'This clears coins, stars, XP, streaks, badges, and daily plays.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await app.resetProgress();
                    },
                    child: const Text('Reset progress'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _controlsFor(String gameId, GameSettingsStore store) {
    switch (gameId) {
      case GameCatalog.fruitVegId:
        final s = store.fruitVeg;
        return FloatingSortControls(
          common: s.common,
          floatingItemCount: s.floatingItemCount,
          speed: s.speed,
          floatingAnimation: s.floatingAnimation,
          modeLabel: 'Sort mode',
          modeOptions: const ['Mixed', 'Fruits only', 'Vegetables only'],
          selectedModeIndex: FruitVegMode.values.indexOf(s.mode),
          onCommonChanged: (c) =>
              store.patchFruitVeg((x) => x.copyWith(common: c)),
          onFloatingCountChanged: (n) =>
              store.patchFruitVeg((x) => x.copyWith(floatingItemCount: n)),
          onSpeedChanged: (sp) =>
              store.patchFruitVeg((x) => x.copyWith(speed: sp)),
          onFloatingAnimationChanged: (v) =>
              store.patchFruitVeg((x) => x.copyWith(floatingAnimation: v)),
          onModeIndexChanged: (i) =>
              store.patchFruitVeg((x) => x.copyWith(mode: FruitVegMode.values[i])),
        );
      case GameCatalog.indoorOutdoorId:
        final s = store.indoorOutdoor;
        return FloatingSortControls(
          common: s.common,
          floatingItemCount: s.floatingItemCount,
          speed: s.speed,
          floatingAnimation: s.floatingAnimation,
          modeLabel: 'Sort mode',
          modeOptions: const ['Mixed', 'Indoor only', 'Outdoor only'],
          selectedModeIndex: IndoorOutdoorMode.values.indexOf(s.mode),
          onCommonChanged: (c) =>
              store.patchIndoorOutdoor((x) => x.copyWith(common: c)),
          onFloatingCountChanged: (n) => store.patchIndoorOutdoor(
            (x) => x.copyWith(floatingItemCount: n),
          ),
          onSpeedChanged: (sp) =>
              store.patchIndoorOutdoor((x) => x.copyWith(speed: sp)),
          onFloatingAnimationChanged: (v) => store.patchIndoorOutdoor(
            (x) => x.copyWith(floatingAnimation: v),
          ),
          onModeIndexChanged: (i) => store.patchIndoorOutdoor(
            (x) => x.copyWith(mode: IndoorOutdoorMode.values[i]),
          ),
        );
      case GameCatalog.colorSortId:
        final s = store.colorSort;
        return FloatingSortControls(
          common: s.common,
          floatingItemCount: s.floatingItemCount,
          speed: s.speed,
          floatingAnimation: s.floatingAnimation,
          modeLabel: 'Color mode',
          modeOptions: const ['Mixed', 'Red only', 'Blue only', 'Green only'],
          selectedModeIndex: ColorSortMode.values.indexOf(s.mode),
          onCommonChanged: (c) =>
              store.patchColorSort((x) => x.copyWith(common: c)),
          onFloatingCountChanged: (n) =>
              store.patchColorSort((x) => x.copyWith(floatingItemCount: n)),
          onSpeedChanged: (sp) =>
              store.patchColorSort((x) => x.copyWith(speed: sp)),
          onFloatingAnimationChanged: (v) =>
              store.patchColorSort((x) => x.copyWith(floatingAnimation: v)),
          onModeIndexChanged: (i) => store.patchColorSort(
            (x) => x.copyWith(mode: ColorSortMode.values[i]),
          ),
        );
      case GameCatalog.bigSmallId:
        final s = store.bigSmall;
        return FloatingSortControls(
          common: s.common,
          floatingItemCount: s.floatingItemCount,
          speed: s.speed,
          floatingAnimation: s.floatingAnimation,
          modeLabel: 'Size mode',
          modeOptions: const ['Mixed', 'Big only', 'Small only'],
          selectedModeIndex: BigSmallMode.values.indexOf(s.mode),
          onCommonChanged: (c) =>
              store.patchBigSmall((x) => x.copyWith(common: c)),
          onFloatingCountChanged: (n) =>
              store.patchBigSmall((x) => x.copyWith(floatingItemCount: n)),
          onSpeedChanged: (sp) =>
              store.patchBigSmall((x) => x.copyWith(speed: sp)),
          onFloatingAnimationChanged: (v) =>
              store.patchBigSmall((x) => x.copyWith(floatingAnimation: v)),
          onModeIndexChanged: (i) => store.patchBigSmall(
            (x) => x.copyWith(mode: BigSmallMode.values[i]),
          ),
        );
      case GameCatalog.colorSchoolBagsId:
        final s = store.colorSchoolBags;
        return MatchColorControls(
          common: s.common,
          difficultyLabels: const [
            'Level 1 · 2 backpacks',
            'Level 2 · 3 backpacks',
            'Level 3 · 4 backpacks',
            'Advanced · 5 backpacks',
            'Advanced · 6 backpacks',
          ],
          selectedDifficultyIndex:
              ColorSchoolBagsDifficulty.values.indexOf(s.difficulty),
          colorIds: ColorSchoolBagsData.allColorIds,
          colorLabels: ColorSchoolBagsData.allColorIds
              .map(ColorSchoolBagsData.displayName)
              .toList(),
          enabledColors: s.enabledColors,
          minColors: 2,
          onCommonChanged: (c) =>
              store.patchColorSchoolBags((x) => x.copyWith(common: c)),
          onDifficultyChanged: (i) => store.patchColorSchoolBags(
            (x) => x.copyWith(difficulty: ColorSchoolBagsDifficulty.values[i]),
          ),
          onColorsChanged: (colors) => store.patchColorSchoolBags(
            (x) => x.copyWith(enabledColors: colors),
          ),
        );
      case GameCatalog.sortSocksId:
        final s = store.sortSocks;
        return MatchColorControls(
          common: s.common,
          difficultyLabels: const [
            'Level 1 · 2 laundry bags',
            'Level 2 · 3 laundry bags',
            'Level 3 · 4 laundry bags',
            'Advanced · 5 laundry bags',
            'Advanced · 6 laundry bags',
          ],
          selectedDifficultyIndex:
              SortSocksDifficulty.values.indexOf(s.difficulty),
          colorIds: SortSocksData.allColorIds,
          colorLabels:
              SortSocksData.allColorIds.map(SortSocksData.displayName).toList(),
          enabledColors: s.enabledColors,
          minColors: 2,
          onCommonChanged: (c) =>
              store.patchSortSocks((x) => x.copyWith(common: c)),
          onDifficultyChanged: (i) => store.patchSortSocks(
            (x) => x.copyWith(difficulty: SortSocksDifficulty.values[i]),
          ),
          onColorsChanged: (colors) =>
              store.patchSortSocks((x) => x.copyWith(enabledColors: colors)),
        );
      case GameCatalog.flowerGardenId:
        final s = store.flowerGarden;
        return MatchColorControls(
          common: s.common,
          difficultyLabels: const [
            'Level 1 · 2 colors',
            'Level 2 · 3 colors',
            'Level 3 · 4 colors',
            'Level 4 · 5 colors',
          ],
          selectedDifficultyIndex:
              FlowerGardenDifficulty.values.indexOf(s.difficulty),
          colorIds: FlowerGardenData.allColorIds,
          colorLabels: FlowerGardenData.allColorIds
              .map(FlowerGardenData.displayName)
              .toList(),
          enabledColors: s.enabledColors,
          minColors: 2,
          onCommonChanged: (c) =>
              store.patchFlowerGarden((x) => x.copyWith(common: c)),
          onDifficultyChanged: (i) => store.patchFlowerGarden(
            (x) => x.copyWith(difficulty: FlowerGardenDifficulty.values[i]),
          ),
          onColorsChanged: (colors) => store.patchFlowerGarden(
            (x) => x.copyWith(enabledColors: colors),
          ),
        );
      case GameCatalog.healthyFoodId:
        return HealthyFoodControls(
          settings: store.healthyFood,
          onChanged: (next) => store.patchHealthyFood((_) => next),
        );
      case GameCatalog.cleanDirtyId:
        final s = store.cleanDirty;
        return FloatingSortControls(
          common: s.common,
          floatingItemCount: s.floatingItemCount,
          speed: s.speed,
          floatingAnimation: s.floatingAnimation,
          minFloating: 3,
          maxFloating: 8,
          modeLabel: 'Clothes mode',
          modeOptions: const ['Mixed', 'Clean only', 'Dirty only'],
          selectedModeIndex: CleanDirtyMode.values.indexOf(s.mode),
          onCommonChanged: (c) =>
              store.patchCleanDirty((x) => x.copyWith(common: c)),
          onFloatingCountChanged: (n) =>
              store.patchCleanDirty((x) => x.copyWith(floatingItemCount: n)),
          onSpeedChanged: (sp) =>
              store.patchCleanDirty((x) => x.copyWith(speed: sp)),
          onFloatingAnimationChanged: (v) =>
              store.patchCleanDirty((x) => x.copyWith(floatingAnimation: v)),
          onModeIndexChanged: (i) => store.patchCleanDirty(
            (x) => x.copyWith(mode: CleanDirtyMode.values[i]),
          ),
          extraControls: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Bubble effects'),
            subtitle: const Text('Floating soap bubbles in the laundry room'),
            value: s.bubbleEffects,
            onChanged: (v) =>
                store.patchCleanDirty((x) => x.copyWith(bubbleEffects: v)),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ChildStatsCard extends StatelessWidget {
  const _ChildStatsCard({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    final r = app.rewards;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Child statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatPill(label: 'Level', value: '${app.profileLevel}', emoji: '🌱'),
              _StatPill(label: 'Coins', value: '${r.coins}', emoji: '🪙'),
              _StatPill(label: 'Stars', value: '${r.stars}', emoji: '⭐'),
              _StatPill(label: 'XP', value: '${r.xp}', emoji: '✨'),
              _StatPill(
                label: 'Games today',
                value: '${r.playsToday.values.fold<int>(0, (a, b) => a + b)}',
                emoji: '🎮',
              ),
              _StatPill(
                label: 'Free / game',
                value: '${RewardsState.freePlaysPerGame}',
                emoji: '📅',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.emoji,
  });

  final String label;
  final String value;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SortJoyColors.skyBottom,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: SortJoyColors.inkSoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
