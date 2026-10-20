import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiny_thinker_sort/data/models/game_content_model.dart';
import 'package:tiny_thinker_sort/data/repositories/asset_game_content_repository.dart';
import 'package:tiny_thinker_sort/domain/entities/age_world.dart';
import 'package:tiny_thinker_sort/domain/entities/game_ids.dart';
import 'package:tiny_thinker_sort/domain/usecases/resolve_sorting_round.dart';
import 'package:tiny_thinker_sort/models/game_settings/healthy_food_settings.dart';
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

    expect(
      content.items.where((i) => i.categoryId == 'pet').map((i) => i.id),
      pets,
    );
    expect(
      content.items.where((i) => i.categoryId == 'wild').map((i) => i.id),
      wild,
    );
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

  test('healthy food vs treats is playable from both home worlds', () {
    final little = library.repository.byId(GameIds.healthyFood)!;
    final tiny = library.repository.byId(GameIds.healthyTreats)!;

    expect(little.implemented, isTrue);
    expect(tiny.implemented, isTrue);
    expect(little.hasParentControls, isTrue);
    expect(tiny.hasParentControls, isTrue);
    expect(little.title, 'Healthy Food vs Treats');
    expect(tiny.title, 'Healthy Food vs Treats');
    expect(little.ageWorld, AgeWorld.littleExplorers);
    expect(tiny.ageWorld, AgeWorld.tinyLearners);
    expect(
      library.gamesFor(AgeWorld.littleExplorers).map((game) => game.id),
      contains(GameIds.healthyFood),
    );
    expect(
      library.gamesFor(AgeWorld.tinyLearners).map((game) => game.id),
      contains(GameIds.healthyTreats),
    );
    expect(library.repository.hasContent(GameIds.healthyTreats), isTrue);
  });

  test('every healthy food item has an icon and the right category', () async {
    const healthy = [
      'apple',
      'banana',
      'strawberry',
      'grapes',
      'carrot',
      'broccoli',
      'cucumber',
      'orange',
      'mango',
      'watermelon',
      'pineapple',
      'lettuce',
      'kiwi',
      'corn',
      'potato',
      'pear',
    ];
    const treats = [
      'burger',
      'pizza',
      'fries',
      'hot_dog',
      'donut',
      'cookie',
      'chocolate',
      'cake',
      'noodles',
      'soda',
      'candy',
      'cupcake',
      'lollipop',
      'popcorn',
    ];

    final foodRaw = await rootBundle.loadString(
      'assets/data/healthy_food.json',
    );
    final catalogRaw = await rootBundle.loadString('assets/data/catalog.json');
    expect(foodRaw.toLowerCase(), isNot(contains('junk food')));
    expect(catalogRaw.toLowerCase(), isNot(contains('junk food')));
    expect(catalogRaw, isNot(contains('Learn to Sort')));

    final seen = <String>{};
    for (final gameId in [GameIds.healthyFood, GameIds.healthyTreats]) {
      final content = library.content(gameId);
      expect(content.playTitle, 'Healthy Food vs Treats');
      expect(content.categoryById('healthy')!.label, 'Healthy Food');
      expect(content.categoryById('junk')!.id, 'junk');
      expect(content.categoryById('junk')!.label, 'Treats');
      expect(content.voiceLabels['junk'], 'Treats!');
      expect(content.correctLabels['junk'], 'TREATS!');
      expect(content.celebrationSubtitle, 'You know healthy food and treats!');
      expect(
        content.items
            .where((item) => item.categoryId == 'healthy')
            .map((i) => i.id),
        healthy,
      );
      expect(
        content.items
            .where((item) => item.categoryId == 'junk')
            .map((i) => i.id),
        treats,
      );
      for (final item in content.items) {
        expect(item.imageAsset, 'assets/items/healthy_food/${item.id}.png');
        if (seen.add(item.imageAsset!)) {
          final data = await rootBundle.load(item.imageAsset!);
          expect(data.lengthInBytes, greaterThan(500), reason: item.imageAsset);
        }
      }
    }
    expect(seen, hasLength(healthy.length + treats.length));

    final saved = HealthyFoodSettings.fromJson({
      'difficulty': 'easy',
      'enabledHealthyIds': healthy.take(4).toList(),
      'enabledJunkIds': treats.take(4).toList(),
    });
    expect(saved.enabledJunkIds, treats.take(4).toList());
    expect(saved.enabledHealthyIds, healthy.take(4).toList());
    expect(saved.toJson()['enabledJunkIds'], treats.take(4).toList());
  });
}
