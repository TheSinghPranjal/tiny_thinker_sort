import '../models/game_definition.dart';
import '../models/parent_settings.dart';

abstract final class BigSmallData {
  static const big = SortCategory(
    id: 'big',
    label: 'Big Objects',
    emoji: '🐘',
    color: 0xFF7E57C2,
  );

  static const small = SortCategory(
    id: 'small',
    label: 'Small Objects',
    emoji: '🐭',
    color: 0xFFFF8A65,
  );

  static const categories = [big, small];

  static const items = <SortableItem>[
    // Big
    SortableItem(id: 'ship', name: 'Ship', emoji: '🚢', categoryId: 'big', visualScale: 1.25),
    SortableItem(id: 'house', name: 'House', emoji: '🏠', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'tree', name: 'Tree', emoji: '🌳', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'airplane', name: 'Airplane', emoji: '✈️', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'bus', name: 'Bus', emoji: '🚌', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'train', name: 'Train', emoji: '🚂', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'elephant', name: 'Elephant', emoji: '🐘', categoryId: 'big', visualScale: 1.3),
    SortableItem(id: 'giraffe', name: 'Giraffe', emoji: '🦒', categoryId: 'big', visualScale: 1.25),
    SortableItem(id: 'whale', name: 'Whale', emoji: '🐋', categoryId: 'big', visualScale: 1.3),
    SortableItem(id: 'mountain', name: 'Mountain', emoji: '⛰️', categoryId: 'big', visualScale: 1.25),
    SortableItem(id: 'building', name: 'Building', emoji: '🏢', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'truck', name: 'Truck', emoji: '🚚', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'hot_air_balloon', name: 'Hot Air Balloon', emoji: '🎈', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'windmill', name: 'Windmill', emoji: '🌬️', categoryId: 'big', visualScale: 1.15),
    SortableItem(id: 'dinosaur', name: 'Dinosaur', emoji: '🦕', categoryId: 'big', visualScale: 1.25),
    SortableItem(id: 'castle', name: 'Castle', emoji: '🏰', categoryId: 'big', visualScale: 1.25),
    SortableItem(id: 'bridge', name: 'Bridge', emoji: '🌉', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'rocket', name: 'Rocket', emoji: '🚀', categoryId: 'big', visualScale: 1.2),
    SortableItem(id: 'water_tank', name: 'Water Tank', emoji: '🛢️', categoryId: 'big', visualScale: 1.15),
    SortableItem(id: 'ferris_wheel', name: 'Ferris Wheel', emoji: '🎡', categoryId: 'big', visualScale: 1.25),

    // Small
    SortableItem(id: 'mouse', name: 'Mouse', emoji: '🐭', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'book', name: 'Book', emoji: '📖', categoryId: 'small', visualScale: 0.85),
    SortableItem(id: 'pen', name: 'Pen', emoji: '🖊️', categoryId: 'small', visualScale: 0.8),
    SortableItem(id: 'pencil', name: 'Pencil', emoji: '✏️', categoryId: 'small', visualScale: 0.8),
    SortableItem(id: 'spoon', name: 'Spoon', emoji: '🥄', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'toothbrush', name: 'Toothbrush', emoji: '🪥', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'key', name: 'Key', emoji: '🔑', categoryId: 'small', visualScale: 0.8),
    SortableItem(id: 'coin', name: 'Coin', emoji: '🪙', categoryId: 'small', visualScale: 0.78),
    SortableItem(id: 'apple', name: 'Apple', emoji: '🍎', categoryId: 'small', visualScale: 0.85),
    SortableItem(id: 'cup', name: 'Cup', emoji: '☕', categoryId: 'small', visualScale: 0.85),
    SortableItem(id: 'toy_car', name: 'Toy Car', emoji: '🚗', categoryId: 'small', visualScale: 0.85),
    SortableItem(id: 'butterfly', name: 'Butterfly', emoji: '🦋', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'leaf', name: 'Leaf', emoji: '🍃', categoryId: 'small', visualScale: 0.8),
    SortableItem(id: 'flower', name: 'Flower', emoji: '🌸', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'cricket_ball', name: 'Cricket Ball', emoji: '🏏', categoryId: 'small', visualScale: 0.85),
    SortableItem(id: 'marble', name: 'Marble', emoji: '🔵', categoryId: 'small', visualScale: 0.75),
    SortableItem(id: 'eraser', name: 'Eraser', emoji: '🧽', categoryId: 'small', visualScale: 0.8),
    SortableItem(id: 'button', name: 'Button', emoji: '🔘', categoryId: 'small', visualScale: 0.75),
    SortableItem(id: 'scissors', name: 'Scissors', emoji: '✂️', categoryId: 'small', visualScale: 0.82),
    SortableItem(id: 'watch', name: 'Wrist Watch', emoji: '⌚', categoryId: 'small', visualScale: 0.82),
  ];

  static List<SortableItem> itemsForMode(BigSmallMode mode) {
    return switch (mode) {
      BigSmallMode.mixed => items,
      BigSmallMode.bigOnly =>
        items.where((i) => i.categoryId == 'big').toList(),
      BigSmallMode.smallOnly =>
        items.where((i) => i.categoryId == 'small').toList(),
    };
  }

  static List<SortCategory> categoriesForMode(BigSmallMode mode) {
    return switch (mode) {
      BigSmallMode.mixed => categories,
      BigSmallMode.bigOnly => [big],
      BigSmallMode.smallOnly => [small],
    };
  }
}
