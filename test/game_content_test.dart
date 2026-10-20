import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_thinker_sort/data/models/game_content_model.dart';
import 'package:tiny_thinker_sort/data/repositories/asset_game_content_repository.dart';
import 'package:tiny_thinker_sort/domain/entities/game_ids.dart';
import 'package:tiny_thinker_sort/domain/usecases/resolve_sorting_round.dart';
import 'package:tiny_thinker_sort/presentation/providers/game_library.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameLibrary library;

  setUpAll(() async {
    library = GameLibrary(await AssetGameContentRepository.load());
  });

  test('catalog JSON parses and keeps every previous game', () async {
    final raw = await rootBundle.loadString('assets/data/catalog.json');
    final games = (jsonDecode(raw) as Map<String, dynamic>)['games'] as List;
    expect(games, hasLength(46));
    expect(library.repository.games, hasLength(46));

    final pet = library.repository.byId(GameIds.animalSort);
    expect(pet, isNotNull);
    expect(pet!.implemented, isTrue);
    expect(pet.hasParentControls, isTrue);
    expect(pet.title, 'Pet vs Wild');

    for (final id in [
      GameIds.fruitVeg,
      GameIds.indoorOutdoor,
      GameIds.bigSmall,
      GameIds.colorSort,
      GameIds.colorSchoolBags,
      GameIds.sortSocks,
      GameIds.flowerGarden,
      GameIds.healthyFood,
      GameIds.cleanDirty,
      GameIds.animalSort,
    ]) {
      expect(library.repository.hasContent(id), isTrue, reason: id);
    }
  });

  test('item JSON parses image paths, scales, and labels', () async {
    final raw = await rootBundle.loadString('assets/data/big_small.json');
    final content = GameContentModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    expect(content.items, hasLength(40));
    expect(content.itemById('elephant')!.visualScale, 1.3);
    expect(content.itemById('mouse')!.visualScale, 0.82);
    expect(content.itemById('marble')!.visualScale, 0.75);
    expect(
      content.itemById('ship')!.imageAsset,
      'assets/items/big_small/ship.png',
    );
    expect(content.categories.map((c) => c.id), ['big', 'small']);
    expect(content.modeById('bigOnly')!.categoryIds, ['big']);

    final indoor = library.content(GameIds.indoorOutdoor);
    expect(indoor.items, hasLength(36));
    expect(indoor.itemById('snakes_ladders')!.name, 'Snakes & Ladders');
    expect(indoor.itemById('snakes_ladders')!.emoji, '🐍');
  });

  test('every pictured item has an image asset that loads', () async {
    const pictured = [
      GameIds.indoorOutdoor,
      GameIds.bigSmall,
      GameIds.animalSort,
    ];
    final seen = <String>{};
    for (final gameId in pictured) {
      final content = library.content(gameId);
      expect(content.items, isNotEmpty);
      for (final item in content.items) {
        final path = item.imageAsset;
        expect(path, isNotNull, reason: '${item.id} is missing an image');
        expect(seen, isNot(contains(path)));
        seen.add(path!);
        final data = await rootBundle.load(path);
        expect(data.lengthInBytes, greaterThan(500), reason: path);
      }
    }
    expect(seen, hasLength(36 + 40 + 16));
  });

  test('pet versus wild classification matches the eight and eight', () {
    final content = library.content(GameIds.animalSort);
    const pets = [
      'dog',
      'cat',
      'rabbit',
      'fish',
      'parrot',
      'hamster',
      'turtle',
      'guinea_pig',
    ];
    const wild = [
      'lion',
      'tiger',
      'elephant',
      'giraffe',
      'zebra',
      'monkey',
      'bear',
      'crocodile',
    ];

    expect(content.items.where((i) => i.categoryId == 'pet').map((i) => i.id), pets);
    expect(content.items.where((i) => i.categoryId == 'wild').map((i) => i.id), wild);
    expect(content.categories.map((c) => c.zoneStyle), ['house', 'jungle']);
    expect(content.categoryById('pet')!.label, 'Pets');
    expect(content.categoryById('pet')!.caption, 'Cosy house');
    expect(content.categoryById('wild')!.label, 'Wild');
    expect(content.categoryById('wild')!.caption, 'Jungle');

    final petsOnly = const ResolveSortingRound()(content, 'petsOnly');
    expect(petsOnly.categories.map((c) => c.id), ['pet']);
    expect(petsOnly.items.map((item) => item.categoryId).toSet(), {'pet'});
    expect(petsOnly.items, hasLength(pets.length));
  });
}
