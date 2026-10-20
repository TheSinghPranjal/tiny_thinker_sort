import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/game_catalog.dart';
import '../../../models/game_modes.dart';
import '../../../models/game_settings/healthy_food_settings.dart';
import '../../../presentation/providers/game_library.dart';
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
    final content = context.read<GameLibrary>().content(
      GameCatalog.healthyFoodId,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        for (final level in content.difficulties)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(level.label),
            trailing: Icon(
              settings.difficulty.name == level.id
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
            ),
            onTap: () => onChanged(
              settings.copyWith(
                difficulty: HealthyFoodDifficulty.values.byName(level.id),
              ),
            ),
          ),
        const Text(
          'Healthy foods (at least 4)',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Wrap(
          spacing: 4,
          children: [
            for (final foodId in content.pools.allHealthyIds)
              FilterChip(
                label: Text(content.displayName(foodId)),
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
          'Treats (at least 4)',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        Wrap(
          spacing: 4,
          children: [
            for (final foodId in content.pools.allJunkIds)
              FilterChip(
                label: Text(content.displayName(foodId)),
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
