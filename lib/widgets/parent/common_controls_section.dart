import 'package:flutter/material.dart';

import '../../models/game_settings/common_game_controls.dart';

/// Shared switches / sliders for common parental knobs.
class CommonControlsSection extends StatelessWidget {
  const CommonControlsSection({
    super.key,
    required this.controls,
    required this.onChanged,
  });

  final CommonGameControls controls;
  final ValueChanged<CommonGameControls> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Practice mode'),
          subtitle: const Text('Unlimited play · no timer'),
          value: controls.practiceMode,
          onChanged: (v) => onChanged(controls.copyWith(practiceMode: v)),
        ),
        Text(
          'Reward multiplier · ${controls.rewardMultiplier.toStringAsFixed(1)}×',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Slider(
          min: 0.5,
          max: 2.0,
          divisions: 6,
          value: controls.rewardMultiplier,
          label: '${controls.rewardMultiplier.toStringAsFixed(1)}×',
          onChanged: (v) =>
              onChanged(controls.copyWith(rewardMultiplier: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sound effects'),
          value: controls.soundEnabled,
          onChanged: (v) => onChanged(controls.copyWith(soundEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Music'),
          value: controls.musicEnabled,
          onChanged: (v) => onChanged(controls.copyWith(musicEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Voice encouragement'),
          value: controls.narrationEnabled,
          onChanged: (v) => onChanged(controls.copyWith(narrationEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Celebrations'),
          value: controls.celebrationsEnabled,
          onChanged: (v) =>
              onChanged(controls.copyWith(celebrationsEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Coin rewards'),
          value: controls.coinRewardsEnabled,
          onChanged: (v) =>
              onChanged(controls.copyWith(coinRewardsEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Haptics'),
          value: controls.hapticsEnabled,
          onChanged: (v) => onChanged(controls.copyWith(hapticsEnabled: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Left-handed layout'),
          value: controls.leftHandedLayout,
          onChanged: (v) =>
              onChanged(controls.copyWith(leftHandedLayout: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Larger touch targets'),
          value: controls.largerTouchTargets,
          onChanged: (v) =>
              onChanged(controls.copyWith(largerTouchTargets: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Reduced motion'),
          subtitle: const Text('Gentler animations for sensitive kids'),
          value: controls.reducedMotion,
          onChanged: (v) => onChanged(controls.copyWith(reducedMotion: v)),
        ),
      ],
    );
  }
}
