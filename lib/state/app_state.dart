import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/age_world.dart';
import '../models/parent_settings.dart';
import '../models/rewards.dart';
import 'game_settings_store.dart';

class AppState extends ChangeNotifier {
  AppState();

  static const _keyOnboarded = 'sortjoy_onboarded';
  static const _keyAge = 'sortjoy_age_world';
  static const _keySettings = 'sortjoy_settings';
  static const _keyRewards = 'sortjoy_rewards';

  bool ready = false;
  bool onboarded = false;
  AgeWorld? ageWorld;
  ParentSettings settings = const ParentSettings();
  RewardsState rewards = const RewardsState();
  final GameSettingsStore gameSettings = GameSettingsStore();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    onboarded = prefs.getBool(_keyOnboarded) ?? false;
    final ageKey = prefs.getString(_keyAge);
    if (ageKey != null) {
      ageWorld = AgeWorld.values.firstWhere(
        (e) => e.storageKey == ageKey,
        orElse: () => AgeWorld.tinyLearners,
      );
    }

    Map<String, dynamic>? legacySettings;
    final settingsRaw = prefs.getString(_keySettings);
    if (settingsRaw != null) {
      try {
        final map = jsonDecode(settingsRaw) as Map<String, dynamic>;
        settings = ParentSettings.fromJson(map);
        // Keep full map for one-time migration into per-game keys.
        if (map.containsKey('sessionSeconds') ||
            map.containsKey('fruitVegMode') ||
            map.containsKey('colorSchoolBagsDifficulty')) {
          legacySettings = map;
        }
      } catch (_) {
        settings = const ParentSettings();
      }
    }

    final rewardsRaw = prefs.getString(_keyRewards);
    if (rewardsRaw != null) {
      rewards = RewardsState.fromJson(
        jsonDecode(rewardsRaw) as Map<String, dynamic>,
      );
    }
    rewards = _rollDailyIfNeeded(rewards);

    await gameSettings.load(legacySettings: legacySettings);
    gameSettings.addListener(_onGameSettingsChanged);

    // Persist slim global settings if we still had a monolithic blob.
    if (legacySettings != null) {
      await prefs.setString(_keySettings, jsonEncode(settings.toJson()));
    }

    ready = true;
    notifyListeners();
  }

  void _onGameSettingsChanged() => notifyListeners();

  @override
  void dispose() {
    gameSettings.removeListener(_onGameSettingsChanged);
    gameSettings.dispose();
    super.dispose();
  }

  RewardsState _rollDailyIfNeeded(RewardsState current) {
    final today = _todayKey();
    if (current.lastPlayDay == today) return current;
    if (current.lastPlayDay.isEmpty) {
      return current.copyWith(playsToday: {});
    }
    return current.copyWith(playsToday: {});
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  /// Profile level derived from XP (calm, parent-friendly progression).
  int get profileLevel => (rewards.xp ~/ 50) + 1;

  int playsTodayFor(String gameId) => rewards.playsFor(gameId);

  Future<void> completeOnboarding(AgeWorld world) async {
    ageWorld = world;
    onboarded = true;
    await _persist();
    notifyListeners();
  }

  Future<void> setAgeWorld(AgeWorld world) async {
    ageWorld = world;
    await _persist();
    notifyListeners();
  }

  Future<void> updateSettings(ParentSettings next) async {
    settings = next;
    await _persist();
    notifyListeners();
  }

  Future<void> setPremium(bool value) async {
    await updateSettings(settings.copyWith(isPremium: value));
  }

  Future<void> resetProgress() async {
    rewards = const RewardsState();
    await _persist();
    notifyListeners();
  }

  bool canPlayGame(String gameId) =>
      rewards.canPlay(gameId, isPremium: settings.isPremium);

  int remainingPlays(String gameId) =>
      rewards.remainingPlays(gameId, isPremium: settings.isPremium);

  /// Records a completed play toward the free-tier daily limit.
  Future<void> recordPlay(String gameId) async {
    final today = _todayKey();
    final plays = Map<String, int>.from(rewards.playsToday);
    plays[gameId] = (plays[gameId] ?? 0) + 1;
    rewards = rewards.copyWith(playsToday: plays, lastPlayDay: today);
    await _persist();
    notifyListeners();
  }

  Future<SessionResult> applySessionResult({
    required String gameId,
    required int correctSorts,
    required Map<String, int> categoryCounts,
    required int longestStreak,
    double rewardMultiplier = 1.0,
    bool coinRewardsEnabled = true,
  }) async {
    final today = _todayKey();
    var next = rewards;

    var streak = next.dailyStreak;
    if (next.lastPlayDay != today) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';
      streak = next.lastPlayDay == yKey ? streak + 1 : 1;
    }

    final mult = rewardMultiplier.clamp(0.5, 2.0);
    final rawCoins = coinRewardsEnabled ? (correctSorts * 3 * mult).round() : 0;
    final stars = (correctSorts / 3 * mult).floor().clamp(0, 99);
    final xp = (correctSorts * 5 * mult).round();

    final plays = Map<String, int>.from(next.playsToday);
    plays[gameId] = (plays[gameId] ?? 0) + 1;

    final badges = Set<String>.from(next.badges);
    final unlocked = <String>[];
    void unlock(String id, String label) {
      if (badges.add(id)) unlocked.add(label);
    }

    if (correctSorts >= 5) unlock('sorter_5', 'Super Sorter');
    if (correctSorts >= 15) unlock('sorter_15', 'Sorting Star');
    if (longestStreak >= 5) unlock('streak_5', 'Hot Streak');
    if (streak >= 3) unlock('daily_3', '3-Day Sparkle');
    if ((next.coins + rawCoins) >= 100) unlock('coins_100', 'Coin Collector');

    next = next.copyWith(
      coins: next.coins + rawCoins,
      stars: next.stars + stars,
      xp: next.xp + xp,
      dailyStreak: streak,
      lastPlayDay: today,
      badges: badges,
      playsToday: plays,
    );
    rewards = next;
    await _persist();
    notifyListeners();

    return SessionResult(
      gameId: gameId,
      correctSorts: correctSorts,
      categoryCounts: categoryCounts,
      coinsEarned: rawCoins,
      starsEarned: stars,
      xpEarned: xp,
      longestStreak: longestStreak,
      newBadges: unlocked,
    );
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarded, onboarded);
    if (ageWorld != null) {
      await prefs.setString(_keyAge, ageWorld!.storageKey);
    }
    await prefs.setString(_keySettings, jsonEncode(settings.toJson()));
    await prefs.setString(_keyRewards, jsonEncode(rewards.toJson()));
  }
}
