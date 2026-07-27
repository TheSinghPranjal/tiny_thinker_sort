import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class FruitVegSettings extends Equatable {
  const FruitVegSettings({
    this.common = const CommonGameControls(),
    this.mode = FruitVegMode.mixed,
    this.floatingItemCount = 4,
    this.speed = MovementSpeed.normal,
    this.floatingAnimation = true,
  });

  final CommonGameControls common;
  final FruitVegMode mode;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  FruitVegSettings copyWith({
    CommonGameControls? common,
    FruitVegMode? mode,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? floatingAnimation,
  }) {
    return FruitVegSettings(
      common: common ?? this.common,
      mode: mode ?? this.mode,
      floatingItemCount: (floatingItemCount ?? this.floatingItemCount).clamp(2, 8),
      speed: speed ?? this.speed,
      floatingAnimation: floatingAnimation ?? this.floatingAnimation,
    );
  }

  FruitVegSettings patchCommon(
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

  factory FruitVegSettings.fromJson(Map<String, dynamic> json) {
    return FruitVegSettings(
      common: CommonGameControls.fromJson(json),
      mode: FruitVegMode.values.firstWhere(
        (e) => e.name == (json['mode'] ?? json['fruitVegMode']),
        orElse: () => FruitVegMode.mixed,
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
