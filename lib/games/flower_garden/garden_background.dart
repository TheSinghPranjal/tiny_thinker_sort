import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Magical spring garden for Flower Garden color matching.
class GardenBackground extends StatefulWidget {
  const GardenBackground({super.key});

  @override
  State<GardenBackground> createState() => _GardenBackgroundState();
}

class _GardenBackgroundState extends State<GardenBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
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
          painter: _GardenPainter(t: _motion.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _GardenPainter extends CustomPainter {
  _GardenPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF42A5F5),
          Color(0xFF64B5F6),
          Color(0xFF90CAF9),
          Color(0xFFB3E5FC),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Warm sunshine with gentle rays
    final sunCenter = Offset(size.width * 0.86, size.height * 0.1);
    canvas.drawCircle(
      sunCenter,
      36,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.35),
    );
    canvas.drawCircle(
      sunCenter,
      26,
      Paint()..color = SortJoyColors.lemon,
    );
    for (var i = 0; i < 8; i++) {
      final angle = -0.5 + i * 0.14 + sin(t * pi * 2) * 0.02;
      canvas.save();
      canvas.translate(sunCenter.dx, sunCenter.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-5, 0, 10, 52),
          const Radius.circular(5),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.12 + i * 0.015),
      );
      canvas.restore();
    }
    // Smiling sun face
    canvas.drawCircle(
      sunCenter + const Offset(-7, -2),
      2.5,
      Paint()..color = SortJoyColors.inkSoft,
    );
    canvas.drawCircle(
      sunCenter + const Offset(7, -2),
      2.5,
      Paint()..color = SortJoyColors.inkSoft,
    );
    canvas.drawArc(
      Rect.fromCenter(center: sunCenter + const Offset(0, 4), width: 14, height: 8),
      0.2,
      pi - 0.4,
      false,
      Paint()
        ..color = SortJoyColors.inkSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Rainbow corner
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
          center: Offset(size.width * 0.1, size.height * 0.2),
          width: size.width * 0.38 - i * 10,
          height: size.height * 0.22 - i * 8,
        ),
        pi * 0.08,
        pi * 0.85,
        false,
        Paint()
          ..color = rainbowColors[i].withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
    }

    // Drifting clouds
    _cloud(canvas, Offset(size.width * 0.18 + sin(t * pi * 2) * 14, 52), 32);
    _cloud(canvas, Offset(size.width * 0.52 + cos(t * pi * 2) * 11, 78), 26);
    _cloud(canvas, Offset(size.width * 0.76 + sin(t * pi * 2 + 1) * 9, 58), 22);

    // Layered hills
    _hill(canvas, size, 0.5, SortJoyColors.grass, 0.0);
    _hill(canvas, size, 0.56, SortJoyColors.grassDark.withValues(alpha: 0.88), 0.06);
    _hill(canvas, size, 0.62, SortJoyColors.grassDark, 0.12);

    // Cartoon trees
    _tree(canvas, Offset(size.width * 0.08, size.height * 0.54));
    _tree(canvas, Offset(size.width * 0.88, size.height * 0.5), scale: 0.92);
    _tree(canvas, Offset(size.width * 0.7, size.height * 0.56), scale: 0.78);

    // Grass flowers
    _miniFlower(
      canvas,
      Offset(size.width * 0.28 + sin(t * pi * 2) * 3, size.height * 0.66),
      SortJoyColors.berry,
    );
    _miniFlower(
      canvas,
      Offset(size.width * 0.4 + cos(t * pi * 2) * 4, size.height * 0.7),
      SortJoyColors.lemon,
    );
    _miniFlower(
      canvas,
      Offset(size.width * 0.56 + sin(t * pi * 2 + 0.5) * 3, size.height * 0.68),
      SortJoyColors.lavender,
    );
    _miniFlower(
      canvas,
      Offset(size.width * 0.74 + cos(t * pi * 2 + 0.3) * 4, size.height * 0.72),
      SortJoyColors.coral,
    );

    // Butterflies
    _butterfly(
      canvas,
      Offset(
        size.width * (0.28 + 0.38 * ((sin(t * pi * 2) + 1) / 2)),
        size.height * 0.26 + sin(t * pi * 4) * 16,
      ),
      t,
    );
    _butterfly(
      canvas,
      Offset(size.width * 0.62 + cos(t * pi * 3) * 22, size.height * 0.3),
      t + 0.5,
    );

    // Bees
    _bee(canvas, Offset(size.width * 0.45 + sin(t * pi * 3) * 30, size.height * 0.34), t);
    _bee(canvas, Offset(size.width * 0.78 + cos(t * pi * 2.5) * 18, size.height * 0.38), t + 0.7);

    // Ladybugs on leaves
    _ladybug(canvas, Offset(size.width * 0.22, size.height * 0.62 + sin(t * pi * 2) * 2));
    _ladybug(canvas, Offset(size.width * 0.82, size.height * 0.64));

    // Birds
    _bird(canvas, Offset(size.width * 0.32 + t * 45, size.height * 0.12), t);
    _bird(canvas, Offset(size.width * 0.55 + t * 32, size.height * 0.16), t + 0.6);

    // Floating bubbles
    for (var i = 0; i < 7; i++) {
      final bx = size.width * (0.12 + i * 0.12);
      final by = size.height * (0.32 + (t + i * 0.13) % 1.0 * 0.28);
      canvas.drawCircle(
        Offset(bx, by),
        5 + i * 1.4,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.38)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // Sparkles
    for (var i = 0; i < 10; i++) {
      final sx = size.width * (0.08 + i * 0.09);
      final sy = size.height * (0.12 + (i % 4) * 0.07);
      final alpha = 0.35 + sin(t * pi * 4 + i) * 0.28;
      canvas.drawCircle(
        Offset(sx, sy),
        2.2,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }

    // Drifting leaves
    for (var i = 0; i < 4; i++) {
      final lx = size.width * ((t * 0.15 + i * 0.22) % 1.0);
      final ly = size.height * (0.22 + i * 0.06) + sin(t * pi * 2 + i) * 8;
      _leaf(canvas, Offset(lx, ly), i * 0.8);
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
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.96);
    canvas.drawCircle(c, r, paint);
    canvas.drawCircle(c + Offset(-r * 0.65, 6), r * 0.7, paint);
    canvas.drawCircle(c + Offset(r * 0.6, 8), r * 0.72, paint);
    canvas.drawCircle(c + const Offset(-8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + const Offset(8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
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
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: base, width: 14 * scale, height: 44 * scale),
        Radius.circular(4 * scale),
      ),
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

  void _miniFlower(Canvas canvas, Offset c, Color color) {
    for (var i = 0; i < 5; i++) {
      final a = i * pi * 2 / 5;
      canvas.drawCircle(
        c + Offset(cos(a) * 7, sin(a) * 7),
        6,
        Paint()..color = color,
      );
    }
    canvas.drawCircle(c, 4, Paint()..color = SortJoyColors.lemon);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c + const Offset(0, 12), width: 3, height: 14),
        const Radius.circular(1.5),
      ),
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

  void _bee(Canvas canvas, Offset c, double t) {
    final wing = sin(t * pi * 10) * 3;
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 14, height: 10),
      Paint()..color = SortJoyColors.lemon,
    );
    canvas.drawLine(
      c + const Offset(-5, 0),
      c + const Offset(5, 0),
      Paint()
        ..color = SortJoyColors.inkSoft
        ..strokeWidth = 2,
    );
    canvas.drawOval(
      Rect.fromCenter(center: c + Offset(-8, wing), width: 10, height: 7),
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
    canvas.drawOval(
      Rect.fromCenter(center: c + Offset(8, -wing), width: 10, height: 7),
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _ladybug(Canvas canvas, Offset c) {
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 12, height: 10),
      Paint()..color = const Color(0xFFE53935),
    );
    canvas.drawLine(
      c + const Offset(0, -4),
      c + const Offset(0, 4),
      Paint()
        ..color = SortJoyColors.inkSoft
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(c + const Offset(-3, -1), 1.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + const Offset(3, 1), 1.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + const Offset(0, -6), 3, Paint()..color = SortJoyColors.inkSoft);
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

  void _leaf(Canvas canvas, Offset c, double rot) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rot);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 14, height: 8),
      Paint()..color = SortJoyColors.grass.withValues(alpha: 0.75),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GardenPainter oldDelegate) => oldDelegate.t != t;
}
