import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/game_catalog.dart';
import '../models/game_duration.dart';
import '../models/game_settings/game_settings.dart';
import '../presentation/providers/game_library.dart';

/// Persists per-game parent controls under `{game_id}_settings`.
///
/// Uses ChangeNotifier + [patch] (Provider stack; TinyThink uses Riverpod
/// StateNotifier with the same persistence shape).
class GameSettingsStore extends ChangeNotifier {
  FruitVegSettings fruitVeg = const FruitVegSettings();
  IndoorOutdoorSettings indoorOutdoor = const IndoorOutdoorSettings();
  ColorSortSettings colorSort = const ColorSortSettings();
  BigSmallSettings bigSmall = const BigSmallSettings();
  ColorSchoolBagsSettings colorSchoolBags = const ColorSchoolBagsSettings();
  SortSocksSettings sortSocks = const SortSocksSettings();
  FlowerGardenSettings flowerGarden = const FlowerGardenSettings();
  HealthyFoodSettings healthyFood = const HealthyFoodSettings();
  CleanDirtySettings cleanDirty = const CleanDirtySettings();
  PetWildSettings petWild = const PetWildSettings();

  bool ready = false;

  static String prefsKey(String gameId) => '${gameId}_settings';

  Future<void> load({
    Map<String, dynamic>? legacySettings,
    GameLibrary? library,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    fruitVeg = _loadOrMigrate(
      prefs,
      GameCatalog.fruitVegId,
      FruitVegSettings.fromJson,
      () => _migrateFruitVeg(legacySettings),
    );
    indoorOutdoor = _loadOrMigrate(
      prefs,
      GameCatalog.indoorOutdoorId,
      IndoorOutdoorSettings.fromJson,
      () => _migrateIndoorOutdoor(legacySettings),
    );
    colorSort = _loadOrMigrate(
      prefs,
      GameCatalog.colorSortId,
      ColorSortSettings.fromJson,
      () => _migrateColorSort(legacySettings),
    );
    bigSmall = _loadOrMigrate(
      prefs,
      GameCatalog.bigSmallId,
      BigSmallSettings.fromJson,
      () => _migrateBigSmall(legacySettings),
    );
    final bagDefaults = _defaultIds(library, GameCatalog.colorSchoolBagsId);
    colorSchoolBags = _loadOrMigrate(
      prefs,
      GameCatalog.colorSchoolBagsId,
      (json) => ColorSchoolBagsSettings.fromJson(
        json,
        defaultColors: bagDefaults,
      ),
      () => _migrateColorSchoolBags(legacySettings, bagDefaults),
    );
    final sockDefaults = _defaultIds(library, GameCatalog.sortSocksId);
    sortSocks = _loadOrMigrate(
      prefs,
      GameCatalog.sortSocksId,
      (json) =>
          SortSocksSettings.fromJson(json, defaultColors: sockDefaults),
      () => _migrateSortSocks(legacySettings, sockDefaults),
    );
    final flowerDefaults = _defaultIds(library, GameCatalog.flowerGardenId);
    flowerGarden = _loadOrMigrate(
      prefs,
      GameCatalog.flowerGardenId,
      (json) => FlowerGardenSettings.fromJson(
        json,
        defaultColors: flowerDefaults,
      ),
      () => _migrateFlowerGarden(legacySettings, flowerDefaults),
    );
    final healthyDefaults = _healthyDefaults(library);
    healthyFood = _loadOrMigrate(
      prefs,
      GameCatalog.healthyFoodId,
      (json) => HealthyFoodSettings.fromJson(
        json,
        defaultHealthyIds: healthyDefaults.$1,
        defaultJunkIds: healthyDefaults.$2,
      ),
      () => _migrateHealthyFood(
        legacySettings,
        healthyDefaults.$1,
        healthyDefaults.$2,
      ),
    );
    cleanDirty = _loadOrMigrate(
      prefs,
      GameCatalog.cleanDirtyId,
      CleanDirtySettings.fromJson,
      () => const CleanDirtySettings(),
    );
    petWild = _loadOrMigrate(
      prefs,
      GameCatalog.animalSortId,
      PetWildSettings.fromJson,
      () => const PetWildSettings(),
    );

    ready = true;
    notifyListeners();
  }

  T _loadOrMigrate<T>(
    SharedPreferences prefs,
    String gameId,
    T Function(Map<String, dynamic>) fromJson,
    T Function() migrate,
  ) {
    final raw = prefs.getString(prefsKey(gameId));
    if (raw != null) {
      try {
        return fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        // fall through to migrate / defaults
      }
    }
    final migrated = migrate();
    // Fire-and-forget persist of migrated defaults
    _saveJson(gameId, (migrated as dynamic).toJson() as Map<String, dynamic>);
    return migrated;
  }

  Future<void> _saveJson(String gameId, Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey(gameId), jsonEncode(json));
  }

