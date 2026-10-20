import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/game_definition.dart';
import '../../models/rewards.dart';
import '../../screens/parent_zone_screen.dart';
import '../../state/app_state.dart';
import '../../theme/sortjoy_theme.dart';
import '../../widgets/celebration_burst.dart';
import '../../widgets/soft_toast.dart';
import '../../widgets/app_background.dart';
import '../healthy_food/food_bubble_chip.dart';
import '../healthy_food/toddler_drop_zone.dart';
import '../../data/clean_dirty_data.dart';
import '../../data/healthy_food_data.dart';
import '../clean_dirty/clothing_chip.dart';
import '../clean_dirty/laundry_drop_zones.dart';
import '../clean_dirty/laundry_room_background.dart';
import '../fruit_veg/soap_bubble_chip.dart';
import '../fruit_veg/wicker_basket.dart';
import '../../widgets/clay_surface.dart';
import 'sorting_engine.dart';

class SortingPlayScreen extends StatefulWidget {
  const SortingPlayScreen({
    super.key,
    required this.config,
    required this.background,
    this.title = 'SortJoy',
  });

  final SortingEngineConfig config;
  final Widget background;
  final String title;

  @override
  State<SortingPlayScreen> createState() => _SortingPlayScreenState();
}

class _SortingPlayScreenState extends State<SortingPlayScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final SortingEngine _engine;
  late final Ticker _ticker;
  final Map<String, GlobalKey> _zoneKeys = {};
  SessionResult? _pendingResult;
  bool _finishing = false;
  int _burstKey = 0;
  String? _lastToast;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    for (final c in widget.config.categories) {
      _zoneKeys[c.id] = GlobalKey();
    }
    _engine = SortingEngine(config: widget.config, onChanged: _onEngineChanged);
    _ticker = createTicker((_) => _engine.tick())..start();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        _engine.start(box.size);
      }
    });
  }

  void _onEngineChanged() {
    if (!mounted) return;
    final snap = _engine.snapshot();
    if (snap.toastMessage != null &&
        snap.toastMessage != _lastToast &&
        widget.config.celebrationsEnabled) {
      _lastToast = snap.toastMessage;
      _burstKey++;
    }
    setState(() {});
    if (snap.finished && !_finishing) {
      _finishSession();
    }
  }

  Future<void> _finishSession() async {
    final result = await _saveSession();
    if (!mounted) return;
    setState(() => _pendingResult = result);
  }

  /// Leaving mid-session keeps what the child earned (no lost rewards).
  /// Sessions with zero sorts are not saved, so a quick peek is free.
  Future<void> _exitToHome() async {
    if (!_finishing && _engine.correctSorts > 0) {
      await _saveSession();
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<SessionResult> _saveSession() async {
    _finishing = true;
    _ticker.stop();
    final app = context.read<AppState>();
    final snap = _engine.snapshot();
    return app.applySessionResult(
      gameId: widget.config.gameId,
      correctSorts: snap.correctSorts,
      categoryCounts: Map<String, int>.from(snap.categoryCounts),
      longestStreak: snap.longestStreak,
      // The HUD totals are the source of truth — what the child saw is
      // exactly what gets banked.
      coinsEarned: snap.coins,
      starsEarned: snap.stars,
      rewardMultiplier: widget.config.rewardMultiplier,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _engine.pauseForBackground();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    super.dispose();
  }

  Rect? _zoneRect(String categoryId) {
    final key = _zoneKeys[categoryId];
    final ctx = key?.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final origin = box.localToGlobal(Offset.zero);
    return origin & box.size;
  }

  void _handleDrop(FloatingSortItem item, Offset globalCenter) {
    String? hitCategory;
    var bestDistance = double.infinity;
    final snap = widget.config.snapPadding;

    for (final c in widget.config.categories) {
      final rect = _zoneRect(c.id);
      if (rect == null) continue;

      final expanded = rect.inflate(snap);
      if (expanded.contains(globalCenter)) {
        hitCategory = c.id;
        break;
      }

      // Auto-snap to nearest basket when close enough
      final center = rect.center;
      final dist = (center - globalCenter).distance;
      if (dist < rect.shortestSide * 0.75 + snap && dist < bestDistance) {
        bestDistance = dist;
        hitCategory = c.id;
      }
    }
    if (hitCategory == null) {
      _engine.cancelDrag(item.instanceId);
      return;
    }
    final ok = _engine.dropOnCategory(item.instanceId, hitCategory);
    if (ok) {
      if (widget.config.hapticsEnabled) {
        HapticFeedback.lightImpact();
      }
      if (widget.config.celebrationsEnabled) {
        _burstKey++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingResult != null) {
      return _CelebrationHost(
        result: _pendingResult!,
        categories: widget.config.categories,
        categoryCounts: _engine.categoryCounts,
        celebrationSubtitle: widget.config.celebrationSubtitle,
        showCoins: widget.config.coinRewardsEnabled,
        onPlayAgain: () {
          if (!context.read<AppState>().canPlayGame(widget.config.gameId)) {
            // Back to setup, which explains the daily limit.
            Navigator.of(context).pop();
            return;
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SortingPlayScreen(
                config: widget.config,
                background: widget.background,
                title: widget.title,
              ),
            ),
          );
        },
        onHome: () {
          Navigator.of(context).popUntil((r) => r.isFirst);
        },
      );
    }

    final snap = _engine.snapshot();
    final padding = MediaQuery.paddingOf(context);
    final itemHalf = widget.config.itemSize / 2;
    final leftHanded = widget.config.leftHandedLayout;
    final showCoins =
        !widget.config.hideCoinHud && widget.config.coinRewardsEnabled;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_engine.paused && !_engine.finished) {
          _engine.togglePause();
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            // Keep floating items clear of the notch and the HUD row.
            _engine.topInset = padding.top + 72;
            if (_engine.playSize != size && size != Size.zero) {
              if (!_engine.started && !snap.finished) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _engine.start(size);
                });
              } else {
                _engine.setPlaySize(size);
              }
            }

            final hudStats = <Widget>[
              _HudChip(
                icon: Icons.timer_rounded,
                label: widget.config.unlimitedSession
                    ? '∞'
                    : _formatTime(snap.remainingSeconds),
                color: const Color(0xFF8E5CF6),
              ),
              if (showCoins) ...[
                const SizedBox(width: 8),
                _HudChip(
                  icon: Icons.attach_money_rounded,
                  label: '${snap.coins}',
                  color: const Color(0xFFF2A900),
                ),
              ],
              const SizedBox(width: 8),
              _HudChip(
                icon: Icons.star_rounded,
                label: '${snap.stars}',
                color: SortJoyColors.star,
                badge: false,
              ),
            ];

            final pauseBtn = Semantics(
              button: true,
              label: snap.paused ? 'Resume' : 'Pause',
              child: GestureDetector(
                onTap: _engine.togglePause,
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: ClaySurface(
                    color: const Color(0xFFFFF8EC),
                    radius: 26,
                    depth: 0.45,
                    child: Center(
                      child: Icon(
                        snap.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: const Color(0xFF7A4A2A),
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: widget.config.laundryZones
                      ? LaundryRoomBackground(
                          bubbleEffects: widget.config.bubbleEffects,
                          reducedMotion: widget.config.reducedMotion,
                          cheerLevel: snap.correctSorts ~/ 3,
                        )
                      : widget.background,
                ),
                // HUD
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: leftHanded
                          ? [pauseBtn, const Spacer(), ...hudStats]
                          : [...hudStats, const Spacer(), pauseBtn],
                    ),
                  ),
                ),

                // Floating items
                ..._engine.items.map((item) {
                  return _DraggableFloatingItem(
                    key: ValueKey(item.instanceId),
                    item: item,
                    paused: snap.paused,
                    itemSize: widget.config.itemSize,
                    bookShape: widget.config.bookShape,
                    sockShape: widget.config.sockShape,
                    flowerShape: widget.config.flowerShape,
                    foodBubbleShape: widget.config.foodBubbleShape,
                    soapBubbleShape: widget.config.soapBubbleShape,
                    clothesChipShape: widget.config.clothesChipShape,
                    onDragStart: () => _engine.beginDrag(item.instanceId),
                    onDragUpdate: (global) {
                      final box = context.findRenderObject() as RenderBox?;
                      if (box == null) return;
                      final local = box.globalToLocal(global);
                      _engine.updateDrag(
                        item.instanceId,
                        local - Offset(itemHalf, itemHalf),
                      );
                    },
                    onDragEnd: (global) {
                      final box = context.findRenderObject() as RenderBox?;
                      if (box == null) {
                        _engine.cancelDrag(item.instanceId);
                        return;
                      }
                      final centerLocal =
                          item.position + Offset(itemHalf, itemHalf);
                      final centerGlobal = box.localToGlobal(centerLocal);
                      _handleDrop(item, centerGlobal);
                    },
                  );
                }),

                // Baskets
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: padding.bottom + 16,
                  child: Row(
                    children: [
                      for (
                        var i = 0;
                        i < widget.config.categories.length;
                        i++
                      ) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(
                          child: widget.config.laundryZones
                              ? LaundryDropZone(
                                  key:
                                      _zoneKeys[widget.config.categories[i].id],
                                  category: widget.config.categories[i],
                                  isWashingMachine:
                                      widget.config.categories[i].id ==
                                      CleanDirtyData.dirtyCategoryId,
                                  glow:
                                      snap.guidanceCategoryId ==
                                          widget.config.categories[i].id ||
                                      snap.idleHint &&
                                          _engine.items.isNotEmpty &&
                                          _engine.items.first.item.categoryId ==
                                              widget.config.categories[i].id,
                                  wiggle:
                                      snap.guidanceCategoryId != null &&
                                      snap.guidanceCategoryId !=
                                          widget.config.categories[i].id,
                                  count:
                                      snap.categoryCounts[widget
                                          .config
                                          .categories[i]
                                          .id] ??
                                      0,
                                  reaction:
                                      snap.happyDropCategoryId ==
                                          widget.config.categories[i].id
                                      ? 'happy'
                                      : snap.wrongDropCategoryId ==
                                            widget.config.categories[i].id
                                      ? 'confused'
                                      : null,
                                )
                              : widget.config.toddlerZones
                              ? ToddlerDropZone(
                                  key:
                                      _zoneKeys[widget.config.categories[i].id],
                                  category: widget.config.categories[i],
                                  glow:
                                      snap.guidanceCategoryId ==
                                          widget.config.categories[i].id ||
                                      snap.idleHint &&
                                          _engine.items.isNotEmpty &&
                                          _engine.items.first.item.categoryId ==
                                              widget.config.categories[i].id,
                                  wiggle:
                                      snap.guidanceCategoryId != null &&
                                      snap.guidanceCategoryId !=
                                          widget.config.categories[i].id,
                                  count:
                                      snap.categoryCounts[widget
                                          .config
                                          .categories[i]
                                          .id] ??
                                      0,
                                  isHealthyHero:
                                      widget.config.categories[i].id ==
                                      HealthyFoodData.healthyCategoryId,
                                  reaction:
                                      snap.happyDropCategoryId ==
                                          widget.config.categories[i].id
                                      ? 'happy'
                                      : snap.wrongDropCategoryId ==
                                            widget.config.categories[i].id
                                      ? 'confused'
                                      : null,
                                )
                              : widget.config.wickerBasketZones
                              ? WickerBasketZone(
                                  key:
                                      _zoneKeys[widget.config.categories[i].id],
                                  category: widget.config.categories[i],
                                  reducedMotion: widget.config.reducedMotion,
                                  glow:
                                      snap.guidanceCategoryId ==
                                          widget.config.categories[i].id ||
                                      snap.idleHint &&
                                          _engine.items.isNotEmpty &&
                                          _engine.items.first.item.categoryId ==
                                              widget.config.categories[i].id,
                                  wiggle:
                                      snap.wrongDropCategoryId ==
                                      widget.config.categories[i].id,
                                  count:
                                      snap.categoryCounts[widget
                                          .config
                                          .categories[i]
                                          .id] ??
                                      0,
                                )
                              : _DropBasket(
                                  key:
                                      _zoneKeys[widget.config.categories[i].id],
                                  category: widget.config.categories[i],
                                  emojiOverride: widget.config.categoryEmoji,
                                  flowerPotShape: widget.config.flowerPotShape,
                                  glow:
                                      snap.guidanceCategoryId ==
                                          widget.config.categories[i].id ||
                                      snap.idleHint &&
                                          _engine.items.isNotEmpty &&
                                          _engine.items.first.item.categoryId ==
                                              widget.config.categories[i].id,
                                  wiggle:
                                      snap.guidanceCategoryId != null &&
                                      snap.guidanceCategoryId !=
                                          widget.config.categories[i].id,
                                  count:
                                      snap.categoryCounts[widget
                                          .config
                                          .categories[i]
                                          .id] ??
                                      0,
                                ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Toasts / voice
                if (snap.toastMessage != null)
                  Positioned(
                    top: padding.top + 72,
                    left: 24,
                    right: 24,
                    child: SoftToast(
                      message: snap.toastMessage!,
                      color:
                          _toastColor(snap.toastMessage!) ?? SortJoyColors.mint,
                    ),
                  ),
                if (snap.voiceLabel != null)
                  Positioned(
                    top: padding.top + 130,
                    left: 40,
                    right: 40,
                    child: SoftToast(
                      message: snap.voiceLabel!,
                      compact: true,
                      color: SortJoyColors.peach,
                    ),
                  ),

                if (widget.config.celebrationsEnabled &&
                    !widget.config.reducedMotion)
                  IgnorePointer(
                    child: CelebrationBurst(
                      key: ValueKey(_burstKey),
                      seed: _random.nextInt(1 << 20),
                    ),
                  ),

                if (widget.config.unlimitedSession &&
                    !snap.paused &&
                    !snap.finished)
                  Positioned(
                    left: 24,
                    right: 24,
                    // Keep clear of tall laundry / toddler drop zones.
                    bottom:
                        padding.bottom +
                        (widget.config.laundryZones ||
                                widget.config.toddlerZones
                            ? 180
                            : 16),
                    child: Center(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.92),
                          foregroundColor: SortJoyColors.ink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: _engine.finishNow,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: const Text(
                          'Done Playing',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),

                if (snap.paused)
                  Positioned.fill(
                    child: _PauseMenu(
                      showDone: widget.config.unlimitedSession,
                      onResume: _engine.togglePause,
                      onParent: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ParentZoneScreen(
                            expandGameId: widget.config.gameId,
                          ),
                        ),
                      ),
                      onDone: _engine.finishNow,
                      onHome: _exitToHome,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Color? _toastColor(String message) {
    if (message == 'HEALTHY!') return SortJoyColors.grass;
    if (message == 'JUNK FOOD') return SortJoyColors.coral;
    if (message == 'All Clean!') return const Color(0xFF29B6F6);
    if (message == 'Neatly Stored!') return const Color(0xFFFFB74D);
    return null;
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.icon,
    required this.label,
    required this.color,
    this.badge = true,
  });

  final IconData icon;
  final String label;
  final Color color;

  /// White icon on a coloured coin; otherwise a large bare icon.
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: const Color(0xFFFFF8EC),
      radius: 999,
      depth: 0.45,
      padding: const EdgeInsets.fromLTRB(6, 5, 14, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color.lerp(color, Colors.white, 0.35)!, color],
                    ),
                    border: Border.all(
                      color: Color.lerp(color, Colors.black, 0.15)!,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                )
              : Icon(icon, color: color, size: 32),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 19,
              height: 1.2,
              color: Color(0xFF1F2F55),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropBasket extends StatefulWidget {
  const _DropBasket({
    super.key,
    required this.category,
    required this.glow,
    required this.wiggle,
    required this.count,
    this.emojiOverride,
    this.flowerPotShape = false,
  });

  final SortCategory category;
  final bool glow;
  final bool wiggle;
  final int count;
  final String? emojiOverride;
  final bool flowerPotShape;

  @override
  State<_DropBasket> createState() => _DropBasketState();
}

class _DropBasketState extends State<_DropBasket>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.category.color);
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        final invite = sin(_bounce.value * pi) * 4;
        final wiggle = widget.wiggle ? sin(_bounce.value * pi * 6) * 5 : 0.0;
        return Transform.translate(
          offset: Offset(wiggle, -invite),
          child: child,
        );
      },
      child: widget.flowerPotShape
          ? _FlowerPot(
              color: color,
              glow: widget.glow,
              emoji: widget.emojiOverride ?? widget.category.emoji,
              label: widget.category.label,
              count: widget.count,
            )
          : Container(
              decoration: BoxDecoration(
                color: Color.lerp(color, Colors.black, 0.2),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: widget.glow ? 0.45 : 0.2),
                    blurRadius: widget.glow ? 24 : 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 6),
                height: 126,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.98),
                      color.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: widget.glow ? SortJoyColors.glow : Colors.white70,
                    width: widget.glow ? 4 : 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.emojiOverride ?? widget.category.emoji,
                      style: const TextStyle(fontSize: 42),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.category.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                      ),
                    ),
                    Text(
                      '${widget.count}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DraggableFloatingItem extends StatelessWidget {
  const _DraggableFloatingItem({
    super.key,
    required this.item,
    required this.paused,
    required this.itemSize,
    required this.bookShape,
    required this.sockShape,
    required this.flowerShape,
    required this.foodBubbleShape,
    this.soapBubbleShape = false,
    this.clothesChipShape = false,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final FloatingSortItem item;
  final bool paused;
  final double itemSize;
  final bool bookShape;
  final bool sockShape;
  final bool flowerShape;
  final bool foodBubbleShape;
  final bool soapBubbleShape;
  final bool clothesChipShape;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;

  @override
  Widget build(BuildContext context) {
    final accent = item.item.accentColor != null
        ? Color(item.item.accentColor!)
        : Colors.white.withValues(alpha: 0.92);

    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onPanStart: paused
            ? null
            : (_) {
                onDragStart();
              },
        onPanUpdate: paused
            ? null
            : (d) {
                onDragUpdate(d.globalPosition);
              },
        onPanEnd: paused
            ? null
            : (d) {
                onDragEnd(d.globalPosition);
              },
        child: AnimatedScale(
          scale: item.dragging ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Transform.scale(
            scale: item.item.visualScale.clamp(0.7, 1.35),
            child: clothesChipShape
                ? ClothingChip(
                    emoji: item.item.emoji,
                    size: itemSize,
                    isDirty: CleanDirtyData.isDirty(item.item),
                    accentColor: item.item.accentColor,
                  )
                : flowerShape
                ? _FlowerChip(size: itemSize, accent: accent)
                : soapBubbleShape
                ? SoapBubbleChip(
                    size: itemSize,
                    emoji: item.item.emoji,
                    bobPhase: item.bobPhase,
                  )
                : foodBubbleShape
                ? FoodBubbleChip(
                    size: itemSize,
                    emoji: item.item.emoji,
                    bobPhase: item.bobPhase,
                  )
                : sockShape
                ? _SockChip(size: itemSize, accent: accent)
                : bookShape
                ? _BookChip(
                    size: itemSize,
                    accent: accent,
                    emoji: item.item.emoji,
                  )
                : Container(
                    width: itemSize,
                    height: itemSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: item.item.accentColor != null
                          ? accent.withValues(alpha: 0.92)
                          : Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      border: item.item.accentColor != null
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      item.item.emoji,
                      style: TextStyle(fontSize: itemSize * 0.5),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _BookChip extends StatelessWidget {
  const _BookChip({
    required this.size,
    required this.accent,
    required this.emoji,
  });

  final double size;
  final Color accent;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.85,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.95),
            accent.withValues(alpha: 0.78),
          ],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6,
            top: 8,
            bottom: 8,
            child: Container(
              width: 8,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Text(emoji, style: TextStyle(fontSize: size * 0.42)),
        ],
      ),
    );
  }
}

/// Soft sock silhouette — color varies by accent for toddler matching.
class _SockChip extends StatelessWidget {
  const _SockChip({required this.size, required this.accent});

  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(painter: _SockPainter(accent: accent)),
      ),
    );
  }
}

