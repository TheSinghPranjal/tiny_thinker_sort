import 'package:flutter/material.dart';

/// Shared app background image used across SortJoy.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  static const assetPath = 'assets/images/app_background.png';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFF90CAF9)),
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