  // ── Patch helpers (update state + save immediately) ──────────────────────

  Future<void> patchFruitVeg(FruitVegSettings Function(FruitVegSettings) fn) async {
    fruitVeg = fn(fruitVeg);
    await _saveJson(GameCatalog.fruitVegId, fruitVeg.toJson());
    notifyListeners();
  }

  Future<void> patchIndoorOutdoor(
    IndoorOutdoorSettings Function(IndoorOutdoorSettings) fn,
  ) async {
    indoorOutdoor = fn(indoorOutdoor);
    await _saveJson(GameCatalog.indoorOutdoorId, indoorOutdoor.toJson());
    notifyListeners();
  }

  Future<void> patchColorSort(ColorSortSettings Function(ColorSortSettings) fn) async {
    colorSort = fn(colorSort);
    await _saveJson(GameCatalog.colorSortId, colorSort.toJson());
    notifyListeners();
  }

  Future<void> patchBigSmall(BigSmallSettings Function(BigSmallSettings) fn) async {
    bigSmall = fn(bigSmall);
    await _saveJson(GameCatalog.bigSmallId, bigSmall.toJson());
    notifyListeners();
  }

  Future<void> patchColorSchoolBags(
    ColorSchoolBagsSettings Function(ColorSchoolBagsSettings) fn,
  ) async {
    colorSchoolBags = fn(colorSchoolBags);
    await _saveJson(GameCatalog.colorSchoolBagsId, colorSchoolBags.toJson());
    notifyListeners();
  }

  Future<void> patchSortSocks(SortSocksSettings Function(SortSocksSettings) fn) async {
    sortSocks = fn(sortSocks);
    await _saveJson(GameCatalog.sortSocksId, sortSocks.toJson());
    notifyListeners();
  }

  Future<void> patchFlowerGarden(
    FlowerGardenSettings Function(FlowerGardenSettings) fn,
  ) async {
    flowerGarden = fn(flowerGarden);
    await _saveJson(GameCatalog.flowerGardenId, flowerGarden.toJson());
    notifyListeners();
  }

  Future<void> patchHealthyFood(
    HealthyFoodSettings Function(HealthyFoodSettings) fn,
  ) async {
    healthyFood = fn(healthyFood);
    await _saveJson(GameCatalog.healthyFoodId, healthyFood.toJson());
    notifyListeners();
  }

  Future<void> patchCleanDirty(
    CleanDirtySettings Function(CleanDirtySettings) fn,
  ) async {
    cleanDirty = fn(cleanDirty);
    await _saveJson(GameCatalog.cleanDirtyId, cleanDirty.toJson());
    notifyListeners();
  }

  Future<void> patchPetWild(PetWildSettings Function(PetWildSettings) fn) async {
    petWild = fn(petWild);
    await _saveJson(GameCatalog.animalSortId, petWild.toJson());
    notifyListeners();
  }

  List<String> _defaultIds(GameLibrary? library, String gameId) {
    if (library == null || !library.repository.hasContent(gameId)) {
      return const [];
    }
    return library.content(gameId).pools.defaultEnabledIds;
  }

  (List<String>, List<String>) _healthyDefaults(GameLibrary? library) {
    if (library == null ||
        !library.repository.hasContent(GameCatalog.healthyFoodId)) {
      return (const [], const []);
    }
    final pools = library.content(GameCatalog.healthyFoodId).pools;
    return (pools.defaultEnabledHealthyIds, pools.defaultEnabledJunkIds);
  }

  /// Central read for session duration by game id.
  int sessionSecondsFor(String gameId) {
    return commonFor(gameId).sessionSeconds;
  }

  Future<void> setSessionSeconds(String gameId, int seconds) async {
    final snapped = GameDuration.snap(seconds);
    await patchCommon(gameId, (c) => c.copyWith(sessionSeconds: snapped));
  }

  CommonGameControls commonFor(String gameId) {
    return switch (gameId) {
      GameCatalog.fruitVegId => fruitVeg.common,
      GameCatalog.indoorOutdoorId => indoorOutdoor.common,
      GameCatalog.colorSortId => colorSort.common,
      GameCatalog.bigSmallId => bigSmall.common,
      GameCatalog.colorSchoolBagsId => colorSchoolBags.common,
      GameCatalog.sortSocksId => sortSocks.common,
      GameCatalog.flowerGardenId => flowerGarden.common,
      GameCatalog.healthyFoodId => healthyFood.common,
      GameCatalog.cleanDirtyId => cleanDirty.common,
      GameCatalog.animalSortId => petWild.common,
      _ => const CommonGameControls(),
    };
  }

