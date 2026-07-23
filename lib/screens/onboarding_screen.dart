import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/age_world.dart';
import '../state/app_state.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/sortjoy_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AgeWorld? _selected;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const SortJoyLogo(
                height: 88,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Learn by sorting — with sparkles, smiles, and zero scolding.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: SortJoyColors.inkSoft,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Who’s playing today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    for (final world in AgeWorld.values) ...[
                      _AgeCard(
                        world: world,
                        selected: _selected == world,
                        onTap: () => setState(() => _selected = world),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () => context.read<AppState>().completeOnboarding(_selected!),
                child: const Text('Let’s Sort!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeCard extends StatelessWidget {
  const _AgeCard({
    required this.world,
    required this.selected,
    required this.onTap,
  });

  final AgeWorld world;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = switch (world) {
      AgeWorld.littleExplorers => [SortJoyColors.berry, SortJoyColors.peach],
      AgeWorld.tinyLearners => [SortJoyColors.mint, SortJoyColors.lemon],
      AgeWorld.smartSorters => [SortJoyColors.lavender, SortJoyColors.skyTop],
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected ? Colors.white : Colors.transparent,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(world.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      world.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      world.ageLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    Text(
                      world.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
