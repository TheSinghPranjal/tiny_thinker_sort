import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class SortSocksSettings extends Equatable {
  const SortSocksSettings({
    this.common = const CommonGameControls(practiceMode: true),
    this.difficulty = SortSocksDifficulty.level2,
    this.enabledColors = SortSocksDefaults.enabled,
  });

  final CommonGameControls common;
  final SortSocksDifficulty difficulty;
  final List<String> enabledColors;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;
  int get laundryBagCount => difficulty.laundryBagCount;

  SortSocksSettings copyWith({
    CommonGameControls? common,
    SortSocksDifficulty? difficulty,
    List<String>? enabledColors,
  }) {
    return SortSocksSettings(
      common: common ?? this.common,
      difficulty: difficulty ?? this.difficulty,
      enabledColors: enabledColors ?? this.enabledColors,
    );
  }

  SortSocksSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'difficulty': difficulty.name,
        'enabledColors': enabledColors,
      };

  factory SortSocksSettings.fromJson(Map<String, dynamic> json) {
    final colors =
        _parseColors(json['enabledColors'] ?? json['sortSocksEnabledColors']);
    final practice = (json['practiceMode'] as bool?) ??
        (json['sortSocksUnlimitedTime'] as bool?) ??
        true;
    final session = (json['sessionSeconds'] as num?)?.toInt() ??
        (json['sortSocksSessionSeconds'] as num?)?.toInt() ??
        60;
    return SortSocksSettings(
      common: CommonGameControls.fromJson({
        ...json,
        'practiceMode': practice,
        'sessionSeconds': session > 0 ? session : 60,
      }),
      difficulty: SortSocksDifficulty.values.firstWhere(
        (e) => e.name == (json['difficulty'] ?? json['sortSocksDifficulty']),
        orElse: () => SortSocksDifficulty.level2,
      ),
      enabledColors: colors,
    );
  }

  static List<String> _parseColors(Object? raw) {
    if (raw is List) {
      final ids = raw.whereType<String>().toList();
      if (ids.length >= 2) return ids;
    }
    return SortSocksDefaults.enabled;
  }

  @override
  List<Object?> get props => [common, difficulty, enabledColors];
}
