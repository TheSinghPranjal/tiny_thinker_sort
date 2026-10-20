import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class PetWildSettings extends Equatable {
  const PetWildSettings({
    this.common = const CommonGameControls(),
    this.mode = PetWildMode.mixed,
    this.floatingItemCount = 4,
    this.speed = MovementSpeed.normal,
    this.floatingAnimation = true,
  });

  final CommonGameControls common;
  final PetWildMode mode;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  PetWildSettings copyWith({
    CommonGameControls? common,
    PetWildMode? mode,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? floatingAnimation,
  }) {
    return PetWildSettings(
      common: common ?? this.common,
      mode: mode ?? this.mode,
      floatingItemCount: (floatingItemCount ?? this.floatingItemCount).clamp(
        2,
        8,
      ),
      speed: speed ?? this.speed,
      floatingAnimation: floatingAnimation ?? this.floatingAnimation,
    );
  }

  PetWildSettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) => copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
    ...common.toJson(),
    'mode': mode.name,
    'floatingItemCount': floatingItemCount,
    'speed': speed.name,
    'floatingAnimation': floatingAnimation,
  };

  factory PetWildSettings.fromJson(Map<String, dynamic> json) {
    return PetWildSettings(
      common: CommonGameControls.fromJson(json),
      mode: PetWildMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => PetWildMode.mixed,
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
  List<Object?> get props => [
    common,
    mode,
    floatingItemCount,
    speed,
    floatingAnimation,
  ];
}
