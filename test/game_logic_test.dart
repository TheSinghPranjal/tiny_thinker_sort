import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiny_thinker_sort/data/fruit_veg_data.dart';
import 'package:tiny_thinker_sort/games/sorting_engine/sorting_engine.dart';
import 'package:tiny_thinker_sort/models/game_modes.dart';
import 'package:tiny_thinker_sort/models/rewards.dart';
import 'package:tiny_thinker_sort/state/app_state.dart';

SortingEngine _engine({
  int sessionSeconds = 60,
  bool unlimited = false,
  double multiplier = 1.0,
  int coinsPerSort = 0,
  int starsPerSort = 0,
  bool coinRewards = true,
}) {
  final e = SortingEngine(
    config: SortingEngineConfig(
      gameId: 'fruit_veg_sort',
      categories: FruitVegData.categoriesForMode(FruitVegMode.mixed),
      itemPool: FruitVegData.itemsForMode(FruitVegMode.mixed),
      sessionSeconds: sessionSeconds,
      maxFloating: 3,
      speedMultiplier: 1,
      unlimitedSession: unlimited,
      rewardMultiplier: multiplier,
      coinsPerCorrectSort: coinsPerSort,
      starsPerCorrectSort: starsPerSort,
      coinRewardsEnabled: coinRewards,
    ),
    onChanged: () {},
  );
  e.start(const Size(400, 800));
  return e;
}

void _sortCorrect(SortingEngine e) {
  final item = e.items.first;
  expect(e.dropOnCategory(item.instanceId, item.item.categoryId), isTrue);
}

void _sortWrong(SortingEngine e) {
  final item = e.items.first;
  final wrong = item.item.categoryId == 'fruits' ? 'vegetables' : 'fruits';
  expect(e.dropOnCategory(item.instanceId, wrong), isFalse);
}

String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SortingEngine rewards', () {
    test('default games: 3 coins per sort, 1 star per 3 sorts', () {
      final e = _engine();
      for (var i = 0; i < 6; i++) {
        _sortCorrect(e);
      }
      expect(e.correctSorts, 6);
      expect(e.coins, 18);
      expect(e.stars, 2);
    });

    test('per-game rates and the parent multiplier apply', () {
      final e = _engine(coinsPerSort: 10, starsPerSort: 10, multiplier: 1.5);
      for (var i = 0; i < 4; i++) {
        _sortCorrect(e);
      }
      expect(e.coins, 60);
      expect(e.stars, 60);

      final d = _engine(multiplier: 2.0);
      for (var i = 0; i < 3; i++) {
        _sortCorrect(d);
      }
      expect(d.coins, 18);
      expect(d.stars, 2);
    });

    test('coin rewards off earns no coins', () {
      final e = _engine(coinRewards: false);
      _sortCorrect(e);
      expect(e.coins, 0);
    });

    test('wrong drops never take rewards but restart the streak', () {
      final e = _engine();
      _sortCorrect(e);
      _sortCorrect(e);
      final coins = e.coins;
      _sortWrong(e);
      expect(e.coins, coins);
      expect(e.correctSorts, 2);
      expect(e.currentStreak, 0);
      _sortCorrect(e);
      expect(e.currentStreak, 1);
      expect(e.longestStreak, 2);
    });

    test('the field refills after every correct sort', () {
      final e = _engine();
      for (var i = 0; i < 5; i++) {
        _sortCorrect(e);
        expect(e.items.length, 3);
      }
    });
  });

  group('SortingEngine timer', () {
    test('timed session ends on wall-clock time', () async {
      final e = _engine(sessionSeconds: 1);
      expect(e.remainingSeconds, 1);
      final sw = Stopwatch()..start();
      while (!e.finished && sw.elapsedMilliseconds < 3000) {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        e.tick();
      }
      expect(e.finished, isTrue);
      expect(sw.elapsedMilliseconds, inInclusiveRange(950, 1500));
    });

    test('pause freezes the clock', () async {
      final e = _engine(sessionSeconds: 1);
      e.togglePause();
      for (var i = 0; i < 40; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        e.tick();
      }
      expect(e.finished, isFalse);
      expect(e.remainingSeconds, 1);
    });

    test('backgrounding pauses; practice mode never ends', () async {
      final e = _engine(sessionSeconds: 1);
      e.pauseForBackground();
      expect(e.paused, isTrue);

      final p = _engine(sessionSeconds: 1, unlimited: true);
      for (var i = 0; i < 45; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        p.tick();
      }
      expect(p.finished, isFalse);
      p.finishNow();
      expect(p.finished, isTrue);
    });
  });

  group('AppState progress', () {
    Future<AppState> load(Map<String, Object> prefs) async {
      SharedPreferences.setMockInitialValues(prefs);
      final app = AppState();
      await app.load();
      return app;
    }

    test('saved rewards equal what the HUD showed', () async {
      final app = await load({});
      final r = await app.applySessionResult(
        gameId: 'g',
        correctSorts: 5,
        categoryCounts: const {},
        longestStreak: 5,
        coinsEarned: 50,
        starsEarned: 50,
      );
      expect(r.coinsEarned, 50);
      expect(app.rewards.coins, 50);
      expect(app.rewards.stars, 50);
      expect(app.rewards.xp, 25);
      expect(app.currentStreak, 1);
      expect(r.newBadges, containsAll(['Super Sorter', 'Hot Streak']));
    });

    test(
      'free tier stops after 5 plays per game; premium is unlimited',
      () async {
        final app = await load({});
        for (var i = 0; i < RewardsState.freePlaysPerGame; i++) {
          expect(app.canPlayGame('g'), isTrue);
          await app.applySessionResult(
            gameId: 'g',
            correctSorts: 1,
            categoryCounts: const {},
            longestStreak: 1,
            coinsEarned: 3,
            starsEarned: 0,
          );
        }
        expect(app.canPlayGame('g'), isFalse);
        expect(app.remainingPlays('g'), 0);
        expect(app.canPlayGame('other'), isTrue);
        await app.setPremium(true);
        expect(app.canPlayGame('g'), isTrue);
      },
    );

    test('yesterday\'s plays don\'t count today; streak continues', () async {
      final yesterday = _dayKey(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      final app = await load({
        'sortjoy_rewards':
            '{"coins":0,"stars":0,"xp":0,"dailyStreak":4,'
            '"lastPlayDay":"$yesterday","badges":[],"playsToday":{"g":5}}',
      });
      expect(app.canPlayGame('g'), isTrue);
      expect(app.currentStreak, 4);
      await app.applySessionResult(
        gameId: 'g',
        correctSorts: 1,
        categoryCounts: const {},
        longestStreak: 1,
        coinsEarned: 3,
        starsEarned: 0,
      );
      expect(app.rewards.dailyStreak, 5);
      expect(app.playsTodayFor('g'), 1);
    });

    test('missing a day shows the streak as 0, then restarts at 1', () async {
      final old = _dayKey(DateTime.now().subtract(const Duration(days: 3)));
      final app = await load({
        'sortjoy_rewards':
            '{"coins":0,"stars":0,"xp":0,"dailyStreak":4,'
            '"lastPlayDay":"$old","badges":[],"playsToday":{}}',
      });
      expect(app.currentStreak, 0);
      await app.applySessionResult(
        gameId: 'g',
        correctSorts: 0,
        categoryCounts: const {},
        longestStreak: 0,
        coinsEarned: 0,
        starsEarned: 0,
      );
      expect(app.currentStreak, 1);
    });
  });
}
