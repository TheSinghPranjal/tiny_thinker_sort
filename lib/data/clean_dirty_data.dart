import '../models/game_definition.dart';
import '../models/game_modes.dart';

/// Clean & Dirty Clothes Sort — Tiny Learners laundry helpers.
abstract final class CleanDirtyData {
  static const dirtyCategoryId = 'dirty';
  static const cleanCategoryId = 'clean';

  static const dirty = SortCategory(
    id: dirtyCategoryId,
    label: 'Washing Machine',
    emoji: '🫧',
    color: 0xFF4FC3F7,
  );

  static const clean = SortCategory(
    id: cleanCategoryId,
    label: 'Cupboard',
    emoji: '🚪',
    color: 0xFFFFB74D,
  );

  /// Left = washing machine (dirty), right = cupboard (clean).
  static const categories = [dirty, clean];

  static const items = <SortableItem>[
    // Clean clothes — bright & fresh
    SortableItem(
      id: 'clean_tshirt',
      name: 'T-Shirt',
      emoji: '👕',
      categoryId: cleanCategoryId,
      voiceName: 'Clean T-Shirt',
      accentColor: 0xFF42A5F5,
    ),
    SortableItem(
      id: 'clean_shirt',
      name: 'Shirt',
      emoji: '👔',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Shirt',
      accentColor: 0xFFEC407A,
    ),
    SortableItem(
      id: 'clean_polo',
      name: 'Polo Shirt',
      emoji: '👕',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Polo',
      accentColor: 0xFF66BB6A,
    ),
    SortableItem(
      id: 'clean_skirt',
      name: 'Skirt',
      emoji: '👗',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Skirt',
      accentColor: 0xFFAB47BC,
    ),
    SortableItem(
      id: 'clean_shorts',
      name: 'Shorts',
      emoji: '🩳',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Shorts',
      accentColor: 0xFFFFA726,
    ),
    SortableItem(
      id: 'clean_trousers',
      name: 'Trousers',
      emoji: '👖',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Trousers',
      accentColor: 0xFF5C6BC0,
    ),
    SortableItem(
      id: 'clean_jeans',
      name: 'Jeans',
      emoji: '👖',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Jeans',
      accentColor: 0xFF3949AB,
    ),
    SortableItem(
      id: 'clean_socks',
      name: 'Socks',
      emoji: '🧦',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Socks',
      accentColor: 0xFFEF5350,
    ),
    SortableItem(
      id: 'clean_hanky',
      name: 'Handkerchief',
      emoji: '🧻',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Handkerchief',
      accentColor: 0xFFFFEE58,
    ),
    SortableItem(
      id: 'clean_dress',
      name: 'Dress',
      emoji: '👗',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Dress',
      accentColor: 0xFFFF80AB,
    ),
    SortableItem(
      id: 'clean_jacket',
      name: 'Jacket',
      emoji: '🧥',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Jacket',
      accentColor: 0xFF26A69A,
    ),
    SortableItem(
      id: 'clean_sweater',
      name: 'Sweater',
      emoji: '🧶',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Sweater',
      accentColor: 0xFF8D6E63,
    ),
    SortableItem(
      id: 'clean_hoodie',
      name: 'Hoodie',
      emoji: '🧥',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Hoodie',
      accentColor: 0xFF7E57C2,
    ),
    SortableItem(
      id: 'clean_pajamas',
      name: 'Pajamas',
      emoji: '🛌',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Pajamas',
      accentColor: 0xFF29B6F6,
    ),
    SortableItem(
      id: 'clean_baby',
      name: 'Baby Clothes',
      emoji: '👶',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Baby Clothes',
      accentColor: 0xFFFFCC80,
    ),
    SortableItem(
      id: 'clean_towel',
      name: 'Towel',
      emoji: '🛁',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Towel',
      accentColor: 0xFF80CBC4,
    ),
    SortableItem(
      id: 'clean_cap',
      name: 'Cap',
      emoji: '🧢',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Cap',
      accentColor: 0xFFEF6C00,
    ),
    SortableItem(
      id: 'clean_mittens',
      name: 'Mittens',
      emoji: '🧤',
      categoryId: cleanCategoryId,
      voiceName: 'Clean Mittens',
      accentColor: 0xFFE57373,
    ),

    // Dirty clothes — still cute, with playful stains (visual chip handles mud)
    SortableItem(
      id: 'dirty_tshirt',
      name: 'T-Shirt',
      emoji: '👕',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty T-Shirt',
      accentColor: 0xFF90CAF9,
    ),
    SortableItem(
      id: 'dirty_shirt',
      name: 'Shirt',
      emoji: '👔',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Shirt',
      accentColor: 0xFFF48FB1,
    ),
    SortableItem(
      id: 'dirty_polo',
      name: 'Polo Shirt',
      emoji: '👕',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Polo',
      accentColor: 0xFFA5D6A7,
    ),
    SortableItem(
      id: 'dirty_skirt',
      name: 'Skirt',
      emoji: '👗',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Skirt',
      accentColor: 0xFFCE93D8,
    ),
    SortableItem(
      id: 'dirty_shorts',
      name: 'Shorts',
      emoji: '🩳',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Shorts',
      accentColor: 0xFFFFCC80,
    ),
    SortableItem(
      id: 'dirty_trousers',
      name: 'Trousers',
      emoji: '👖',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Trousers',
      accentColor: 0xFF9FA8DA,
    ),
    SortableItem(
      id: 'dirty_jeans',
      name: 'Jeans',
      emoji: '👖',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Jeans',
      accentColor: 0xFF7986CB,
    ),
    SortableItem(
      id: 'dirty_socks',
      name: 'Socks',
      emoji: '🧦',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Socks',
      accentColor: 0xFFEF9A9A,
    ),
    SortableItem(
      id: 'dirty_hanky',
      name: 'Handkerchief',
      emoji: '🧻',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Handkerchief',
      accentColor: 0xFFFFF59D,
    ),
    SortableItem(
      id: 'dirty_dress',
      name: 'Dress',
      emoji: '👗',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Dress',
      accentColor: 0xFFF8BBD0,
    ),
    SortableItem(
      id: 'dirty_jacket',
      name: 'Jacket',
      emoji: '🧥',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Jacket',
      accentColor: 0xFF80CBC4,
    ),
    SortableItem(
      id: 'dirty_sweater',
      name: 'Sweater',
      emoji: '🧶',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Sweater',
      accentColor: 0xFFBCAAA4,
    ),
    SortableItem(
      id: 'dirty_hoodie',
      name: 'Hoodie',
      emoji: '🧥',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Hoodie',
      accentColor: 0xFFB39DDB,
    ),
    SortableItem(
      id: 'dirty_pajamas',
      name: 'Pajamas',
      emoji: '🛌',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Pajamas',
      accentColor: 0xFF81D4FA,
    ),
    SortableItem(
      id: 'dirty_baby',
      name: 'Baby Clothes',
      emoji: '👶',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Baby Clothes',
      accentColor: 0xFFFFE0B2,
    ),
    SortableItem(
      id: 'dirty_towel',
      name: 'Towel',
      emoji: '🛁',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Towel',
      accentColor: 0xFFB2DFDB,
    ),
    SortableItem(
      id: 'dirty_cap',
      name: 'Cap',
      emoji: '🧢',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Cap',
      accentColor: 0xFFFFB74D,
    ),
    SortableItem(
      id: 'dirty_mittens',
      name: 'Mittens',
      emoji: '🧤',
      categoryId: dirtyCategoryId,
      voiceName: 'Dirty Mittens',
      accentColor: 0xFFEF9A9A,
    ),
  ];

  static bool isDirty(SortableItem item) => item.categoryId == dirtyCategoryId;

  static List<SortableItem> itemsForMode(CleanDirtyMode mode) {
    return switch (mode) {
      CleanDirtyMode.mixed => items,
      CleanDirtyMode.cleanOnly =>
        items.where((i) => i.categoryId == cleanCategoryId).toList(),
      CleanDirtyMode.dirtyOnly =>
        items.where((i) => i.categoryId == dirtyCategoryId).toList(),
    };
  }

  static List<SortCategory> categoriesForMode(CleanDirtyMode mode) {
    return switch (mode) {
      CleanDirtyMode.mixed => categories,
      CleanDirtyMode.cleanOnly => [clean],
      CleanDirtyMode.dirtyOnly => [dirty],
    };
  }
}
