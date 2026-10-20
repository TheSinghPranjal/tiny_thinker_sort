import 'dart:math';

import 'package:flutter/material.dart';

/// See-through soap bubble with a rainbow sheen holding a big produce emoji.
class SoapBubbleChip extends StatelessWidget {
  const SoapBubbleChip({
    super.key,
    required this.size,
    required this.emoji,
    this.bobPhase = 0,
  });

  final double size;
  final String emoji;
  final double bobPhase;

  @override
  Widget build(BuildContext context) {
    final wobble = 1 + sin(bobPhase * 1.3) * 0.025;

    return Transform.scale(
      scaleX: wobble,
      scaleY: 2 - wobble,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Bubble film — clear centre, faintly tinted rim.
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.white.withValues(alpha: 0.12),
                    const Color(0xFFBDE7FF).withValues(alpha: 0.35),
                  ],
                  stops: const [0.0, 0.72, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.85),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.35),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: const Color(0xFF1B4F72).withValues(alpha: 0.10),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox.square(dimension: size),
            ),
            CustomPaint(
              size: Size.square(size),
              painter: const _SheenPainter(),
            ),
            Text(
              emoji,
              style: TextStyle(
                fontSize: size * 0.56,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
            // Glossy highlight, top-left.
            Positioned(
              left: size * 0.17,
              top: size * 0.13,
              child: Transform.rotate(
                angle: -0.6,
                child: Container(
                  width: size * 0.26,
                  height: size * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(size),
                  ),
                ),
              ),
            ),
            Positioned(
              left: size * 0.12,
              top: size * 0.32,
              child: Container(
                width: size * 0.06,
                height: size * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Faint rainbow iridescence along the bubble's edge.
class _SheenPainter extends CustomPainter {
  const _SheenPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.05;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        colors: [
          const Color(0xFFFF9EC7).withValues(alpha: 0.0),
          const Color(0xFFFF9EC7).withValues(alpha: 0.35),
          const Color(0xFFFFF59D).withValues(alpha: 0.3),
          const Color(0xFF9EE8FF).withValues(alpha: 0.35),
          const Color(0xFFC9A7FF).withValues(alpha: 0.3),
          const Color(0xFFC9A7FF).withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.15, 0.3, 0.45, 0.6, 0.75],
        transform: const GradientRotation(0.4),
      ).createShader(rect);
    canvas.drawCircle(rect.center, size.width / 2 - stroke, paint);
  }

  @override
  bool shouldRepaint(covariant _SheenPainter oldDelegate) => false;
}
