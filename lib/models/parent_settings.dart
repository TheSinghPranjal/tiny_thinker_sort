import 'package:equatable/equatable.dart';

export 'game_modes.dart';

/// Global parent / account flags (per-game knobs live in [GameSettingsStore]).
class ParentSettings extends Equatable {
  const ParentSettings({
    this.isPremium = false,
  });

  final bool isPremium;

  ParentSettings copyWith({bool? isPremium}) {
    return ParentSettings(isPremium: isPremium ?? this.isPremium);
  }

  Map<String, dynamic> toJson() => {'isPremium': isPremium};

  factory ParentSettings.fromJson(Map<String, dynamic> json) {
    return ParentSettings(
      isPremium: (json['isPremium'] as bool?) ?? false,
    );
  }

  @override
  List<Object?> get props => [isPremium];
}
