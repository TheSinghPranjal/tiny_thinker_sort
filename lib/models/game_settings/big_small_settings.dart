import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class BigSmallSettings extends Equatable {
  const BigSmallSettings({
    this.common = const CommonGameControls(),
    this.mode = BigSmallMode.mixed,
    this.floatingItemCount = 4,
    this.speed = MovementSpeed.normal,
    this.floatingAnimation = true,
  });

  final CommonGameControls common;
  final BigSmallMode mode;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  BigSmallSettings copyWith({
    CommonGameControls? common,
    BigSmallMode? mode,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? floatingAnimation,
  }) {
    return BigSmallSettings(
      common: common ?? this.common,
      mode: mode ?? this.mode,
      floatingItemCount: (floatingItemCount ?? this.floatingItemCount).clamp(2, 8),
      speed: speed ?? this.speed,
      floatingAnimation: floatingAnimation ?? this.floatingAnimation,
    );
  }

  BigSmallSettings patchCommon(
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

  factory BigSmallSettings.fromJson(Map<String, dynamic> json) {
    return BigSmallSettings(
      common: CommonGameControls.fromJson(json),
      mode: BigSmallMode.values.firstWhere(
        (e) => e.name == (json['mode'] ?? json['bigSmallMode']),
        orElse: () => BigSmallMode.mixed,
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
