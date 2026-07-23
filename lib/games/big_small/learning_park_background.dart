import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Colorful learning park for Big & Small Sort.
class LearningParkBackground extends StatefulWidget {
  const LearningParkBackground({super.key});

  @override
  State<LearningParkBackground> createState() => _LearningParkBackgroundState();
}

class _LearningParkBackgroundState extends State<LearningParkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
          painter: _LearningParkPainter(t: _motion.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _LearningParkPainter extends CustomPainter {
  _LearningParkPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF81D4FA),
          Color(0xFFE1F5FE),
          Color(0xFFC8E6C9),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Sun
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.12),
      34,
      Paint()..color = SortJoyColors.lemon,
    );
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.12),
      48,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.22),
    );

    // Smiling clouds
    _cloud(canvas, Offset(size.width * 0.18 + sin(t * pi * 2) * 10, 70), 32);
    _cloud(canvas, Offset(size.width * 0.45 + cos(t * pi * 2) * 8, 95), 26);

    // Hills / grass
    final hill = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.45,
        size.width * 0.55,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.66,
        size.width,
        size.height * 0.52,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = SortJoyColors.grass);
    canvas.drawPath(
      hill,
      Paint()
        ..color = SortJoyColors.grassDark.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    // Colorful path
    final path = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.72,
        size.width * 0.55,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.84,
        size.width * 0.95,
        size.height * 0.7,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFE082)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 28
        ..strokeCap = StrokeCap.round,
    );

    // Trees
    _tree(canvas, Offset(size.width * 0.12, size.height * 0.58));
    _tree(canvas, Offset(size.width * 0.78, size.height * 0.54), scale: 0.85);
    _tree(canvas, Offset(size.width * 0.92, size.height * 0.6), scale: 0.7);

    // Flowers
    _flower(canvas, Offset(size.width * 0.28, size.height * 0.7), SortJoyColors.berry);
    _flower(canvas, Offset(size.width * 0.36, size.height * 0.74), SortJoyColors.lemon);
    _flower(canvas, Offset(size.width * 0.62, size.height * 0.72), SortJoyColors.lavender);

    // Playful animals (simple)
    _emojiBlob(
      canvas,
      Offset(size.width * 0.48, size.height * 0.62),
      18,
      const Color(0xFFFFCC80),
    );

    // Balloons
    _balloon(
      canvas,
      Offset(size.width * 0.22, size.height * 0.32 + sin(t * pi * 2) * 10),
      SortJoyColors.coral,
    );
    _balloon(
      canvas,
      Offset(size.width * 0.3, size.height * 0.28 + cos(t * pi * 2) * 8),
      SortJoyColors.lavender,
    );

    // Butterfly & birds
    final bx = size.width * (0.25 + 0.5 * ((sin(t * pi * 2) + 1) / 2));
    final by = size.height * 0.26 + sin(t * pi * 4) * 14;
    _butterfly(canvas, Offset(bx, by), t);
    _bird(canvas, Offset(size.width * 0.55 + t * 30, size.height * 0.18), t);
    _bird(canvas, Offset(size.width * 0.4 + t * 22, size.height * 0.22), t + 0.4);
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
      Rect.fromCenter(center: base, width: 12 * scale, height: 40 * scale),
      Paint()..color = const Color(0xFF8D6E63),
    );
    canvas.drawCircle(
      base + Offset(0, -28 * scale),
      28 * scale,
      Paint()..color = SortJoyColors.grassDark,
    );
    canvas.drawCircle(
      base + Offset(-14 * scale, -18 * scale),
      16 * scale,
      Paint()..color = SortJoyColors.grass,
    );
    canvas.drawCircle(
      base + Offset(14 * scale, -18 * scale),
      16 * scale,
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
  }

  void _balloon(Canvas canvas, Offset c, Color color) {
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 22, height: 28),
      Paint()..color = color,
    );
    canvas.drawLine(
      c + const Offset(0, 14),
      c + const Offset(0, 40),
      Paint()
        ..color = SortJoyColors.inkSoft
        ..strokeWidth = 1.5,
    );
  }

  void _emojiBlob(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c, r, Paint()..color = color);
    canvas.drawCircle(c + const Offset(-5, -3), 2.5, Paint()..color = SortJoyColors.ink);
    canvas.drawCircle(c + const Offset(5, -3), 2.5, Paint()..color = SortJoyColors.ink);
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 2), width: 12, height: 8),
      0.2,
      pi - 0.4,
      false,
      Paint()
        ..color = SortJoyColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
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
  bool shouldRepaint(covariant _LearningParkPainter oldDelegate) =>
      oldDelegate.t != t;
}
