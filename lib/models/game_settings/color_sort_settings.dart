import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class ColorSortSettings extends Equatable {
  const ColorSortSettings({
    this.common = const CommonGameControls(),
    this.mode = ColorSortMode.mixed,
    this.floatingItemCount = 4,
    this.speed = MovementSpeed.normal,
    this.floatingAnimation = true,
  });

  final CommonGameControls common;
  final ColorSortMode mode;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  ColorSortSettings copyWith({
    CommonGameControls? common,
    ColorSortMode? mode,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? floatingAnimation,
  }) {
    return ColorSortSettings(
      common: common ?? this.common,
      mode: mode ?? this.mode,
      floatingItemCount: (floatingItemCount ?? this.floatingItemCount).clamp(2, 8),
      speed: speed ?? this.speed,
      floatingAnimation: floatingAnimation ?? this.floatingAnimation,
    );
  }

  ColorSortSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'mode': mode.name,
        'floatingItemCount': floatingItemCount,
        'speed': speed.name,
        'floatingAnimation': floatingAnimation,
      };

  factory ColorSortSettings.fromJson(Map<String, dynamic> json) {
    return ColorSortSettings(
      common: CommonGameControls.fromJson(json),
      mode: ColorSortMode.values.firstWhere(
        (e) => e.name == (json['mode'] ?? json['colorSortMode']),
        orElse: () => ColorSortMode.mixed,
      ),
      floatingItemCount: (json['floatingItemCount'] as num?)?.toInt() ?? 4,
      speed: MovementSpeed.values.firstWhere(
        (e) => e.name == json['speed'],
        orElse: () => MovementSpeed.normal,
      ),
      floatingAnimation: (json['floatingAnimation'] as bool?) ?? true,
    );
  }

  @override
  List<Object?> get props =>
      [common, mode, floatingItemCount, speed, floatingAnimation];
}
