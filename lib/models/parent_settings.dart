import '../data/healthy_food_data.dart';

enum MovementSpeed { slow, normal, fast }

enum FruitVegMode { mixed, fruitsOnly, vegetablesOnly }

enum IndoorOutdoorMode { mixed, indoorOnly, outdoorOnly }

enum ColorSortMode { mixed, redOnly, blueOnly, greenOnly }

enum BigSmallMode { mixed, bigOnly, smallOnly }

/// Backpack count per session for Color School Bags (Level 1 = 2, etc.).
enum ColorSchoolBagsDifficulty { level2, level3, level4, level5, level6 }

/// Default enabled colors for Color School Bags parent controls.
abstract final class ColorSchoolBagsDefaults {
  static const enabled = ['red', 'blue', 'green', 'yellow'];
}

/// Flower pot count per session for Flower Garden (Level 1 = 2, etc.).
enum FlowerGardenDifficulty { level2, level3, level4, level5 }

/// Default enabled colors for Flower Garden parent controls.
abstract final class FlowerGardenDefaults {
  static const enabled = ['pink', 'yellow', 'red'];
}

class ParentSettings {
  const ParentSettings({
    this.sessionSeconds = 60,
    this.floatingItemCount = 4,
    this.speed = MovementSpeed.normal,
    this.voiceEnabled = true,
    this.celebrationsEnabled = true,
    this.fruitVegMode = FruitVegMode.mixed,
    this.indoorOutdoorMode = IndoorOutdoorMode.mixed,
    this.colorSortMode = ColorSortMode.mixed,
    this.bigSmallMode = BigSmallMode.mixed,
    this.colorSchoolBagsUnlimitedTime = true,
    this.colorSchoolBagsSessionSeconds = 0,
    this.colorSchoolBagsDifficulty = ColorSchoolBagsDifficulty.level2,
    this.colorSchoolBagsEnabledColors = ColorSchoolBagsDefaults.enabled,
    this.flowerGardenUnlimitedTime = true,
    this.flowerGardenSessionSeconds = 0,
    this.flowerGardenDifficulty = FlowerGardenDifficulty.level3,
    this.flowerGardenEnabledColors = FlowerGardenDefaults.enabled,
    this.healthyFoodUnlimitedTime = true,
    this.healthyFoodSessionSeconds = 0,
    this.healthyFoodDifficulty = HealthyFoodDifficulty.beginner,
    this.healthyFoodEnabledHealthyIds = HealthyFoodDefaults.enabledHealthy,
    this.healthyFoodEnabledJunkIds = HealthyFoodDefaults.enabledJunk,
    this.isPremium = false,
  });

  static const colorSchoolBagsSessionPresets = [0, 30, 60, 90, 120, 300, 600, 1800];
  static const flowerGardenSessionPresets = [0, 30, 60, 90, 120, 300, 600, 1800];
  static const healthyFoodSessionPresets = [0, 30, 60, 90, 120, 300, 600, 1800];

  final int sessionSeconds;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool voiceEnabled;
  final bool celebrationsEnabled;
  final FruitVegMode fruitVegMode;
  final IndoorOutdoorMode indoorOutdoorMode;
  final ColorSortMode colorSortMode;
  final BigSmallMode bigSmallMode;
  final bool colorSchoolBagsUnlimitedTime;
  final int colorSchoolBagsSessionSeconds;
  final ColorSchoolBagsDifficulty colorSchoolBagsDifficulty;
  final List<String> colorSchoolBagsEnabledColors;
  final bool flowerGardenUnlimitedTime;
  final int flowerGardenSessionSeconds;
  final FlowerGardenDifficulty flowerGardenDifficulty;
  final List<String> flowerGardenEnabledColors;
  final bool healthyFoodUnlimitedTime;
  final int healthyFoodSessionSeconds;
  final HealthyFoodDifficulty healthyFoodDifficulty;
  final List<String> healthyFoodEnabledHealthyIds;
  final List<String> healthyFoodEnabledJunkIds;
  final bool isPremium;

  int get colorSchoolBagsBackpackCount => switch (colorSchoolBagsDifficulty) {
    ColorSchoolBagsDifficulty.level2 => 2,
    ColorSchoolBagsDifficulty.level3 => 3,
    ColorSchoolBagsDifficulty.level4 => 4,
    ColorSchoolBagsDifficulty.level5 => 5,
    ColorSchoolBagsDifficulty.level6 => 6,
  };

  int get flowerGardenPotCount => switch (flowerGardenDifficulty) {
    FlowerGardenDifficulty.level2 => 2,
    FlowerGardenDifficulty.level3 => 3,
    FlowerGardenDifficulty.level4 => 4,
    FlowerGardenDifficulty.level5 => 5,
  };

