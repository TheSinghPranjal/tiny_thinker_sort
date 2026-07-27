import 'package:flutter/material.dart';

import '../../models/game_duration.dart';
import '../../theme/sortjoy_theme.dart';

/// Shared duration slider bound to snapped presets (1–30 minutes).
class GameDurationSlider extends StatelessWidget {
  const GameDurationSlider({
    super.key,
    required this.sessionSeconds,
    required this.enabled,
    this.onChanged,
  });

  final int sessionSeconds;
  final bool enabled;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final index = GameDuration.indexOf(sessionSeconds).toDouble();
    final maxIndex = (GameDuration.presetsSeconds.length - 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Session duration',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const Spacer(),
            Text(
              GameDuration.label(sessionSeconds),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: enabled ? SortJoyColors.mint : SortJoyColors.inkSoft,
              ),
            ),
          ],
        ),
        Slider(
          min: 0,
          max: maxIndex,
          divisions: GameDuration.presetsSeconds.length - 1,
          value: index,
          label: GameDuration.label(sessionSeconds),
          onChanged: enabled && onChanged != null
              ? (v) => onChanged!(GameDuration.fromIndex(v.round()))
              : null,
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final secs in GameDuration.presetsSeconds)
              ChoiceChip(
                label: Text(GameDuration.shortLabel(secs)),
                selected: GameDuration.snap(sessionSeconds) == secs,
                onSelected: enabled && onChanged != null
                    ? (_) => onChanged!(secs)
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}
