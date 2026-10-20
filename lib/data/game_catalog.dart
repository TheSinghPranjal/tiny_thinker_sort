import '../domain/entities/game_ids.dart';

/// Id constants kept for call sites. The catalog itself is
/// `assets/data/catalog.json`, loaded by [GameContentRepository].
abstract final class GameCatalog {
  static const fruitVegId = GameIds.fruitVeg;
  static const indoorOutdoorId = GameIds.indoorOutdoor;
  static const colorSortId = GameIds.colorSort;
  static const bigSmallId = GameIds.bigSmall;
  static const colorSchoolBagsId = GameIds.colorSchoolBags;
  static const sortSocksId = GameIds.sortSocks;
  static const flowerGardenId = GameIds.flowerGarden;
  static const healthyFoodId = GameIds.healthyFood;
  static const cleanDirtyId = GameIds.cleanDirty;
  static const animalSortId = GameIds.animalSort;
}
