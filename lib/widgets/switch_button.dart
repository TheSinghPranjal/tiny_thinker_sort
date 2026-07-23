import 'package:flutter/material.dart';

/// Glossy green Switch button for changing age world.
class SwitchButton extends StatelessWidget {
  const SwitchButton({
    super.key,
    required this.onPressed,
    this.height = 40,
  });

  final VoidCallback onPressed;
  final double height;

  static const assetPath = 'assets/images/switch_button.png';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(height),
        child: Image.asset(
          assetPath,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: 'Switch',
        ),
      ),
    );
  }
}
