import 'package:equatable/equatable.dart';

import '../../data/healthy_food_data.dart';
import 'common_game_controls.dart';

class HealthyFoodSettings extends Equatable {
  const HealthyFoodSettings({
    this.common = const CommonGameControls(practiceMode: true),
    this.difficulty = HealthyFoodDifficulty.beginner,
    this.enabledHealthyIds = HealthyFoodDefaults.enabledHealthy,
    this.enabledJunkIds = HealthyFoodDefaults.enabledJunk,
  });

  final CommonGameControls common;
  final HealthyFoodDifficulty difficulty;
  final List<String> enabledHealthyIds;
  final List<String> enabledJunkIds;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  HealthyFoodSettings copyWith({
    CommonGameControls? common,
    HealthyFoodDifficulty? difficulty,
    List<String>? enabledHealthyIds,
    List<String>? enabledJunkIds,
  }) {
    return HealthyFoodSettings(
      common: common ?? this.common,
      difficulty: difficulty ?? this.difficulty,
      enabledHealthyIds: enabledHealthyIds ?? this.enabledHealthyIds,
      enabledJunkIds: enabledJunkIds ?? this.enabledJunkIds,
    );
  }

  HealthyFoodSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'difficulty': difficulty.name,
        'enabledHealthyIds': enabledHealthyIds,
        'enabledJunkIds': enabledJunkIds,
      };

  factory HealthyFoodSettings.fromJson(Map<String, dynamic> json) {
    final practice = (json['practiceMode'] as bool?) ??
        (json['healthyFoodUnlimitedTime'] as bool?) ??
        true;
    final session = (json['sessionSeconds'] as num?)?.toInt() ??
        (json['healthyFoodSessionSeconds'] as num?)?.toInt() ??
        60;
    return HealthyFoodSettings(
      common: CommonGameControls.fromJson({
        ...json,
        'practiceMode': practice,
        'sessionSeconds': session > 0 ? session : 60,
      }),
      difficulty: HealthyFoodDifficulty.values.firstWhere(
        (e) =>
            e.name == (json['difficulty'] ?? json['healthyFoodDifficulty']),
        orElse: () => HealthyFoodDifficulty.beginner,
      ),
      enabledHealthyIds: _parseList(
        json['enabledHealthyIds'] ?? json['healthyFoodEnabledHealthyIds'],
        HealthyFoodDefaults.enabledHealthy,
        minCount: 4,
      ),
      enabledJunkIds: _parseList(
        json['enabledJunkIds'] ?? json['healthyFoodEnabledJunkIds'],
        HealthyFoodDefaults.enabledJunk,
        minCount: 4,
      ),
    );
  }

  static List<String> _parseList(
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

  @override
  List<Object?> get props =>
      [common, difficulty, enabledHealthyIds, enabledJunkIds];
}
