import 'dart:math';
import 'dart:ui';

import '../../models/game_definition.dart';

class FloatingSortItem {
  FloatingSortItem({
    required this.instanceId,
    required this.item,
    required this.position,
    required this.velocity,
    required this.bobPhase,
  });

  final String instanceId;
  final SortableItem item;
  Offset position;
  Offset velocity;
  double bobPhase;
  bool dragging = false;
  int missCount = 0;
}

class SortingEngineConfig {
  const SortingEngineConfig({
    required this.gameId,
    required this.categories,
    required this.itemPool,
    required this.sessionSeconds,
    required this.maxFloating,
    required this.speedMultiplier,
    this.voiceEnabled = true,
    this.celebrationsEnabled = true,
    this.celebrationSubtitle = "You're Becoming a Super Sorter!",
    this.starsPerCorrectSort = 0,
    this.coinsPerCorrectSort = 0,
    this.celebrateEveryN = 0,
    this.unlimitedSession = false,
    this.snapPadding = 0,
    this.itemSize = 72,
    this.bookShape = false,
    this.flowerShape = false,
    this.flowerPotShape = false,
    this.categoryEmoji,
    this.hideCoinHud = false,
    this.foodBubbleShape = false,
    this.toddlerZones = false,
    this.wrongDropMessage,
    this.correctCategoryLabels,
    this.categoryVoiceLabels,
  });

  final String gameId;
  final List<SortCategory> categories;
  final List<SortableItem> itemPool;
  final int sessionSeconds;
  final int maxFloating;
  final double speedMultiplier;
  final bool voiceEnabled;
  final bool celebrationsEnabled;
  final String celebrationSubtitle;

  /// When > 0, awards this many stars per correct sort (default: 1 every 3 sorts).
  final int starsPerCorrectSort;

  /// When > 0, awards this many coins per correct sort (default: 3).
  final int coinsPerCorrectSort;

  /// When > 0, shows a special celebration message every N correct sorts.
  final int celebrateEveryN;

  /// When true, the session timer never runs out.
  final bool unlimitedSession;

  /// Extra pixels around drop zones for toddler-friendly snapping.
  final double snapPadding;

  /// Touch target size for floating items (default 72).
  final double itemSize;

  /// Renders items as rounded books instead of circles.
  final bool bookShape;

  /// Renders items as a consistent flower shape (color varies by accent).
  final bool flowerShape;

  /// Renders drop zones as cartoon flower pots.
  final bool flowerPotShape;

  /// Overrides category emoji on drop baskets (e.g. backpack emoji).
  final String? categoryEmoji;

  /// Hides the coin counter in the play HUD.
  final bool hideCoinHud;

  /// White glossy bubble chips (Healthy Food game).
  final bool foodBubbleShape;

  /// Toddler character drop zones instead of baskets.
  final bool toddlerZones;

  /// Gentle wrong-match message (e.g. "Not this one!").
  final String? wrongDropMessage;

  /// Large result text per category on correct sort (e.g. HEALTHY!).
  final Map<String, String>? correctCategoryLabels;

  /// Spoken category phrase after food name (e.g. Healthy Food!).
  final Map<String, String>? categoryVoiceLabels;
}

class SortingEngineSnapshot {
  const SortingEngineSnapshot({
    required this.remainingSeconds,
    required this.coins,
    required this.stars,
    required this.correctSorts,
    required this.currentStreak,
    required this.longestStreak,
    required this.categoryCounts,
    required this.toastMessage,
    required this.voiceLabel,
    required this.paused,
    required this.finished,
    required this.guidanceCategoryId,
    required this.idleHint,
    required this.wrongDropCategoryId,
    required this.happyDropCategoryId,
  });

  final int remainingSeconds;
  final int coins;
  final int stars;
  final int correctSorts;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> categoryCounts;
  final String? toastMessage;
  final String? voiceLabel;
  final bool paused;
  final bool finished;
  final String? guidanceCategoryId;
  final bool idleHint;
  final String? wrongDropCategoryId;
  final String? happyDropCategoryId;
}

typedef SortingListener = void Function();

/// Shared session loop: float → drag → guide/celebrate → rewards → timer.
class SortingEngine {
  SortingEngine({
    required this.config,
    required this.onChanged,
    Random? random,
  }) : _random = random ?? Random();

  final SortingEngineConfig config;
  final SortingListener onChanged;
  final Random _random;

  final List<FloatingSortItem> items = [];
  final Map<String, int> categoryCounts = {};

  int remainingSeconds = 0;
  int coins = 0;
  int stars = 0;
  int correctSorts = 0;
  int currentStreak = 0;
  int longestStreak = 0;
  bool paused = false;
  bool finished = false;
  String? toastMessage;
  String? voiceLabel;
  String? guidanceCategoryId;
  bool idleHint = false;
  String? wrongDropCategoryId;
  String? happyDropCategoryId;