class _SockPainter extends CustomPainter {
  const _SockPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(accent, Colors.white, 0.12)!,
          accent.withValues(alpha: 0.92),
        ],
      ).createShader(Offset.zero & size);
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeJoin = StrokeJoin.round;
    final cuff = Paint()..color = Color.lerp(accent, Colors.white, 0.28)!;

    final path = Path()
      ..moveTo(w * 0.34, h * 0.12)
      ..lineTo(w * 0.62, h * 0.12)
      ..cubicTo(w * 0.70, h * 0.12, w * 0.74, h * 0.20, w * 0.74, h * 0.30)
      ..lineTo(w * 0.74, h * 0.52)
      ..cubicTo(w * 0.74, h * 0.62, w * 0.86, h * 0.66, w * 0.90, h * 0.74)
      ..cubicTo(w * 0.95, h * 0.84, w * 0.88, h * 0.92, w * 0.74, h * 0.92)
      ..lineTo(w * 0.30, h * 0.92)
      ..cubicTo(w * 0.18, h * 0.92, w * 0.14, h * 0.82, w * 0.18, h * 0.72)
      ..lineTo(w * 0.30, h * 0.48)
      ..lineTo(w * 0.30, h * 0.30)
      ..cubicTo(w * 0.30, h * 0.20, w * 0.26, h * 0.12, w * 0.34, h * 0.12)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    final cuffRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.30, h * 0.10, w * 0.36, h * 0.14),
      const Radius.circular(8),
    );
    canvas.drawRRect(cuffRect, cuff);
    canvas.drawRRect(
      cuffRect,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Soft heel highlight
    canvas.drawCircle(
      Offset(w * 0.38, h * 0.78),
      w * 0.06,
      Paint()..color = Colors.white.withValues(alpha: 0.28),
    );
  }

  @override
  bool shouldRepaint(covariant _SockPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

/// Consistent flower shape — only petal color changes for toddler color learning.
class _FlowerChip extends StatelessWidget {
  const _FlowerChip({required this.size, required this.accent});

  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final headSize = size * 0.72;
    return SizedBox(
      width: size,
      height: size * 1.05,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: headSize * 0.82,
            child: Container(
              width: 6,
              height: size * 0.38,
              decoration: BoxDecoration(
                color: SortJoyColors.grassDark,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            top: headSize * 0.72,
            left: size * 0.22,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: size * 0.22,
                height: size * 0.14,
                decoration: BoxDecoration(
                  color: SortJoyColors.grass,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            top: headSize * 0.72,
            right: size * 0.22,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: size * 0.22,
                height: size * 0.14,
                decoration: BoxDecoration(
                  color: SortJoyColors.grass,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Container(
            width: headSize,
            height: headSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _FlowerHeadPainter(accent: accent),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _eye(size * 0.07),
                        SizedBox(width: size * 0.12),
                        _eye(size * 0.07),
                      ],
                    ),
                    SizedBox(height: size * 0.03),
                    Container(
                      width: size * 0.12,
                      height: size * 0.05,
                      decoration: BoxDecoration(
                        color: SortJoyColors.berry.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eye(double r) {
    return Container(
      width: r * 2,
      height: r * 2,
      decoration: const BoxDecoration(
        color: SortJoyColors.inkSoft,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FlowerHeadPainter extends CustomPainter {
  _FlowerHeadPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final petalPaint = Paint()..color = accent;
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final petalCenter = center + Offset(cos(angle) * 22, sin(angle) * 22);
      canvas.drawCircle(petalCenter, 18, petalPaint);
    }
    canvas.drawCircle(center, 16, Paint()..color = SortJoyColors.lemon);
    canvas.drawCircle(
      center,
      16,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _FlowerHeadPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _FlowerPot extends StatelessWidget {
  const _FlowerPot({
    required this.color,
    required this.glow,
    required this.emoji,
    required this.label,
    required this.count,
  });

  final Color color;
  final bool glow;
  final String emoji;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            height: 118,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.92),
                  color.withValues(alpha: 0.72),
                  color.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
              border: Border.all(
                color: glow
                    ? SortJoyColors.glow
                    : Colors.white.withValues(alpha: 0.85),
                width: glow ? 4 : 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: glow ? 0.55 : 0.3),
                  blurRadius: glow ? 26 : 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white54, width: 2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                  ),
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [_potEye(), const SizedBox(width: 10), _potEye()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _potEye() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: SortJoyColors.inkSoft,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CelebrationHost extends StatelessWidget {
  const _CelebrationHost({
    required this.result,
    required this.categories,
    required this.categoryCounts,
    required this.celebrationSubtitle,
    required this.onPlayAgain,
    required this.onHome,
    this.showCoins = true,
  });

  final SessionResult result;
  final bool showCoins;
  final List<SortCategory> categories;
  final Map<String, int> categoryCounts;
  final String celebrationSubtitle;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  SortCategory? _categoryFor(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String, String)>[
      ('✨', 'Items sorted', '${result.correctSorts}'),
      for (final e in categoryCounts.entries)
        (
          _categoryFor(e.key)?.emoji ?? '⭐',
          '${_categoryFor(e.key)?.label ?? e.key} sorted',
          '${e.value}',
        ),
      if (showCoins) ('🪙', 'Coins', '+${result.coinsEarned}'),
      ('⭐', 'Stars', '+${result.starsEarned}'),
      ('⚡', 'XP', '+${result.xpEarned}'),
      ('🔥', 'Longest streak', '${result.longestStreak}'),
    ];

    const navy = Color(0xFF1F2F55);
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AppBackground(),
          const Positioned.fill(
            child: IgnorePointer(
              child: CelebrationBurst(seed: 42, continuous: true),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
              child: Column(
                children: [
                  // Party popper with a warm glow.
                  SizedBox(
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.9),
                                const Color(0xFFFFF59D).withValues(alpha: 0.45),
                                const Color(0xFFFFF59D).withValues(alpha: 0),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.3, end: 1),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.elasticOut,
                          builder: (context, s, child) =>
                              Transform.scale(scale: s, child: child),
                          child: const Text(
                            '🎉',
                            style: TextStyle(fontSize: 100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Stack(
                      children: [
                        Text(
                          'Fantastic Learning!',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 38,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            foreground: outline,
                          ),
                        ),
                        const Text(
                          'Fantastic Learning!',
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 38,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    celebrationSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: navy,
                      shadows: [Shadow(color: Colors.white, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: ClaySurface(
                            color: const Color(0xFFFFF8EC),
                            radius: 32,
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var i = 0; i < rows.length; i++)
                                    _StatRow(
                                      emoji: rows[i].$1,
                                      label: rows[i].$2,
                                      value: rows[i].$3,
                                      divider: i < rows.length - 1,
                                    ),
                                  if (result.newBadges.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Badges unlocked',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: navy,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      alignment: WrapAlignment.center,
                                      children: result.newBadges
                                          .map(
                                            (b) => Chip(
                                              avatar: const Text('🏅'),
                                              label: Text(b),
                                              backgroundColor: SortJoyColors
                                                  .lemon
                                                  .withValues(alpha: 0.5),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: -10,
                          top: -14,
                          child: Text('🍃', style: TextStyle(fontSize: 26)),
                        ),
                        const Positioned(
                          right: -8,
                          top: -14,
                          child: Text('🌼', style: TextStyle(fontSize: 26)),
                        ),
                        const Positioned(
                          left: -14,
                          bottom: 40,
                          child: Text('🌼', style: TextStyle(fontSize: 22)),
                        ),
                        const Positioned(
                          right: -12,
                          bottom: 70,
                          child: Text('🍃', style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ClayButton(
                    color: const Color(0xFF17C3BA),
                    height: 72,
                    onTap: onPlayAgain,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Let's Play Again!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    color: Color(0x40005550),
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ClayButton(
                    color: const Color(0xFFFFF8EC),
                    height: 54,
                    width: 200,
                    onTap: onHome,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🏠', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 10),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: navy,
                            fontSize: 22,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clay pill button with a squish on press.
class _ClayButton extends StatefulWidget {
  const _ClayButton({
    required this.color,
    required this.height,
    required this.onTap,
    required this.child,
    this.width,
  });

  final Color color;
  final double height;
  final double? width;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<_ClayButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: Duration(milliseconds: _pressed ? 100 : 420),
        curve: _pressed ? Curves.easeOut : Curves.elasticOut,
        scale: _pressed ? 0.95 : 1,
        child: SizedBox(
          height: widget.height,
          width: widget.width ?? double.infinity,
          child: ClaySurface(
            color: widget.color,
            radius: widget.height / 2,
            depth: 0.7,
            pressed: _pressed,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.emoji,
    required this.label,
    required this.value,
    this.divider = true,
  });

  final String emoji;
  final String label;
  final String value;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            emoji,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              border: divider
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFEDE3D2), width: 1.2),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2F55),
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 64),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF4E6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF169A63),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Cream clay pause card with a teal rim, flower corners and big,
/// toddler-safe buttons. Pops in with a soft bounce.
class _PauseMenu extends StatelessWidget {
  const _PauseMenu({
    required this.showDone,
    required this.onResume,
    required this.onParent,
    required this.onDone,
    required this.onHome,
  });

  final bool showDone;
  final VoidCallback onResume;
  final VoidCallback onParent;
  final VoidCallback onDone;
  final VoidCallback onHome;

  static const _teal = Color(0xFF17B8AE);
  static const _navy = Color(0xFF1F2F55);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0B1E3A).withValues(alpha: 0.45),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, s, child) =>
              Transform.scale(scale: s, child: child),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38),
                      border: Border.all(color: _teal, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: ClaySurface(
                      color: const Color(0xFFFFF8EC),
                      radius: 34,
                      depth: 0.4,
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 84,
                            height: 84,
                            child: ClaySurface(
                              color: Color(0xFF3B8BF5),
                              radius: 42,
                              depth: 0.6,
                              child: Center(
                                child: Icon(
                                  Icons.pause_rounded,
                                  color: Colors.white,
                                  size: 52,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Paused',
                            style: TextStyle(
                              fontSize: 40,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              color: _navy,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ClayButton(
                            color: _teal,
                            height: 62,
                            onTap: onResume,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Keep Playing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _OutlinePill(
                            icon: Icons.tune_rounded,
                            label: 'Parent Settings',
                            onTap: onParent,
                          ),
                          if (showDone) ...[
                            const SizedBox(height: 10),
                            _OutlinePill(
                              icon: Icons.check_circle_outline_rounded,
                              label: 'Done Playing',
                              onTap: onDone,
                            ),
                          ],
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: onHome,
                            style: TextButton.styleFrom(
                              foregroundColor: _navy,
                              minimumSize: const Size(160, 48),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🏠', style: TextStyle(fontSize: 24)),
                                SizedBox(width: 10),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: -14,
                    top: -16,
                    child: Text('🌼', style: TextStyle(fontSize: 30)),
                  ),
                  const Positioned(
                    left: 12,
                    top: -18,
                    child: Text('🍃', style: TextStyle(fontSize: 22)),
                  ),
                  const Positioned(
                    right: -14,
                    top: -16,
                    child: Text('🌼', style: TextStyle(fontSize: 30)),
                  ),
                  const Positioned(
                    right: 12,
                    top: -18,
                    child: Text('🍃', style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _teal = Color(0xFF119A92);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const StadiumBorder(
        side: BorderSide(color: Color(0xFF17B8AE), width: 2.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _teal, size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: _teal,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
