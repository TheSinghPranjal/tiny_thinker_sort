import 'package:flutter/material.dart';

import '../../models/game_duration.dart';
import '../../theme/sortjoy_theme.dart';
import 'game_duration_slider.dart';
import 'premium_upsell_card.dart';

/// Collapsible Parent Zone card for one game’s controls.
class ParentGameSettingsCard extends StatelessWidget {
  const ParentGameSettingsCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.sessionSeconds,
    required this.includeInLearningPath,
    required this.playsTodayLabel,
    required this.isPremium,
    required this.expanded,
    required this.onExpansionChanged,
    required this.onSessionSecondsChanged,
    required this.onLearningPathChanged,
    required this.controlsChild,
    this.initiallyHighlight = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final int sessionSeconds;
  final bool includeInLearningPath;
  final String playsTodayLabel;
  final bool isPremium;
  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<int>? onSessionSecondsChanged;
  final ValueChanged<bool>? onLearningPathChanged;
  final Widget controlsChild;
  final bool initiallyHighlight;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: initiallyHighlight && expanded
              ? SortJoyColors.mint
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => onExpansionChanged(!expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: SortJoyColors.inkSoft,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _MiniChip(
                              label: GameDuration.label(sessionSeconds),
                              color: SortJoyColors.lavender,
                            ),
                            _MiniChip(
                              label: includeInLearningPath
                                  ? 'In Learning Path'
                                  : 'Not in path',
                              color: includeInLearningPath
                                  ? SortJoyColors.mint
                                  : SortJoyColors.inkSoft,
                            ),
                            _MiniChip(
                              label: playsTodayLabel,
                              color: SortJoyColors.peach,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: SortJoyColors.inkSoft,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameDurationSlider(
                    sessionSeconds: sessionSeconds,
                    enabled: isPremium,
                    onChanged: isPremium ? onSessionSecondsChanged : null,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Include in Learning Path',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text(
                      'Allow this game in automatic Learning Path sessions',
                    ),
                    value: includeInLearningPath,
                    onChanged: isPremium ? onLearningPathChanged : null,
                  ),
                  if (!isPremium) const PremiumControlsHint(),
                  const SizedBox(height: 8),
                  const Text(
                    'Game options',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  controlsChild,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color.withValues(alpha: 0.95),
        ),
      ),
    );
  }
}
