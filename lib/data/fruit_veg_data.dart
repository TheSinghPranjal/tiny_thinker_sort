import 'package:flutter/material.dart';

import '../models/game_definition.dart';
import '../models/parent_settings.dart';
import '../theme/sortjoy_theme.dart';

abstract final class FruitVegData {
  static const fruits = SortCategory(
    id: 'fruits',
    label: 'Fruits',
    emoji: '🍎',
    color: 0xFFFF8A65,
  );

  static const vegetables = SortCategory(
    id: 'vegetables',
    label: 'Vegetables',
    emoji: '🥕',
    color: 0xFF81C784,
  );

  static const categories = [fruits, vegetables];

  static const items = <SortableItem>[
    SortableItem(id: 'apple', name: 'Apple', emoji: '🍎', categoryId: 'fruits'),
    SortableItem(id: 'banana', name: 'Banana', emoji: '🍌', categoryId: 'fruits'),
    SortableItem(id: 'orange', name: 'Orange', emoji: '🍊', categoryId: 'fruits'),
    SortableItem(id: 'grapes', name: 'Grapes', emoji: '🍇', categoryId: 'fruits'),
    SortableItem(id: 'mango', name: 'Mango', emoji: '🥭', categoryId: 'fruits'),
    SortableItem(id: 'strawberry', name: 'Strawberry', emoji: '🍓', categoryId: 'fruits'),
    SortableItem(id: 'pineapple', name: 'Pineapple', emoji: '🍍', categoryId: 'fruits'),
    SortableItem(id: 'pear', name: 'Pear', emoji: '🍐', categoryId: 'fruits'),
    SortableItem(id: 'cherries', name: 'Cherries', emoji: '🍒', categoryId: 'fruits'),
    SortableItem(id: 'watermelon', name: 'Watermelon', emoji: '🍉', categoryId: 'fruits'),
    SortableItem(id: 'peach', name: 'Peach', emoji: '🍑', categoryId: 'fruits'),
    SortableItem(id: 'kiwi', name: 'Kiwi', emoji: '🥝', categoryId: 'fruits'),
    SortableItem(id: 'blueberry', name: 'Blueberry', emoji: '🫐', categoryId: 'fruits'),
    SortableItem(id: 'lemon', name: 'Lemon', emoji: '🍋', categoryId: 'fruits'),
    SortableItem(id: 'carrot', name: 'Carrot', emoji: '🥕', categoryId: 'vegetables'),
    SortableItem(id: 'tomato', name: 'Tomato', emoji: '🍅', categoryId: 'vegetables'),
    SortableItem(id: 'cucumber', name: 'Cucumber', emoji: '🥒', categoryId: 'vegetables'),
    SortableItem(id: 'potato', name: 'Potato', emoji: '🥔', categoryId: 'vegetables'),
    SortableItem(id: 'onion', name: 'Onion', emoji: '🧅', categoryId: 'vegetables'),
    SortableItem(id: 'broccoli', name: 'Broccoli', emoji: '🥦', categoryId: 'vegetables'),
    SortableItem(id: 'corn', name: 'Corn', emoji: '🌽', categoryId: 'vegetables'),
    SortableItem(id: 'eggplant', name: 'Eggplant', emoji: '🍆', categoryId: 'vegetables'),
    SortableItem(id: 'pumpkin', name: 'Pumpkin', emoji: '🎃', categoryId: 'vegetables'),
    SortableItem(id: 'peas', name: 'Peas', emoji: '🫛', categoryId: 'vegetables'),
    SortableItem(id: 'pepper', name: 'Bell Pepper', emoji: '🫑', categoryId: 'vegetables'),
    SortableItem(id: 'lettuce', name: 'Lettuce', emoji: '🥬', categoryId: 'vegetables'),
    SortableItem(id: 'garlic', name: 'Garlic', emoji: '🧄', categoryId: 'vegetables'),
    SortableItem(id: 'avocado', name: 'Avocado', emoji: '🥑', categoryId: 'vegetables'),
  ];

  static List<SortableItem> itemsForMode(FruitVegMode mode) {
    return switch (mode) {
      FruitVegMode.mixed => items,
      FruitVegMode.fruitsOnly =>
        items.where((i) => i.categoryId == 'fruits').toList(),
      FruitVegMode.vegetablesOnly =>
        items.where((i) => i.categoryId == 'vegetables').toList(),
    };
  }

  static List<SortCategory> categoriesForMode(FruitVegMode mode) {
    return switch (mode) {
      FruitVegMode.mixed => categories,
      FruitVegMode.fruitsOnly => [fruits],
      FruitVegMode.vegetablesOnly => [vegetables],
    };
  }

  static Color colorFor(String categoryId) {
    return switch (categoryId) {
      'fruits' => SortJoyColors.fruitBasket,
      'vegetables' => SortJoyColors.vegBasket,
      _ => SortJoyColors.mint,
    };
  }
}
