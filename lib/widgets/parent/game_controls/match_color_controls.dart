import 'package:flutter/material.dart';

import '../../../models/game_settings/common_game_controls.dart';
import '../common_controls_section.dart';

/// Difficulty + color chips for school bags / socks / flower garden.
class MatchColorControls extends StatelessWidget {
  const MatchColorControls({
    super.key,
    required this.common,
    required this.difficultyLabels,
    required this.selectedDifficultyIndex,
    required this.colorIds,
    required this.colorLabels,
    required this.enabledColors,
    required this.minColors,
    required this.onCommonChanged,
    required this.onDifficultyChanged,
    required this.onColorsChanged,
  });

  final CommonGameControls common;
  final List<String> difficultyLabels;
  final int selectedDifficultyIndex;
  final List<String> colorIds;
  final List<String> colorLabels;
  final List<String> enabledColors;
  final int minColors;
  final ValueChanged<CommonGameControls> onCommonChanged;
  final ValueChanged<int> onDifficultyChanged;
  final ValueChanged<List<String>> onColorsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        for (var i = 0; i < difficultyLabels.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(difficultyLabels[i]),
            trailing: Icon(
              selectedDifficultyIndex == i
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
            ),
            onTap: () => onDifficultyChanged(i),
          ),
        const SizedBox(height: 4),
        Text(
          'Available colors (at least $minColors)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          children: [
            for (var i = 0; i < colorIds.length; i++)
              FilterChip(
                label: Text(colorLabels[i]),
                selected: enabledColors.contains(colorIds[i]),
                onSelected: (selected) {
                  final next = List<String>.from(enabledColors);
                  final id = colorIds[i];
                  if (selected) {
                    if (!next.contains(id)) next.add(id);
                  } else if (next.length > minColors) {
                    next.remove(id);
                  }
                  onColorsChanged(next);
                },
              ),
          ],
        ),
        CommonControlsSection(controls: common, onChanged: onCommonChanged),
      ],
    );
  }
}
