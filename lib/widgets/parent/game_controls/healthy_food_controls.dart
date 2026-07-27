import 'package:flutter/material.dart';

import '../../../data/healthy_food_data.dart';
import '../../../models/game_settings/healthy_food_settings.dart';
import '../common_controls_section.dart';

class HealthyFoodControls extends StatelessWidget {
  const HealthyFoodControls({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final HealthyFoodSettings settings;
  final ValueChanged<HealthyFoodSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        for (final level in HealthyFoodDifficulty.values)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(switch (level) {
              HealthyFoodDifficulty.beginner =>
                'Beginner · Apple, Banana, Burger, Pizza',
              HealthyFoodDifficulty.easy => 'Easy · 6 foods',
              HealthyFoodDifficulty.medium => 'Medium · 10 foods',
              HealthyFoodDifficulty.advanced =>
                'Advanced · all enabled foods',
            }),
            trailing: Icon(
              settings.difficulty == level
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
            ),
            onTap: () => onChanged(settings.copyWith(difficulty: level)),
          ),
        const Text(
          'Healthy foods (at least 4)',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Wrap(
          spacing: 4,
          children: [
            for (final foodId in HealthyFoodData.allHealthyIds)
              FilterChip(
                label: Text(HealthyFoodData.displayName(foodId)),
                selected: settings.enabledHealthyIds.contains(foodId),
                onSelected: (selected) {
                  final next = List<String>.from(settings.enabledHealthyIds);
                  if (selected) {
                    if (!next.contains(foodId)) next.add(foodId);
                  } else if (next.length > 4) {
                    next.remove(foodId);
                  }
                  onChanged(settings.copyWith(enabledHealthyIds: next));
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Junk foods (at least 4)',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Wrap(
          spacing: 4,
          children: [
            for (final foodId in HealthyFoodData.allJunkIds)
              FilterChip(
                label: Text(HealthyFoodData.displayName(foodId)),
                selected: settings.enabledJunkIds.contains(foodId),
                onSelected: (selected) {
                  final next = List<String>.from(settings.enabledJunkIds);
                  if (selected) {
                    if (!next.contains(foodId)) next.add(foodId);
                  } else if (next.length > 4) {
                    next.remove(foodId);
                  }
                  onChanged(settings.copyWith(enabledJunkIds: next));
                },
              ),
          ],
        ),
        CommonControlsSection(
          controls: settings.common,
          onChanged: (c) => onChanged(settings.copyWith(common: c)),
        ),
      ],
    );
  }
}