  DateTime? _lastTick;
  DateTime? _lastInteraction;
  DateTime? _toastUntil;
  DateTime? _voiceUntil;
  DateTime? _guidanceUntil;
  DateTime? _reactionUntil;
  Size playSize = Size.zero;

  static const encouragements = [
    'Fantastic!',
    'Excellent!',
    'Amazing!',
    'Wonderful!',
    'Great Job!',
    'Perfect!',
    'Awesome Sorting!',
    'Perfect Match!',
    'Awesome!',
  ];

  void start(Size size) {
    playSize = size;
    remainingSeconds = config.sessionSeconds;
    _preciseRemaining = config.sessionSeconds.toDouble();
    finished = false;
    paused = false;
    coins = 0;
    stars = 0;
    correctSorts = 0;
    currentStreak = 0;
    longestStreak = 0;
    toastMessage = null;
    voiceLabel = null;
    guidanceCategoryId = null;
    idleHint = false;
    wrongDropCategoryId = null;
    happyDropCategoryId = null;
    _reactionUntil = null;
    _lastTick = DateTime.now();
    _lastInteraction = DateTime.now();
    categoryCounts.clear();
    for (final c in config.categories) {
      categoryCounts[c.id] = 0;
    }
    items.clear();
    while (items.length < config.maxFloating) {
      _spawnItem(initial: true);
    }
    onChanged();
  }

  void setPlaySize(Size size) {
    playSize = size;
  }

  void togglePause() {
    if (finished) return;
    paused = !paused;
    if (!paused) {
      _lastTick = DateTime.now();
      _lastInteraction = DateTime.now();
    }
    onChanged();
  }

  void tick() {
    if (finished || paused || playSize == Size.zero) return;
    final now = DateTime.now();
    final last = _lastTick ?? now;
    final dt = (now.difference(last).inMilliseconds / 1000.0).clamp(0.0, 0.05);
    _lastTick = now;

    if (!config.unlimitedSession) {
      _preciseRemaining -= dt;
      if (_preciseRemaining <= 0) {
        remainingSeconds = 0;
        finished = true;
        onChanged();
        return;
      }
      remainingSeconds =
          _preciseRemaining.ceil().clamp(0, config.sessionSeconds);
    } else {
      remainingSeconds = 0;
    }

    // Float undragged items
    for (final item in items) {
      if (item.dragging) continue;
      item.bobPhase += dt * 2.2;
      final bob = sin(item.bobPhase) * 10;
      var next = item.position + item.velocity * dt * config.speedMultiplier;
      next = Offset(next.dx, next.dy + bob * dt * 8);

      // Soft wrap / bounce inside play area (above baskets)
      final maxY = playSize.height * 0.55;
      if (next.dx < 20 || next.dx > playSize.width - 80) {
        item.velocity = Offset(-item.velocity.dx, item.velocity.dy);
        next = Offset(next.dx.clamp(20, playSize.width - 80), next.dy);
      }
      if (next.dy < 60 || next.dy > maxY) {
        item.velocity = Offset(item.velocity.dx, -item.velocity.dy);
        next = Offset(next.dx, next.dy.clamp(60, maxY));
      }
      item.position = next;
    }

    // Keep field full
    while (items.length < config.maxFloating) {
      _spawnItem();
    }

    // Clear transient UI
    if (_toastUntil != null && now.isAfter(_toastUntil!)) {
      toastMessage = null;
      _toastUntil = null;
    }
    if (_voiceUntil != null && now.isAfter(_voiceUntil!)) {
      voiceLabel = null;
      _voiceUntil = null;
    }
    if (_guidanceUntil != null && now.isAfter(_guidanceUntil!)) {
      guidanceCategoryId = null;
      _guidanceUntil = null;
    }
    if (_reactionUntil != null && now.isAfter(_reactionUntil!)) {
      wrongDropCategoryId = null;
      happyDropCategoryId = null;
      _reactionUntil = null;
    }

    // Idle help after a few seconds
    final idleMs = now.difference(_lastInteraction ?? now).inMilliseconds;
    idleHint = idleMs > 4000 && items.isNotEmpty;
    if (idleHint && guidanceCategoryId == null) {
      final target = items.first.item.categoryId;
      guidanceCategoryId = target;
    }

    onChanged();
  }

  double _preciseRemaining = 0;

  void beginDrag(String instanceId) {
    _lastInteraction = DateTime.now();
    idleHint = false;
    for (final item in items) {
      item.dragging = item.instanceId == instanceId;
    }
    onChanged();
  }

  void updateDrag(String instanceId, Offset position) {
    for (final item in items) {
      if (item.instanceId == instanceId) {
        item.position = position;
        break;
      }
    }
    onChanged();
  }

