import 'package:equatable/equatable.dart';

import '../game_duration.dart';

/// Shared parental-control knobs present on every game settings object.
class CommonGameControls extends Equatable {
  const CommonGameControls({
    this.sessionSeconds = 60,
    this.practiceMode = false,
    this.rewardMultiplier = 1.0,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.narrationEnabled = true,
    this.celebrationsEnabled = true,
    this.coinRewardsEnabled = true,
    this.hapticsEnabled = true,
    this.leftHandedLayout = false,
    this.largerTouchTargets = false,
    this.reducedMotion = false,
    this.includeInLearningPath = true,
  });

  /// Timed session length in seconds (snapped to [GameDuration] presets).
  final int sessionSeconds;

  /// Unlimited play — ignore the session timer.
  final bool practiceMode;

  /// Scales coin/star rewards (~0.5–2.0).
  final double rewardMultiplier;

  final bool soundEnabled;
  final bool musicEnabled;
  final bool narrationEnabled;
  final bool celebrationsEnabled;
  final bool coinRewardsEnabled;
  final bool hapticsEnabled;
  final bool leftHandedLayout;
  final bool largerTouchTargets;
  final bool reducedMotion;
  final bool includeInLearningPath;

  CommonGameControls copyWith({
    int? sessionSeconds,
    bool? practiceMode,
    double? rewardMultiplier,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? narrationEnabled,
    bool? celebrationsEnabled,
    bool? coinRewardsEnabled,
    bool? hapticsEnabled,
    bool? leftHandedLayout,
    bool? largerTouchTargets,
    bool? reducedMotion,
    bool? includeInLearningPath,
  }) {
    return CommonGameControls(
      sessionSeconds: sessionSeconds != null
          ? GameDuration.snap(sessionSeconds)
          : this.sessionSeconds,
      practiceMode: practiceMode ?? this.practiceMode,
      rewardMultiplier:
          (rewardMultiplier ?? this.rewardMultiplier).clamp(0.5, 2.0),
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      narrationEnabled: narrationEnabled ?? this.narrationEnabled,
      celebrationsEnabled: celebrationsEnabled ?? this.celebrationsEnabled,
      coinRewardsEnabled: coinRewardsEnabled ?? this.coinRewardsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      leftHandedLayout: leftHandedLayout ?? this.leftHandedLayout,
      largerTouchTargets: largerTouchTargets ?? this.largerTouchTargets,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      includeInLearningPath:
          includeInLearningPath ?? this.includeInLearningPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionSeconds': GameDuration.snap(sessionSeconds),
        'practiceMode': practiceMode,
        'rewardMultiplier': rewardMultiplier,
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'narrationEnabled': narrationEnabled,
        'celebrationsEnabled': celebrationsEnabled,
        'coinRewardsEnabled': coinRewardsEnabled,
        'hapticsEnabled': hapticsEnabled,
        'leftHandedLayout': leftHandedLayout,
        'largerTouchTargets': largerTouchTargets,
        'reducedMotion': reducedMotion,
        'includeInLearningPath': includeInLearningPath,
      };

  factory CommonGameControls.fromJson(Map<String, dynamic> json) {
    return CommonGameControls(
      sessionSeconds: GameDuration.snap(
        (json['sessionSeconds'] as num?)?.toInt() ?? 60,
      ),
      practiceMode: (json['practiceMode'] as bool?) ?? false,
      rewardMultiplier:
          ((json['rewardMultiplier'] as num?)?.toDouble() ?? 1.0).clamp(0.5, 2.0),
      soundEnabled: (json['soundEnabled'] as bool?) ?? true,
      musicEnabled: (json['musicEnabled'] as bool?) ?? true,
      narrationEnabled: (json['narrationEnabled'] as bool?) ??
          (json['voiceEnabled'] as bool?) ??
          true,
      celebrationsEnabled: (json['celebrationsEnabled'] as bool?) ?? true,
      coinRewardsEnabled: (json['coinRewardsEnabled'] as bool?) ?? true,
      hapticsEnabled: (json['hapticsEnabled'] as bool?) ?? true,
      leftHandedLayout: (json['leftHandedLayout'] as bool?) ?? false,
      largerTouchTargets: (json['largerTouchTargets'] as bool?) ?? false,
      reducedMotion: (json['reducedMotion'] as bool?) ?? false,
      includeInLearningPath: (json['includeInLearningPath'] as bool?) ?? true,
    );
  }

  @override
  List<Object?> get props => [
        sessionSeconds,
        practiceMode,
        rewardMultiplier,
        soundEnabled,
        musicEnabled,
        narrationEnabled,
        celebrationsEnabled,
        coinRewardsEnabled,
        hapticsEnabled,
        leftHandedLayout,
        largerTouchTargets,
        reducedMotion,
        includeInLearningPath,
      ];
}
