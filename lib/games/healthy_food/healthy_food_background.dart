import 'package:flutter/material.dart';

/// Sunny meadow landscape for Learn to Sort — Healthy Food vs Junk Food.
class HealthyFoodBackground extends StatelessWidget {
  const HealthyFoodBackground({super.key});

  static const assetPath = 'assets/images/healthy_food_background.png';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF90CAF9),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        semanticLabel: 'Sunny meadow with rainbow and flowers',
      ),
    );
  }
}
