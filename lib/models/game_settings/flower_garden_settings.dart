import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class FlowerGardenSettings extends Equatable {
  const FlowerGardenSettings({
    this.common = const CommonGameControls(practiceMode: true),
    this.difficulty = FlowerGardenDifficulty.level3,
    this.enabledColors = FlowerGardenDefaults.enabled,
  });

  final CommonGameControls common;
  final FlowerGardenDifficulty difficulty;
  final List<String> enabledColors;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;
  int get potCount => difficulty.potCount;

  FlowerGardenSettings copyWith({
    CommonGameControls? common,
    FlowerGardenDifficulty? difficulty,
    List<String>? enabledColors,
  }) {
    return FlowerGardenSettings(
      common: common ?? this.common,
      difficulty: difficulty ?? this.difficulty,
      enabledColors: enabledColors ?? this.enabledColors,
    );
  }

  FlowerGardenSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'difficulty': difficulty.name,
        'enabledColors': enabledColors,
      };

  factory FlowerGardenSettings.fromJson(Map<String, dynamic> json) {
    final colors = _parseColors(
      json['enabledColors'] ?? json['flowerGardenEnabledColors'],
    );
    final practice = (json['practiceMode'] as bool?) ??
        (json['flowerGardenUnlimitedTime'] as bool?) ??
        true;
    final session = (json['sessionSeconds'] as num?)?.toInt() ??
        (json['flowerGardenSessionSeconds'] as num?)?.toInt() ??
        60;
    return FlowerGardenSettings(
      common: CommonGameControls.fromJson({
        ...json,
        'practiceMode': practice,
        'sessionSeconds': session > 0 ? session : 60,
      }),
      difficulty: FlowerGardenDifficulty.values.firstWhere(
        (e) =>
            e.name == (json['difficulty'] ?? json['flowerGardenDifficulty']),
        orElse: () => FlowerGardenDifficulty.level3,
      ),
      enabledColors: colors,
    );
  }

  static List<String> _parseColors(Object? raw) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= 2) return ids;
    }
    return FlowerGardenDefaults.enabled;
  }

  @override
  List<Object?> get props => [common, difficulty, enabledColors];
}