  Future<void> patchCommon(
    String gameId,
    CommonGameControls Function(CommonGameControls) fn,
  ) async {
    switch (gameId) {
      case GameCatalog.fruitVegId:
        await patchFruitVeg((s) => s.patchCommon(fn));
      case GameCatalog.indoorOutdoorId:
        await patchIndoorOutdoor((s) => s.patchCommon(fn));
      case GameCatalog.colorSortId:
        await patchColorSort((s) => s.patchCommon(fn));
      case GameCatalog.bigSmallId:
        await patchBigSmall((s) => s.patchCommon(fn));
      case GameCatalog.colorSchoolBagsId:
        await patchColorSchoolBags((s) => s.patchCommon(fn));
      case GameCatalog.sortSocksId:
        await patchSortSocks((s) => s.patchCommon(fn));
      case GameCatalog.flowerGardenId:
        await patchFlowerGarden((s) => s.patchCommon(fn));
      case GameCatalog.healthyFoodId:
        await patchHealthyFood((s) => s.patchCommon(fn));
      case GameCatalog.cleanDirtyId:
        await patchCleanDirty((s) => s.patchCommon(fn));
      case GameCatalog.animalSortId:
        await patchPetWild((s) => s.patchCommon(fn));
    }
  }

  bool includeInLearningPath(String gameId) =>
      commonFor(gameId).includeInLearningPath;

  // ── Legacy migration from monolithic ParentSettings JSON ─────────────────

  FruitVegSettings _migrateFruitVeg(Map<String, dynamic>? j) {
    if (j == null) return const FruitVegSettings();
    return FruitVegSettings.fromJson({
      ...j,
      'mode': j['fruitVegMode'],
      'narrationEnabled': j['voiceEnabled'],
    });
  }

  IndoorOutdoorSettings _migrateIndoorOutdoor(Map<String, dynamic>? j) {
    if (j == null) return const IndoorOutdoorSettings();
    return IndoorOutdoorSettings.fromJson({
      ...j,
      'mode': j['indoorOutdoorMode'],
      'narrationEnabled': j['voiceEnabled'],
    });
  }

  ColorSortSettings _migrateColorSort(Map<String, dynamic>? j) {
    if (j == null) return const ColorSortSettings();
    return ColorSortSettings.fromJson({
      ...j,
      'mode': j['colorSortMode'],
      'narrationEnabled': j['voiceEnabled'],
    });
  }

  BigSmallSettings _migrateBigSmall(Map<String, dynamic>? j) {
    if (j == null) return const BigSmallSettings();
    return BigSmallSettings.fromJson({
      ...j,
      'mode': j['bigSmallMode'],
      'narrationEnabled': j['voiceEnabled'],
    });
  }

  ColorSchoolBagsSettings _migrateColorSchoolBags(
    Map<String, dynamic>? j,
    List<String> defaultColors,
  ) {
    if (j == null) {
      return ColorSchoolBagsSettings(enabledColors: defaultColors);
    }
    return ColorSchoolBagsSettings.fromJson({
      ...j,
      'narrationEnabled': j['voiceEnabled'],
    }, defaultColors: defaultColors);
  }

  SortSocksSettings _migrateSortSocks(
    Map<String, dynamic>? j,
    List<String> defaultColors,
  ) {
    if (j == null) return SortSocksSettings(enabledColors: defaultColors);
    return SortSocksSettings.fromJson({
      ...j,
      'narrationEnabled': j['voiceEnabled'],
    }, defaultColors: defaultColors);
  }

  FlowerGardenSettings _migrateFlowerGarden(
    Map<String, dynamic>? j,
    List<String> defaultColors,
  ) {
    if (j == null) {
      return FlowerGardenSettings(enabledColors: defaultColors);
    }
    return FlowerGardenSettings.fromJson({
      ...j,
      'narrationEnabled': j['voiceEnabled'],
    }, defaultColors: defaultColors);
  }

  HealthyFoodSettings _migrateHealthyFood(
    Map<String, dynamic>? j,
    List<String> defaultHealthyIds,
    List<String> defaultJunkIds,
  ) {
    if (j == null) {
      return HealthyFoodSettings(
        enabledHealthyIds: defaultHealthyIds,
        enabledJunkIds: defaultJunkIds,
      );
    }
    return HealthyFoodSettings.fromJson(
      {...j, 'narrationEnabled': j['voiceEnabled']},
      defaultHealthyIds: defaultHealthyIds,
      defaultJunkIds: defaultJunkIds,
    );
  }
}
