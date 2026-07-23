import 'package:flutter/material.dart';

/// Shared SortJoy meadow landscape used across the app.
class SortJoyBackground extends StatelessWidget {
  const SortJoyBackground({super.key});

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
