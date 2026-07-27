import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class ColorSchoolBagsSettings extends Equatable {
  const ColorSchoolBagsSettings({
    this.common = const CommonGameControls(practiceMode: true),
    this.difficulty = ColorSchoolBagsDifficulty.level2,
    this.enabledColors = ColorSchoolBagsDefaults.enabled,
  });

  final CommonGameControls common;
  final ColorSchoolBagsDifficulty difficulty;
  final List<String> enabledColors;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;
  int get backpackCount => difficulty.backpackCount;

  ColorSchoolBagsSettings copyWith({
    CommonGameControls? common,
    ColorSchoolBagsDifficulty? difficulty,
    List<String>? enabledColors,
  }) {
    return ColorSchoolBagsSettings(
      common: common ?? this.common,
      difficulty: difficulty ?? this.difficulty,
      enabledColors: enabledColors ?? this.enabledColors,
    );
  }

  ColorSchoolBagsSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'difficulty': difficulty.name,
        'enabledColors': enabledColors,
      };

  factory ColorSchoolBagsSettings.fromJson(Map<String, dynamic> json) {
    final colors = _parseColors(json['enabledColors'] ?? json['colorSchoolBagsEnabledColors']);
    final practice = (json['practiceMode'] as bool?) ??
        (json['colorSchoolBagsUnlimitedTime'] as bool?) ??
        true;
    final session = (json['sessionSeconds'] as num?)?.toInt() ??
        (json['colorSchoolBagsSessionSeconds'] as num?)?.toInt() ??
        60;
    return ColorSchoolBagsSettings(
      common: CommonGameControls.fromJson({
        ...json,
        'practiceMode': practice,
        'sessionSeconds': session > 0 ? session : 60,
      }),
      difficulty: ColorSchoolBagsDifficulty.values.firstWhere(
        (e) =>
            e.name ==
            (json['difficulty'] ?? json['colorSchoolBagsDifficulty']),
        orElse: () => ColorSchoolBagsDifficulty.level2,
      ),
      enabledColors: colors,
    );
  }

  static List<String> _parseColors(Object? raw) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= 2) return ids;
    }
    return ColorSchoolBagsDefaults.enabled;
  }

  @override
  List<Object?> get props => [common, difficulty, enabledColors];
}
