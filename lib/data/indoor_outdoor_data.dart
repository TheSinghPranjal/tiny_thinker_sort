import '../models/game_definition.dart';
import '../models/parent_settings.dart';

abstract final class IndoorOutdoorData {
  static const indoor = SortCategory(
    id: 'indoor',
    label: 'Indoor Games',
    emoji: '🏠',
    color: 0xFFFFB74D,
  );

  static const outdoor = SortCategory(
    id: 'outdoor',
    label: 'Outdoor Games',
    emoji: '🌳',
    color: 0xFF66BB6A,
  );

  static const categories = [indoor, outdoor];

  static const items = <SortableItem>[
    // Indoor
    SortableItem(id: 'puzzle', name: 'Puzzle', emoji: '🧩', categoryId: 'indoor'),
    SortableItem(id: 'blocks', name: 'Building Blocks', emoji: '🧱', categoryId: 'indoor'),
    SortableItem(id: 'board_game', name: 'Board Game', emoji: '🎲', categoryId: 'indoor'),
    SortableItem(id: 'coloring_book', name: 'Coloring Book', emoji: '🎨', categoryId: 'indoor'),
    SortableItem(id: 'toy_train', name: 'Toy Train', emoji: '🚂', categoryId: 'indoor'),
    SortableItem(id: 'toy_car', name: 'Toy Car', emoji: '🚙', categoryId: 'indoor'),
    SortableItem(id: 'doll', name: 'Doll', emoji: '🪆', categoryId: 'indoor'),
    SortableItem(id: 'piano', name: 'Piano', emoji: '🎹', categoryId: 'indoor'),
    SortableItem(id: 'drum', name: 'Drum', emoji: '🥁', categoryId: 'indoor'),
    SortableItem(id: 'chess', name: 'Chess', emoji: '♟️', categoryId: 'indoor'),
    SortableItem(id: 'ludo', name: 'Ludo', emoji: '🎯', categoryId: 'indoor'),
    SortableItem(id: 'snakes_ladders', name: 'Snakes & Ladders', emoji: '🐍', categoryId: 'indoor'),
    SortableItem(id: 'lego', name: 'Lego Bricks', emoji: '🧱', categoryId: 'indoor'),
    SortableItem(id: 'memory_cards', name: 'Memory Cards', emoji: '🃏', categoryId: 'indoor'),
    SortableItem(id: 'reading_book', name: 'Reading Book', emoji: '📖', categoryId: 'indoor'),
    SortableItem(id: 'teddy', name: 'Teddy Bear', emoji: '🧸', categoryId: 'indoor'),
    SortableItem(id: 'xylophone', name: 'Xylophone', emoji: '🎵', categoryId: 'indoor'),
    SortableItem(id: 'robot', name: 'Toy Robot', emoji: '🤖', categoryId: 'indoor'),

    // Outdoor
    SortableItem(id: 'football', name: 'Football', emoji: '⚽', categoryId: 'outdoor'),
    SortableItem(id: 'cricket', name: 'Cricket Bat', emoji: '🏏', categoryId: 'outdoor'),
    SortableItem(id: 'basketball', name: 'Basketball', emoji: '🏀', categoryId: 'outdoor'),
    SortableItem(id: 'badminton', name: 'Badminton', emoji: '🏸', categoryId: 'outdoor'),
    SortableItem(id: 'bicycle', name: 'Bicycle', emoji: '🚲', categoryId: 'outdoor'),
    SortableItem(id: 'tricycle', name: 'Tricycle', emoji: '🚲', categoryId: 'outdoor'),
    SortableItem(id: 'skipping_rope', name: 'Skipping Rope', emoji: '🪢', categoryId: 'outdoor'),
    SortableItem(id: 'kite', name: 'Kite', emoji: '🪁', categoryId: 'outdoor'),
    SortableItem(id: 'frisbee', name: 'Frisbee', emoji: '🥏', categoryId: 'outdoor'),
    SortableItem(id: 'roller_skates', name: 'Roller Skates', emoji: '🛼', categoryId: 'outdoor'),
    SortableItem(id: 'scooter', name: 'Scooter', emoji: '🛴', categoryId: 'outdoor'),
    SortableItem(id: 'swing', name: 'Swing', emoji: '🎠', categoryId: 'outdoor'),
    SortableItem(id: 'slide', name: 'Slide', emoji: '🛝', categoryId: 'outdoor'),
    SortableItem(id: 'tennis', name: 'Tennis Racket', emoji: '🎾', categoryId: 'outdoor'),
    SortableItem(id: 'volleyball', name: 'Volleyball', emoji: '🏐', categoryId: 'outdoor'),
    SortableItem(id: 'baseball', name: 'Baseball Bat', emoji: '⚾', categoryId: 'outdoor'),
    SortableItem(id: 'hula_hoop', name: 'Hula Hoop', emoji: '⭕', categoryId: 'outdoor'),
    SortableItem(id: 'bubble_wand', name: 'Bubble Wand', emoji: '🫧', categoryId: 'outdoor'),
  ];

  static List<SortableItem> itemsForMode(IndoorOutdoorMode mode) {
    return switch (mode) {
      IndoorOutdoorMode.mixed => items,
      IndoorOutdoorMode.indoorOnly =>
        items.where((i) => i.categoryId == 'indoor').toList(),
      IndoorOutdoorMode.outdoorOnly =>
        items.where((i) => i.categoryId == 'outdoor').toList(),
    };
  }

  static List<SortCategory> categoriesForMode(IndoorOutdoorMode mode) {
    return switch (mode) {
      IndoorOutdoorMode.mixed => categories,
      IndoorOutdoorMode.indoorOnly => [indoor],
      IndoorOutdoorMode.outdoorOnly => [outdoor],
    };
  }
}
