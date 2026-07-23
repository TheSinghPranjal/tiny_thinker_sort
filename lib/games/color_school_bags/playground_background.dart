import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Magical outdoor preschool playground for Color School Bags.
class PlaygroundBackground extends StatefulWidget {
  const PlaygroundBackground({super.key});

  @override
  State<PlaygroundBackground> createState() => _PlaygroundBackgroundState();
}

class _PlaygroundBackgroundState extends State<PlaygroundBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _motion,
      builder: (context, _) {
        return CustomPaint(
          painter: _PlaygroundPainter(t: _motion.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _PlaygroundPainter extends CustomPainter {
  _PlaygroundPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Bright blue sky gradient
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF64B5F6),
          Color(0xFF90CAF9),
          Color(0xFFB3E5FC),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Soft sunlight rays
    for (var i = 0; i < 5; i++) {
      final angle = -0.4 + i * 0.12;
      canvas.save();
      canvas.translate(size.width * 0.88, size.height * 0.08);
      canvas.rotate(angle);
      canvas.drawRect(
        Rect.fromLTWH(-8, 0, 16, size.height * 0.45),
        Paint()..color = Colors.white.withValues(alpha: 0.08 + i * 0.02),
      );
      canvas.restore();
    }

    // Rainbow in corner
    final rainbowColors = [
      const Color(0xFFE53935),
      const Color(0xFFFF9800),
      SortJoyColors.lemon,
      SortJoyColors.grass,
      const Color(0xFF1E88E5),
      SortJoyColors.lavender,
    ];
    for (var i = 0; i < rainbowColors.length; i++) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.12, size.height * 0.18),
          width: size.width * 0.35 - i * 10,
          height: size.height * 0.2 - i * 8,
        ),
        pi * 0.1,
        pi * 0.8,
        false,
        Paint()
          ..color = rainbowColors[i].withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
    }

    // Smiling clouds drifting
    _cloud(canvas, Offset(size.width * 0.2 + sin(t * pi * 2) * 12, 58), 30);
    _cloud(canvas, Offset(size.width * 0.55 + cos(t * pi * 2) * 10, 82), 24);
    _cloud(canvas, Offset(size.width * 0.78 + sin(t * pi * 2 + 1) * 8, 64), 20);

    // Rolling green hills with depth
    _hill(canvas, size, 0.52, SortJoyColors.grass, 0.0);
    _hill(canvas, size, 0.58, SortJoyColors.grassDark.withValues(alpha: 0.85), 0.08);

    // Friendly trees
    _tree(canvas, Offset(size.width * 0.1, size.height * 0.56));
    _tree(canvas, Offset(size.width * 0.85, size.height * 0.52), scale: 0.9);
    _tree(canvas, Offset(size.width * 0.68, size.height * 0.58), scale: 0.75);

    // Colorful swaying flowers
    _flower(
      canvas,
      Offset(size.width * 0.3 + sin(t * pi * 2) * 3, size.height * 0.68),
      SortJoyColors.berry,
    );
    _flower(
      canvas,
      Offset(size.width * 0.42 + cos(t * pi * 2) * 4, size.height * 0.72),
      SortJoyColors.lemon,
    );
    _flower(
      canvas,
      Offset(size.width * 0.58 + sin(t * pi * 2 + 0.5) * 3, size.height * 0.7),
      SortJoyColors.lavender,
    );
    _flower(
      canvas,
      Offset(size.width * 0.72 + cos(t * pi * 2 + 0.3) * 4, size.height * 0.74),
      SortJoyColors.coral,
    );

    // Butterflies fluttering
    final bx1 = size.width * (0.3 + 0.35 * ((sin(t * pi * 2) + 1) / 2));
    final by1 = size.height * 0.28 + sin(t * pi * 4) * 14;
    _butterfly(canvas, Offset(bx1, by1), t);
    _butterfly(
      canvas,
      Offset(size.width * 0.6 + cos(t * pi * 3) * 20, size.height * 0.32),
      t + 0.5,
    );

    // Birds flying overhead
    _bird(canvas, Offset(size.width * 0.35 + t * 40, size.height * 0.14), t);
    _bird(canvas, Offset(size.width * 0.5 + t * 28, size.height * 0.18), t + 0.6);

    // Floating bubbles
    for (var i = 0; i < 6; i++) {
      final bx = size.width * (0.15 + i * 0.14);
      final by = size.height * (0.35 + (t + i * 0.15) % 1.0 * 0.25);
      canvas.drawCircle(
        Offset(bx, by),
        6 + i * 1.5,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Twinkling sparkles
    for (var i = 0; i < 8; i++) {
      final sx = size.width * (0.1 + i * 0.11);
      final sy = size.height * (0.15 + (i % 3) * 0.08);
      final alpha = 0.3 + sin(t * pi * 4 + i) * 0.25;
      canvas.drawCircle(
        Offset(sx, sy),
        2,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  void _hill(Canvas canvas, Size size, double baseY, Color color, double offset) {
    final hill = Path()
      ..moveTo(0, size.height * baseY)
      ..quadraticBezierTo(
        size.width * (0.25 + offset),
        size.height * (baseY - 0.1),
        size.width * 0.5,
        size.height * (baseY + 0.02),
      )
      ..quadraticBezierTo(
        size.width * (0.75 - offset),
        size.height * (baseY + 0.08),
        size.width,
        size.height * (baseY - 0.04),
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = color);
  }

  void _cloud(Canvas canvas, Offset c, double r) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawCircle(c, r, paint);
    canvas.drawCircle(c + Offset(-r * 0.65, 6), r * 0.7, paint);
    canvas.drawCircle(c + Offset(r * 0.6, 8), r * 0.72, paint);
    canvas.drawCircle(c + Offset(-8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + Offset(8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 4), width: r * 0.5, height: r * 0.32),
      0.2,
      pi - 0.4,
      false,
      Paint()
        ..color = SortJoyColors.inkSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _tree(Canvas canvas, Offset base, {double scale = 1}) {
    canvas.drawRect(
      Rect.fromCenter(center: base, width: 14 * scale, height: 44 * scale),
      Paint()..color = const Color(0xFF8D6E63),
    );
    canvas.drawCircle(
      base + Offset(0, -30 * scale),
      30 * scale,
      Paint()..color = SortJoyColors.grassDark,
    );
    canvas.drawCircle(
      base + Offset(-16 * scale, -20 * scale),
      18 * scale,
      Paint()..color = SortJoyColors.grass,
    );
    canvas.drawCircle(
      base + Offset(16 * scale, -20 * scale),
      18 * scale,
      Paint()..color = SortJoyColors.grass,
    );
  }

  void _flower(Canvas canvas, Offset c, Color color) {
    for (var i = 0; i < 5; i++) {
      final a = i * pi * 2 / 5;
      canvas.drawCircle(
        c + Offset(cos(a) * 7, sin(a) * 7),
        6,
        Paint()..color = color,
      );
    }
    canvas.drawCircle(c, 4, Paint()..color = SortJoyColors.lemon);
    canvas.drawRect(
      Rect.fromCenter(center: c + const Offset(0, 12), width: 3, height: 14),
      Paint()..color = SortJoyColors.grassDark,
    );
  }

  void _butterfly(Canvas canvas, Offset c, double t) {
    final flap = 0.55 + sin(t * pi * 8) * 0.35;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(flap, 1);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-9, 0), width: 16, height: 12),
      Paint()..color = SortJoyColors.lavender,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(9, 0), width: 16, height: 12),
      Paint()..color = SortJoyColors.berry,
    );
    canvas.restore();
  }

  void _bird(Canvas canvas, Offset c, double t) {
    final paint = Paint()
      ..color = SortJoyColors.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final wing = sin(t * pi * 6) * 5;
    canvas.drawArc(
      Rect.fromCenter(center: c + Offset(-7, wing), width: 14, height: 9),
      pi,
      pi,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: c + Offset(7, -wing), width: 14, height: 9),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlaygroundPainter oldDelegate) =>
      oldDelegate.t != t;
}
