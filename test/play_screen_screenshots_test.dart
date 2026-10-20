import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_thinker_sort/data/repositories/asset_game_content_repository.dart';
import 'package:tiny_thinker_sort/domain/entities/game_ids.dart';
import 'package:tiny_thinker_sort/domain/entities/sortable_item.dart';
import 'package:tiny_thinker_sort/games/sorting_engine/sorting_engine.dart';
import 'package:tiny_thinker_sort/games/sorting_engine/sorting_play_screen.dart';
import 'package:tiny_thinker_sort/presentation/providers/game_library.dart';
import 'package:tiny_thinker_sort/widgets/app_background.dart';

/// Headless captures of the three picture-sorting games.
///
/// Regenerate with:
/// `flutter test test/play_screen_screenshots_test.dart --update-goldens`
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameLibrary library;

  setUpAll(() async {
    library = GameLibrary(await AssetGameContentRepository.load());
  });

  testWidgets('play screens draw item pictures inside the bubbles', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 860));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _capture(
      tester,
      library,
      GameIds.indoorOutdoor,
      'indoor_outdoor_play',
      const ['puzzle', 'teddy', 'football', 'bicycle'],
    );
    await _capture(
      tester,
      library,
      GameIds.bigSmall,
      'big_small_play',
      const ['elephant', 'ship', 'mouse', 'apple'],
    );
    await _capture(
      tester,
      library,
      GameIds.animalSort,
      'pet_wild_play',
      const ['dog', 'cat', 'lion', 'giraffe'],
    );
  });
}

Future<void> _capture(
  WidgetTester tester,
  GameLibrary library,
  String gameId,
  String fileName,
  List<String> itemIds,
) async {
  final content = library.content(gameId);
  final pool = [for (final id in itemIds) content.itemById(id)!];
  final round = library.roundFor(gameId, 'mixed');

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TickerMode(
        enabled: false,
        child: RepaintBoundary(
          key: const Key('play-shot'),
          child: SortingPlayScreen(
            random: Random(4),
            title: content.playTitle,
            background: const AppBackground(),
            config: SortingEngineConfig(
              gameId: gameId,
              categories: round.categories,
              itemPool: pool,
              sessionSeconds: 90,
              maxFloating: pool.length,
              speedMultiplier: 0,
              floatingAnimation: false,
              reducedMotion: true,
              itemSize: 108,
              celebrationsEnabled: false,
              voiceEnabled: false,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final context = tester.element(find.byType(SortingPlayScreen));
  await tester.runAsync(() async {
    await precacheImage(const AssetImage(AppBackground.assetPath), context);
    for (final item in pool) {
      await precacheImage(AssetImage(item.imageAsset!), context);
    }
  });
  await tester.pump();
  await tester.pump();

  expect(_itemImages(pool), findsNWidgets(pool.length));
  await expectLater(
    find.byKey(const Key('play-shot')),
    matchesGoldenFile('../screenshots/$fileName.png'),
  );

  await tester.pumpWidget(const SizedBox.shrink());
}

Finder _itemImages(List<SortableItem> pool) {
  final names = pool.map((item) => item.imageAsset).toSet();
  return find.byWidgetPredicate((widget) {
    if (widget is! Image) return false;
    final provider = widget.image;
    return provider is AssetImage && names.contains(provider.assetName);
  });
}
