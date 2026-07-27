// Shared mode / difficulty enums used by parent controls and game data.

enum MovementSpeed { slow, normal, fast }

extension MovementSpeedX on MovementSpeed {
  double get multiplier => switch (this) {
        MovementSpeed.slow => 0.55,
        MovementSpeed.normal => 1.0,
        MovementSpeed.fast => 1.55,
      };
}

enum FruitVegMode { mixed, fruitsOnly, vegetablesOnly }

enum IndoorOutdoorMode { mixed, indoorOnly, outdoorOnly }

enum ColorSortMode { mixed, redOnly, blueOnly, greenOnly }

enum BigSmallMode { mixed, bigOnly, smallOnly }

enum CleanDirtyMode { mixed, cleanOnly, dirtyOnly }

/// Backpack count per session for Color School Bags (Level 1 = 2, etc.).
enum ColorSchoolBagsDifficulty { level2, level3, level4, level5, level6 }

abstract final class ColorSchoolBagsDefaults {
  static const enabled = ['red', 'blue', 'green', 'yellow'];
}

extension ColorSchoolBagsDifficultyX on ColorSchoolBagsDifficulty {
  int get backpackCount => switch (this) {
        ColorSchoolBagsDifficulty.level2 => 2,
        ColorSchoolBagsDifficulty.level3 => 3,
        ColorSchoolBagsDifficulty.level4 => 4,
        ColorSchoolBagsDifficulty.level5 => 5,
        ColorSchoolBagsDifficulty.level6 => 6,
      };
}

/// Laundry bag count per session for Sort Socks (Level 1 = 2, etc.).
enum SortSocksDifficulty { level2, level3, level4, level5, level6 }

abstract final class SortSocksDefaults {
  static const enabled = ['red', 'blue', 'green', 'yellow'];
}

extension SortSocksDifficultyX on SortSocksDifficulty {
  int get laundryBagCount => switch (this) {
        SortSocksDifficulty.level2 => 2,
        SortSocksDifficulty.level3 => 3,
        SortSocksDifficulty.level4 => 4,
        SortSocksDifficulty.level5 => 5,
        SortSocksDifficulty.level6 => 6,
      };
}

/// Flower pot count per session for Flower Garden (Level 1 = 2, etc.).
enum FlowerGardenDifficulty { level2, level3, level4, level5 }

abstract final class FlowerGardenDefaults {
  static const enabled = ['pink', 'yellow', 'red'];
}

extension FlowerGardenDifficultyX on FlowerGardenDifficulty {
  int get potCount => switch (this) {
        FlowerGardenDifficulty.level2 => 2,
        FlowerGardenDifficulty.level3 => 3,
        FlowerGardenDifficulty.level4 => 4,
        FlowerGardenDifficulty.level5 => 5,
      };
}
