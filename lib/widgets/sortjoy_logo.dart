import 'package:flutter/material.dart';

/// SortJoy wordmark from brand assets.
class SortJoyLogo extends StatelessWidget {
  const SortJoyLogo({
    super.key,
    this.height = 44,
    this.alignment = Alignment.centerLeft,
  });

  final double height;
  final Alignment alignment;

  static const assetPath = 'assets/images/sortjoy_logo.png';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        assetPath,
        height: height,
        fit: BoxFit.contain,
        semanticLabel: 'SortJoy',
      ),
    );
  }
}