  /// Parental Controls allow 1–30 minutes (default 60 seconds).
  int get sessionMinutes => (sessionSeconds / 60).round().clamp(1, 30);

  /// Slider uses seconds; minimum is 60 (1 minute), max 1800 (30 minutes).
  static const minSessionSeconds = 60;
  static const maxSessionSeconds = 30 * 60;

  double get speedMultiplier => switch (speed) {
    MovementSpeed.slow => 0.55,
    MovementSpeed.normal => 1.0,
    MovementSpeed.fast => 1.55,
  };

  ParentSettings copyWith({
    int? sessionSeconds,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? voiceEnabled,
    bool? celebrationsEnabled,
    FruitVegMode? fruitVegMode,
    IndoorOutdoorMode? indoorOutdoorMode,
    ColorSortMode? colorSortMode,
    BigSmallMode? bigSmallMode,
    bool? colorSchoolBagsUnlimitedTime,
    int? colorSchoolBagsSessionSeconds,
    ColorSchoolBagsDifficulty? colorSchoolBagsDifficulty,
    List<String>? colorSchoolBagsEnabledColors,
    bool? flowerGardenUnlimitedTime,
    int? flowerGardenSessionSeconds,
    FlowerGardenDifficulty? flowerGardenDifficulty,
    List<String>? flowerGardenEnabledColors,
    bool? healthyFoodUnlimitedTime,
    int? healthyFoodSessionSeconds,
    HealthyFoodDifficulty? healthyFoodDifficulty,
    List<String>? healthyFoodEnabledHealthyIds,
    List<String>? healthyFoodEnabledJunkIds,
    bool? isPremium,
  }) {
    return ParentSettings(
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
      floatingItemCount: floatingItemCount ?? this.floatingItemCount,
      speed: speed ?? this.speed,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      celebrationsEnabled: celebrationsEnabled ?? this.celebrationsEnabled,
      fruitVegMode: fruitVegMode ?? this.fruitVegMode,
      indoorOutdoorMode: indoorOutdoorMode ?? this.indoorOutdoorMode,
      colorSortMode: colorSortMode ?? this.colorSortMode,
      bigSmallMode: bigSmallMode ?? this.bigSmallMode,
      colorSchoolBagsUnlimitedTime:
          colorSchoolBagsUnlimitedTime ?? this.colorSchoolBagsUnlimitedTime,
      colorSchoolBagsSessionSeconds:
          colorSchoolBagsSessionSeconds ?? this.colorSchoolBagsSessionSeconds,
      colorSchoolBagsDifficulty:
          colorSchoolBagsDifficulty ?? this.colorSchoolBagsDifficulty,
      colorSchoolBagsEnabledColors:
          colorSchoolBagsEnabledColors ?? this.colorSchoolBagsEnabledColors,
      flowerGardenUnlimitedTime:
          flowerGardenUnlimitedTime ?? this.flowerGardenUnlimitedTime,
      flowerGardenSessionSeconds:
          flowerGardenSessionSeconds ?? this.flowerGardenSessionSeconds,
      flowerGardenDifficulty:
          flowerGardenDifficulty ?? this.flowerGardenDifficulty,
      flowerGardenEnabledColors:
          flowerGardenEnabledColors ?? this.flowerGardenEnabledColors,
      healthyFoodUnlimitedTime:
          healthyFoodUnlimitedTime ?? this.healthyFoodUnlimitedTime,
      healthyFoodSessionSeconds:
          healthyFoodSessionSeconds ?? this.healthyFoodSessionSeconds,
      healthyFoodDifficulty:
          healthyFoodDifficulty ?? this.healthyFoodDifficulty,
      healthyFoodEnabledHealthyIds:
          healthyFoodEnabledHealthyIds ?? this.healthyFoodEnabledHealthyIds,
      healthyFoodEnabledJunkIds:
          healthyFoodEnabledJunkIds ?? this.healthyFoodEnabledJunkIds,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() => {
    'sessionSeconds': sessionSeconds,
    'floatingItemCount': floatingItemCount,
    'speed': speed.name,
    'voiceEnabled': voiceEnabled,
    'celebrationsEnabled': celebrationsEnabled,
    'fruitVegMode': fruitVegMode.name,
    'indoorOutdoorMode': indoorOutdoorMode.name,
    'colorSortMode': colorSortMode.name,
    'bigSmallMode': bigSmallMode.name,
    'colorSchoolBagsUnlimitedTime': colorSchoolBagsUnlimitedTime,
    'colorSchoolBagsSessionSeconds': colorSchoolBagsSessionSeconds,
    'colorSchoolBagsDifficulty': colorSchoolBagsDifficulty.name,
    'colorSchoolBagsEnabledColors': colorSchoolBagsEnabledColors,
    'flowerGardenUnlimitedTime': flowerGardenUnlimitedTime,
    'flowerGardenSessionSeconds': flowerGardenSessionSeconds,
    'flowerGardenDifficulty': flowerGardenDifficulty.name,
    'flowerGardenEnabledColors': flowerGardenEnabledColors,
    'healthyFoodUnlimitedTime': healthyFoodUnlimitedTime,
    'healthyFoodSessionSeconds': healthyFoodSessionSeconds,
    'healthyFoodDifficulty': healthyFoodDifficulty.name,
    'healthyFoodEnabledHealthyIds': healthyFoodEnabledHealthyIds,
    'healthyFoodEnabledJunkIds': healthyFoodEnabledJunkIds,
    'isPremium': isPremium,
  };

  factory ParentSettings.fromJson(Map<String, dynamic> json) {
    return ParentSettings(
      sessionSeconds: (json['sessionSeconds'] as int?) ?? 60,
      floatingItemCount: (json['floatingItemCount'] as int?) ?? 4,
      speed: MovementSpeed.values.firstWhere(
        (e) => e.name == json['speed'],
        orElse: () => MovementSpeed.normal,
      ),
      voiceEnabled: (json['voiceEnabled'] as bool?) ?? true,
      celebrationsEnabled: (json['celebrationsEnabled'] as bool?) ?? true,
      fruitVegMode: FruitVegMode.values.firstWhere(
        (e) => e.name == json['fruitVegMode'],
        orElse: () => FruitVegMode.mixed,
      ),
      indoorOutdoorMode: IndoorOutdoorMode.values.firstWhere(
        (e) => e.name == json['indoorOutdoorMode'],
        orElse: () => IndoorOutdoorMode.mixed,
      ),
      colorSortMode: ColorSortMode.values.firstWhere(
        (e) => e.name == json['colorSortMode'],
        orElse: () => ColorSortMode.mixed,
      ),
      bigSmallMode: BigSmallMode.values.firstWhere(
        (e) => e.name == json['bigSmallMode'],
        orElse: () => BigSmallMode.mixed,
      ),
      colorSchoolBagsUnlimitedTime:
          (json['colorSchoolBagsUnlimitedTime'] as bool?) ?? true,
      colorSchoolBagsSessionSeconds:
          (json['colorSchoolBagsSessionSeconds'] as int?) ?? 0,
      colorSchoolBagsDifficulty: ColorSchoolBagsDifficulty.values.firstWhere(
        (e) => e.name == json['colorSchoolBagsDifficulty'],
        orElse: () => ColorSchoolBagsDifficulty.level2,
      ),
      colorSchoolBagsEnabledColors: _parseColorList(
        json['colorSchoolBagsEnabledColors'],
      ),
      flowerGardenUnlimitedTime:
          (json['flowerGardenUnlimitedTime'] as bool?) ?? true,
      flowerGardenSessionSeconds:
          (json['flowerGardenSessionSeconds'] as int?) ?? 0,
      flowerGardenDifficulty: FlowerGardenDifficulty.values.firstWhere(
        (e) => e.name == json['flowerGardenDifficulty'],
        orElse: () => FlowerGardenDifficulty.level3,
      ),
      flowerGardenEnabledColors: _parseFlowerGardenColorList(
        json['flowerGardenEnabledColors'],
      ),
      healthyFoodUnlimitedTime:
          (json['healthyFoodUnlimitedTime'] as bool?) ?? true,
      healthyFoodSessionSeconds:
          (json['healthyFoodSessionSeconds'] as int?) ?? 0,
      healthyFoodDifficulty: HealthyFoodDifficulty.values.firstWhere(
        (e) => e.name == json['healthyFoodDifficulty'],
        orElse: () => HealthyFoodDifficulty.beginner,
      ),
      healthyFoodEnabledHealthyIds: _parseHealthyFoodList(
        json['healthyFoodEnabledHealthyIds'],
        HealthyFoodDefaults.enabledHealthy,
        minCount: 4,
      ),
      healthyFoodEnabledJunkIds: _parseHealthyFoodList(
        json['healthyFoodEnabledJunkIds'],
        HealthyFoodDefaults.enabledJunk,
        minCount: 4,
      ),
      isPremium: (json['isPremium'] as bool?) ?? false,
    );
  }

  static List<String> _parseColorList(Object? raw) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= 2) return ids;
    }
    return ColorSchoolBagsDefaults.enabled;
  }

  static List<String> _parseFlowerGardenColorList(Object? raw) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= 2) return ids;
    }
    return FlowerGardenDefaults.enabled;
  }

  static List<String> _parseHealthyFoodList(
    Object? raw,
    List<String> defaults, {
    required int minCount,
  }) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= minCount) return ids;
    }
    return defaults;
  }
}