  /// Returns true if accepted (correct). Incorrect never punishes.
  bool dropOnCategory(String instanceId, String categoryId) {
    _lastInteraction = DateTime.now();
    idleHint = false;
    final idx = items.indexWhere((e) => e.instanceId == instanceId);
    if (idx < 0) return false;
    final floating = items[idx];
    floating.dragging = false;

    final correct = floating.item.categoryId == categoryId;
    if (correct) {
      _accept(floating, categoryId);
      items.removeAt(idx);
      _spawnItem();
      onChanged();
      return true;
    }

    // Gentle guidance — no penalty
    floating.missCount += 1;
    guidanceCategoryId = floating.item.categoryId;
    wrongDropCategoryId = categoryId;
    _guidanceUntil = DateTime.now().add(const Duration(seconds: 2));
    _reactionUntil = DateTime.now().add(const Duration(milliseconds: 1800));
    // Ease back slightly
    floating.position = Offset(
      floating.position.dx,
      (floating.position.dy - 40).clamp(60, playSize.height * 0.5),
    );
    final gentle = config.wrongDropMessage;
    if (gentle != null) {
      toastMessage = gentle;
      _toastUntil = DateTime.now().add(const Duration(seconds: 2));
    } else if (floating.missCount >= 2) {
      toastMessage = 'Try the ${_labelFor(floating.item.categoryId)} basket!';
      _toastUntil = DateTime.now().add(const Duration(seconds: 2));
    }
    onChanged();
    return false;
  }

  void cancelDrag(String instanceId) {
    for (final item in items) {
      if (item.instanceId == instanceId) {
        item.dragging = false;
        break;
      }
    }
    onChanged();
  }

  void _accept(FloatingSortItem floating, String categoryId) {
    correctSorts += 1;
    currentStreak += 1;
    if (currentStreak > longestStreak) longestStreak = currentStreak;
    coins += config.coinsPerCorrectSort > 0 ? config.coinsPerCorrectSort : 3;
    if (config.starsPerCorrectSort > 0) {
      stars += config.starsPerCorrectSort;
    } else if (correctSorts % 3 == 0) {
      stars += 1;
    }
    categoryCounts[categoryId] = (categoryCounts[categoryId] ?? 0) + 1;

    happyDropCategoryId = categoryId;
    _reactionUntil = DateTime.now().add(const Duration(milliseconds: 1400));

    final categoryLabel = config.correctCategoryLabels?[categoryId];
    if (config.celebrationsEnabled) {
      final specialEvery = config.celebrateEveryN;
      if (specialEvery > 0 && correctSorts % specialEvery == 0) {
        toastMessage = 'Amazing!';
      } else if (categoryLabel != null) {
        toastMessage = categoryLabel;
      } else {
        toastMessage = encouragements[_random.nextInt(encouragements.length)];
      }
      _toastUntil = DateTime.now().add(const Duration(milliseconds: 1600));
    }
    if (config.voiceEnabled) {
      final categoryVoice = config.categoryVoiceLabels?[categoryId];
      if (categoryVoice != null) {
        voiceLabel =
            '${floating.item.spokenName.toUpperCase()} · $categoryVoice';
      } else {
        voiceLabel = floating.item.spokenName.toUpperCase();
      }
      _voiceUntil = DateTime.now().add(const Duration(milliseconds: 1600));
    }
    guidanceCategoryId = null;
    wrongDropCategoryId = null;
  }

  String _labelFor(String categoryId) {
    return config.categories
        .firstWhere(
          (c) => c.id == categoryId,
          orElse: () => config.categories.first,
        )
        .label
        .toLowerCase();
  }

  void _spawnItem({bool initial = false}) {
    if (config.itemPool.isEmpty || playSize == Size.zero) return;
    final item = config.itemPool[_random.nextInt(config.itemPool.length)];
    final fromLeft = _random.nextBool();
    final y = 80.0 + _random.nextDouble() * (playSize.height * 0.35);
    final x = initial
        ? 40 + _random.nextDouble() * (playSize.width - 120)
        : (fromLeft ? -40.0 : playSize.width + 10);
    final speed = 28 + _random.nextDouble() * 40;
    final vx = fromLeft ? speed : -speed;
    final vy = (_random.nextDouble() - 0.5) * 20;
    items.add(
      FloatingSortItem(
        instanceId: '${item.id}_${_random.nextInt(1 << 30)}',
        item: item,
        position: Offset(x, y),
        velocity: Offset(vx, vy),
        bobPhase: _random.nextDouble() * pi * 2,
      ),
    );
  }

  SortingEngineSnapshot snapshot() => SortingEngineSnapshot(
        remainingSeconds: remainingSeconds,
        coins: coins,
        stars: stars,
        correctSorts: correctSorts,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        categoryCounts: Map.unmodifiable(categoryCounts),
        toastMessage: toastMessage,
        voiceLabel: voiceLabel,
        paused: paused,
        finished: finished,
        guidanceCategoryId: guidanceCategoryId,
        idleHint: idleHint,
        wrongDropCategoryId: wrongDropCategoryId,
        happyDropCategoryId: happyDropCategoryId,
      );
}
