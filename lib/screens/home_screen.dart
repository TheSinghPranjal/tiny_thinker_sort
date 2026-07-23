import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/game_catalog.dart';
import '../models/age_world.dart';
import '../models/game_definition.dart';
import '../state/app_state.dart';
import '../theme/sortjoy_theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/sortjoy_logo.dart';
import 'game_setup_screen.dart';
import 'parent_zone_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final world = app.ageWorld ?? AgeWorld.tinyLearners;
    final games = GameCatalog.forWorld(world);

    return GradientScaffold(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SortJoyLogo(height: 40),
                        SizedBox(height: 4),
                        Text(
                          'Sparkles, smiles, zero scolding',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: SortJoyColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RewardPill(
                    emoji: '🪙',
                    value: '${app.rewards.coins}',
                  ),
                  const SizedBox(width: 8),
                  _RewardPill(
                    emoji: '⭐',
                    value: '${app.rewards.stars}',
                  ),
                  IconButton(
                    tooltip: 'Parent Zone',
                    onPressed: () => _openParentGate(context),
                    icon: const Icon(Icons.family_restroom_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(world.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            world.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${world.ageLabel} · streak ${app.rewards.dailyStreak}🔥',
                            style: const TextStyle(
                              color: SortJoyColors.inkSoft,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openParentGate(context),
                      child: const Text('Switch'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _LearningPathCard(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Games',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  return _GameCard(game: games[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openParentGate(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => const _ParentGateDialog(),
    );
    if (ok == true && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ParentZoneScreen()),
      );
    }
  }
}

class _LearningPathCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [SortJoyColors.lavender, SortJoyColors.berry],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text('🗺', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Guided path through your age world',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Premium\ncoming soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final GameDefinition game;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final remaining = app.remainingPlays(game.id);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => GameSetupScreen(game: game)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(game.emoji, style: const TextStyle(fontSize: 36)),
                  const Spacer(),
                  if (!game.implemented)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: SortJoyColors.lemon.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Soon',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  else if (!app.settings.isPremium)
                    Text(
                      '$remaining left',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: SortJoyColors.inkSoft,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                game.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                game.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: SortJoyColors.inkSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  const _RewardPill({required this.emoji, required this.value});

  final String emoji;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ParentGateDialog extends StatefulWidget {
  const _ParentGateDialog();

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  late final int _a;
  late final int _b;
  final _controller = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().millisecond;
    _a = 3 + (now % 6);
    _b = 2 + ((now ~/ 7) % 5);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Parent Zone'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('What is $_a + $_b?'),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Answer',
              errorText: _error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Enter'),
        ),
      ],
    );
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == _a + _b) {
      Navigator.pop(context, true);
    } else {
      setState(() => _error = 'Try again');
    }
  }
}
