import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/color_school_bags_data.dart';
import '../data/flower_garden_data.dart';
import '../data/healthy_food_data.dart';
import '../models/age_world.dart';
import '../models/parent_settings.dart';
import '../state/app_state.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';

class ParentZoneScreen extends StatelessWidget {
  const ParentZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final settings = app.settings;

    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Parent Zone',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Age world',
              child: Column(
                children: [
                  for (final world in AgeWorld.values)
                    ListTile(
                      leading: Text(world.emoji, style: const TextStyle(fontSize: 28)),
                      title: Text(world.title),
                      subtitle: Text(world.ageLabel),
                      trailing: Icon(
                        app.ageWorld == world
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.setAgeWorld(world),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Session',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration: ${(settings.sessionSeconds / 60).clamp(1, 30).toStringAsFixed(settings.sessionSeconds < 60 ? 1 : 0)} min '
                    '(${settings.sessionSeconds}s)',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    min: 60,
                    max: 30 * 60,
                    divisions: 29,
                    value: settings.sessionSeconds.clamp(60, 1800).toDouble(),
                    label: '${(settings.sessionSeconds / 60).round()} min',
                    onChanged: (v) {
                      // Allow 1–30 minutes; also keep a quick 60s default via snap near start
                      final seconds = v.round();
                      app.updateSettings(settings.copyWith(sessionSeconds: seconds));
                    },
                  ),
                  // Quick presets including default 60s
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final secs in [60, 120, 300, 600, 1800])
                        ChoiceChip(
                          label: Text(secs < 120 ? '${secs}s' : '${secs ~/ 60}m'),
                          selected: settings.sessionSeconds == secs,
                          onSelected: (_) => app.updateSettings(
                            settings.copyWith(sessionSeconds: secs),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'On-screen items: ${settings.floatingItemCount}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Slider(
                    min: 2,
                    max: 8,
                    divisions: 6,
                    value: settings.floatingItemCount.toDouble(),
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(floatingItemCount: v.round()),
                    ),
                  ),
                  const Text('Movement speed', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SegmentedButton<MovementSpeed>(
                    segments: const [
                      ButtonSegment(value: MovementSpeed.slow, label: Text('Slow')),
                      ButtonSegment(value: MovementSpeed.normal, label: Text('Normal')),
                      ButtonSegment(value: MovementSpeed.fast, label: Text('Fast')),
                    ],
                    selected: {settings.speed},
                    onSelectionChanged: (s) => app.updateSettings(
                      settings.copyWith(speed: s.first),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Feedback',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Voice pronunciation'),
                    value: settings.voiceEnabled,
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(voiceEnabled: v),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Reward celebrations'),
                    value: settings.celebrationsEnabled,
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(celebrationsEnabled: v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Fruit & Vegetable modes',
              child: Column(
                children: [
                  for (final mode in FruitVegMode.values)
                    ListTile(
                      title: Text(switch (mode) {
                        FruitVegMode.mixed => 'Mixed',
                        FruitVegMode.fruitsOnly => 'Fruits Only',
                        FruitVegMode.vegetablesOnly => 'Vegetables Only',
                      }),
                      trailing: Icon(
                        settings.fruitVegMode == mode
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(fruitVegMode: mode),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Indoor & Outdoor modes',
              child: Column(
                children: [
                  for (final mode in IndoorOutdoorMode.values)
                    ListTile(
                      title: Text(switch (mode) {
                        IndoorOutdoorMode.mixed => 'Mixed',
                        IndoorOutdoorMode.indoorOnly => 'Indoor Games Only',
                        IndoorOutdoorMode.outdoorOnly => 'Outdoor Games Only',
                      }),
                      trailing: Icon(
                        settings.indoorOutdoorMode == mode
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(indoorOutdoorMode: mode),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Color Sort modes',
              child: Column(
                children: [
                  for (final mode in ColorSortMode.values)
                    ListTile(
                      title: Text(switch (mode) {
                        ColorSortMode.mixed => 'Mixed Colors',
                        ColorSortMode.redOnly => 'Red Only',
                        ColorSortMode.blueOnly => 'Blue Only',
                        ColorSortMode.greenOnly => 'Green Only',
                      }),
                      trailing: Icon(
                        settings.colorSortMode == mode
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(colorSortMode: mode),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Big & Small modes',
              child: Column(
                children: [
                  for (final mode in BigSmallMode.values)
                    ListTile(
                      title: Text(switch (mode) {
                        BigSmallMode.mixed => 'Mixed Mode',
                        BigSmallMode.bigOnly => 'Big Objects Only',
                        BigSmallMode.smallOnly => 'Small Objects Only',
                      }),
                      trailing: Icon(
                        settings.bigSmallMode == mode
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(bigSmallMode: mode),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Color School Bags',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Unlimited play time'),
                    subtitle: const Text('Default for toddlers — no timer'),
                    value: settings.colorSchoolBagsUnlimitedTime,
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(colorSchoolBagsUnlimitedTime: v),
                    ),
                  ),
                  if (!settings.colorSchoolBagsUnlimitedTime) ...[
                    Text(
                      'Duration: ${_formatSchoolBagsDuration(settings.colorSchoolBagsSessionSeconds)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final secs in ParentSettings.colorSchoolBagsSessionPresets
                            .where((s) => s > 0))
                          ChoiceChip(
                            label: Text(_formatSchoolBagsDuration(secs)),
                            selected: settings.colorSchoolBagsSessionSeconds == secs,
                            onSelected: (_) => app.updateSettings(
                              settings.copyWith(colorSchoolBagsSessionSeconds: secs),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    'Difficulty (backpacks per round)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  for (final level in ColorSchoolBagsDifficulty.values)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(switch (level) {
                        ColorSchoolBagsDifficulty.level2 => 'Level 1 · 2 backpacks',
                        ColorSchoolBagsDifficulty.level3 => 'Level 2 · 3 backpacks',
                        ColorSchoolBagsDifficulty.level4 => 'Level 3 · 4 backpacks',
                        ColorSchoolBagsDifficulty.level5 => 'Advanced · 5 backpacks',
                        ColorSchoolBagsDifficulty.level6 => 'Advanced · 6 backpacks',
                      }),
                      trailing: Icon(
                        settings.colorSchoolBagsDifficulty == level
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(colorSchoolBagsDifficulty: level),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Available colors (at least 2)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: [
                      for (final colorId in ColorSchoolBagsData.allColorIds)
                        FilterChip(
                          label: Text(ColorSchoolBagsData.displayName(colorId)),
                          selected: settings.colorSchoolBagsEnabledColors.contains(colorId),
                          onSelected: (selected) {
                            final next = List<String>.from(
                              settings.colorSchoolBagsEnabledColors,
                            );
                            if (selected) {
                              if (!next.contains(colorId)) next.add(colorId);
                            } else if (next.length > 2) {
                              next.remove(colorId);
                            }
                            app.updateSettings(
                              settings.copyWith(colorSchoolBagsEnabledColors: next),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Flower Garden',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Unlimited play time'),
                    subtitle: const Text('Default for toddlers — no timer'),
                    value: settings.flowerGardenUnlimitedTime,
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(flowerGardenUnlimitedTime: v),
                    ),
                  ),
                  if (!settings.flowerGardenUnlimitedTime) ...[
                    Text(
                      'Duration: ${_formatSchoolBagsDuration(settings.flowerGardenSessionSeconds)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final secs in ParentSettings.flowerGardenSessionPresets
                            .where((s) => s > 0))
                          ChoiceChip(
                            label: Text(_formatSchoolBagsDuration(secs)),
                            selected: settings.flowerGardenSessionSeconds == secs,
                            onSelected: (_) => app.updateSettings(
                              settings.copyWith(flowerGardenSessionSeconds: secs),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    'Difficulty (flower pots)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  for (final level in FlowerGardenDifficulty.values)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(switch (level) {
                        FlowerGardenDifficulty.level2 => 'Level 1 · 2 colors',
                        FlowerGardenDifficulty.level3 => 'Level 2 · 3 colors',
                        FlowerGardenDifficulty.level4 => 'Level 3 · 4 colors',
                        FlowerGardenDifficulty.level5 => 'Level 4 · 5 colors',
                      }),
                      trailing: Icon(
                        settings.flowerGardenDifficulty == level
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(flowerGardenDifficulty: level),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Flower colors (at least 2)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: [
                      for (final colorId in FlowerGardenData.allColorIds)
                        FilterChip(
                          label: Text(FlowerGardenData.displayName(colorId)),
                          selected: settings.flowerGardenEnabledColors.contains(colorId),
                          onSelected: (selected) {
                            final next = List<String>.from(
                              settings.flowerGardenEnabledColors,
                            );
                            if (selected) {
                              if (!next.contains(colorId)) next.add(colorId);
                            } else if (next.length > 2) {
                              next.remove(colorId);
                            }
                            app.updateSettings(
                              settings.copyWith(flowerGardenEnabledColors: next),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Learn to Sort — Healthy Food',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Unlimited play time'),
                    subtitle: const Text('Default for toddlers — no timer'),
                    value: settings.healthyFoodUnlimitedTime,
                    onChanged: (v) => app.updateSettings(
                      settings.copyWith(healthyFoodUnlimitedTime: v),
                    ),
                  ),
                  if (!settings.healthyFoodUnlimitedTime) ...[
                    Text(
                      'Duration: ${_formatSchoolBagsDuration(settings.healthyFoodSessionSeconds)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final secs in ParentSettings.healthyFoodSessionPresets
                            .where((s) => s > 0))
                          ChoiceChip(
                            label: Text(_formatSchoolBagsDuration(secs)),
                            selected: settings.healthyFoodSessionSeconds == secs,
                            onSelected: (_) => app.updateSettings(
                              settings.copyWith(healthyFoodSessionSeconds: secs),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    'Difficulty',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
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
                        settings.healthyFoodDifficulty == level
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: SortJoyColors.mint,
                      ),
                      onTap: () => app.updateSettings(
                        settings.copyWith(healthyFoodDifficulty: level),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Healthy foods (at least 4)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: [
                      for (final foodId in HealthyFoodData.allHealthyIds)
                        FilterChip(
                          label: Text(HealthyFoodData.displayName(foodId)),
                          selected: settings.healthyFoodEnabledHealthyIds
                              .contains(foodId),
                          onSelected: (selected) {
                            final next = List<String>.from(
                              settings.healthyFoodEnabledHealthyIds,
                            );
                            if (selected) {
                              if (!next.contains(foodId)) next.add(foodId);
                            } else if (next.length > 4) {
                              next.remove(foodId);
                            }
                            app.updateSettings(
                              settings.copyWith(
                                healthyFoodEnabledHealthyIds: next,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Junk foods (at least 4)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 0,
                    children: [
                      for (final foodId in HealthyFoodData.allJunkIds)
                        FilterChip(
                          label: Text(HealthyFoodData.displayName(foodId)),
                          selected:
                              settings.healthyFoodEnabledJunkIds.contains(foodId),
                          onSelected: (selected) {
                            final next = List<String>.from(
                              settings.healthyFoodEnabledJunkIds,
                            );
                            if (selected) {
                              if (!next.contains(foodId)) next.add(foodId);
                            } else if (next.length > 4) {
                              next.remove(foodId);
                            }
                            app.updateSettings(
                              settings.copyWith(healthyFoodEnabledJunkIds: next),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Premium',
              child: SwitchListTile(
                title: const Text('Premium (dev toggle)'),
                subtitle: const Text('Unlimited plays · deeper controls'),
                value: settings.isPremium,
                onChanged: (v) => app.updateSettings(
                  settings.copyWith(isPremium: v),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Progress',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('XP ${app.rewards.xp} · Badges ${app.rewards.badges.length}'),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset progress?'),
                          content: const Text(
                            'This clears coins, stars, XP, streaks, badges, and daily plays.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) await app.resetProgress();
                    },
                    child: const Text('Reset progress'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatSchoolBagsDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  if (seconds % 60 == 0) return '${seconds ~/ 60} min';
  return '${seconds}s';
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
