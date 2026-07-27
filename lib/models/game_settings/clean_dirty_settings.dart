import 'package:equatable/equatable.dart';

import '../game_modes.dart';
import 'common_game_controls.dart';

class CleanDirtySettings extends Equatable {
  const CleanDirtySettings({
    this.common = const CommonGameControls(),
    this.mode = CleanDirtyMode.mixed,
    this.floatingItemCount = 5,
    this.speed = MovementSpeed.normal,
    this.floatingAnimation = true,
    this.bubbleEffects = true,
  });

  final CommonGameControls common;
  final CleanDirtyMode mode;

  /// Visible clothing items on screen (3–8, default 5).
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;
  final bool bubbleEffects;

  int get sessionSeconds => common.sessionSeconds;
  bool get practiceMode => common.practiceMode;

  CleanDirtySettings copyWith({
    CommonGameControls? common,
    CleanDirtyMode? mode,
    int? floatingItemCount,
    MovementSpeed? speed,
    bool? floatingAnimation,
    bool? bubbleEffects,
  }) {
    return CleanDirtySettings(
      common: common ?? this.common,
      mode: mode ?? this.mode,
      floatingItemCount:
          (floatingItemCount ?? this.floatingItemCount).clamp(3, 8),
      speed: speed ?? this.speed,
      floatingAnimation: floatingAnimation ?? this.floatingAnimation,
      bubbleEffects: bubbleEffects ?? this.bubbleEffects,
    );
  }

  CleanDirtySettings patchCommon(
    CommonGameControls Function(CommonGameControls) fn,
  ) =>
      copyWith(common: fn(common));

  Map<String, dynamic> toJson() => {
        ...common.toJson(),
        'mode': mode.name,
        'floatingItemCount': floatingItemCount,
        'speed': speed.name,
        'floatingAnimation': floatingAnimation,
        'bubbleEffects': bubbleEffects,
      };

  factory CleanDirtySettings.fromJson(Map<String, dynamic> json) {
    return CleanDirtySettings(
      common: CommonGameControls.fromJson(json),
      mode: CleanDirtyMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => CleanDirtyMode.mixed,
      ),
      floatingItemCount: (json['floatingItemCount'] as num?)?.toInt() ?? 5,
      speed: MovementSpeed.values.firstWhere(
        (e) => e.name == json['speed'],
        orElse: () => MovementSpeed.normal,
      ),
      floatingAnimation: (json['floatingAnimation'] as bool?) ?? true,
      bubbleEffects: (json['bubbleEffects'] as bool?) ?? true,
    );
  }

  @override
  List<Object?> get props => [
        common,
        mode,
        floatingItemCount,
        speed,
        floatingAnimation,
        bubbleEffects,
      ];
}
