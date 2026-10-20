import 'package:flutter/material.dart';

/// Picture inside a floating bubble, with the emoji as a load-failure fallback.
class ItemGlyph extends StatelessWidget {
  const ItemGlyph({
    super.key,
    required this.emoji,
    required this.fontSize,
    this.imageAsset,
  });

  final String emoji;
  final double fontSize;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final fallback = Text(emoji, style: TextStyle(fontSize: fontSize));
    final path = imageAsset;
    if (path == null || path.isEmpty) return fallback;
    return Image.asset(
      path,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
