import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

class PremiumUpsellCard extends StatelessWidget {
  const PremiumUpsellCard({
    super.key,
    required this.isPremium,
    this.onTogglePremium,
  });

  final bool isPremium;
  final ValueChanged<bool>? onTogglePremium;

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [SortJoyColors.mint, SortJoyColors.lavender],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium active',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Unlimited play · full parent controls · Learning Path',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (onTogglePremium != null)
              Switch(
                value: true,
                onChanged: onTogglePremium,
                activeThumbColor: Colors.white,
              ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: SortJoyColors.lavender.withValues(alpha: 0.45),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: SortJoyColors.lavender.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌟', style: TextStyle(fontSize: 28)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Unlock SortJoy Premium',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Premium unlocks unlimited play, full parent controls, and Learning Path sessions.',
            style: TextStyle(
              color: SortJoyColors.inkSoft,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          if (onTogglePremium != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Premium (dev toggle)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Turn on to try premium controls'),
              value: false,
              onChanged: onTogglePremium,
            ),
        ],
      ),
    );
  }
}

/// Inline CTA shown inside game settings when duration / Learning Path are locked.
class PremiumControlsHint extends StatelessWidget {
  const PremiumControlsHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SortJoyColors.lavender.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Premium unlocks unlimited play, parent controls, and Learning Path sessions.',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: SortJoyColors.inkSoft,
          fontSize: 13,
        ),
      ),
    );
  }
}
