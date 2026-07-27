import 'package:flutter/material.dart';

import '../../../models/game_modes.dart';
import '../../../models/game_settings/common_game_controls.dart';
import '../common_controls_section.dart';

/// Shared controls for fruit/veg, indoor/outdoor, color sort, big/small.
class FloatingSortControls extends StatelessWidget {
  const FloatingSortControls({
    super.key,
    required this.common,
    required this.floatingItemCount,
    required this.speed,
    required this.floatingAnimation,
    required this.modeLabel,
    required this.modeOptions,
    required this.selectedModeIndex,
    required this.onCommonChanged,
    required this.onFloatingCountChanged,
    required this.onSpeedChanged,
    required this.onFloatingAnimationChanged,
    required this.onModeIndexChanged,
    this.minFloating = 2,
    this.maxFloating = 8,
    this.extraControls,
  });

  final CommonGameControls common;
  final int floatingItemCount;
  final MovementSpeed speed;
  final bool floatingAnimation;
  final String modeLabel;
  final List<String> modeOptions;
  final int selectedModeIndex;
  final ValueChanged<CommonGameControls> onCommonChanged;
  final ValueChanged<int> onFloatingCountChanged;
  final ValueChanged<MovementSpeed> onSpeedChanged;
  final ValueChanged<bool> onFloatingAnimationChanged;
  final ValueChanged<int> onModeIndexChanged;
  final int minFloating;
  final int maxFloating;
  final Widget? extraControls;

  @override
  Widget build(BuildContext context) {
    final min = minFloating.toDouble();
    final max = maxFloating.toDouble();
    final divisions = (maxFloating - minFloating).clamp(1, 20);
    final value = floatingItemCount.clamp(minFloating, maxFloating).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(modeLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < modeOptions.length; i++)
              ChoiceChip(
                label: Text(modeOptions[i]),
                selected: selectedModeIndex == i,
                onSelected: (_) => onModeIndexChanged(i),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'On-screen items: ${value.round()}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Slider(
          min: min,
          max: max,
          divisions: divisions,
          value: value,
          onChanged: (v) => onFloatingCountChanged(v.round()),
        ),
        const Text('Fall / move speed', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        SegmentedButton<MovementSpeed>(
          segments: const [
            ButtonSegment(value: MovementSpeed.slow, label: Text('Slow')),
            ButtonSegment(value: MovementSpeed.normal, label: Text('Normal')),
            ButtonSegment(value: MovementSpeed.fast, label: Text('Fast')),
          ],
          selected: {speed},
          onSelectionChanged: (s) => onSpeedChanged(s.first),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Floating animation'),
          value: floatingAnimation,
          onChanged: onFloatingAnimationChanged,
        ),
        ?extraControls,
        CommonControlsSection(controls: common, onChanged: onCommonChanged),
      ],
    );
  }
}
