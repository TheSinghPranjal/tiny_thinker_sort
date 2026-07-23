import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Calming playful farm atmosphere for Fruit & Vegetable Sort.
class FarmBackground extends StatefulWidget {
  const FarmBackground({super.key});

  @override
  State<FarmBackground> createState() => _FarmBackgroundState();
}

class _FarmBackgroundState extends State<FarmBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
        final t = _motion.value;
        return CustomPaint(
          painter: _FarmPainter(t: t),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _FarmPainter extends CustomPainter {
  _FarmPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Sky gradient
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [SortJoyColors.skyTop, SortJoyColors.skyBottom],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    // Sun
    final sunPaint = Paint()..color = SortJoyColors.lemon;
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.14), 36, sunPaint);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.14),
      48,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.25),
    );

    // Smiling clouds
    _cloud(canvas, Offset(size.width * 0.18 + sin(t * pi * 2) * 12, 70), 44);
    _cloud(canvas, Offset(size.width * 0.55 + cos(t * pi * 2) * 10, 100), 36);

    // Hills / grass
    final grassPath = Path()
      ..moveTo(0, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.5,
        size.width * 0.5,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.66,
        size.width,
        size.height * 0.56,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(grassPath, Paint()..color = SortJoyColors.grass);
    canvas.drawPath(
      grassPath,
      Paint()
        ..color = SortJoyColors.grassDark.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Fence
    final fenceY = size.height * 0.62;
    final fencePaint = Paint()
      ..color = const Color(0xFFB08968)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (var x = 20.0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, fenceY - 28), Offset(x, fenceY + 10), fencePaint);
    }
    canvas.drawLine(Offset(0, fenceY - 18), Offset(size.width, fenceY - 18), fencePaint);
    canvas.drawLine(Offset(0, fenceY), Offset(size.width, fenceY), fencePaint);

    // Flowers
    _flower(canvas, Offset(40, size.height * 0.72), const Color(0xFFFF8FAB));
    _flower(canvas, Offset(90, size.height * 0.76), const Color(0xFFFFE66D));
    _flower(canvas, Offset(size.width - 50, size.height * 0.74), const Color(0xFFA78BFA));

    // Butterfly
    final bx = size.width * (0.2 + 0.6 * ((sin(t * pi * 2) + 1) / 2));
    final by = size.height * 0.28 + sin(t * pi * 4) * 18;
    _butterfly(canvas, Offset(bx, by), t);

    // Birds
    _bird(canvas, Offset(size.width * 0.3 + t * 40, size.height * 0.22), t);
    _bird(canvas, Offset(size.width * 0.45 + t * 30, size.height * 0.18), t + 0.3);

    // Bee
    final beeX = size.width * 0.7 + cos(t * pi * 2) * 40;
    final beeY = size.height * 0.4 + sin(t * pi * 4) * 16;
    _bee(canvas, Offset(beeX, beeY));
  }

  void _cloud(Canvas canvas, Offset c, double r) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.92);
    canvas.drawCircle(c, r, paint);
    canvas.drawCircle(c + Offset(-r * 0.7, 8), r * 0.7, paint);
    canvas.drawCircle(c + Offset(r * 0.65, 10), r * 0.75, paint);
    // smile
    final smile = Paint()
      ..color = SortJoyColors.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 6), width: r * 0.6, height: r * 0.4),
      0.2,
      pi - 0.4,
      false,
      smile,
    );
    canvas.drawCircle(c + Offset(-10, -4), 3, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + Offset(10, -4), 3, Paint()..color = SortJoyColors.inkSoft);
  }

  void _flower(Canvas canvas, Offset c, Color color) {
    final petal = Paint()..color = color;
    for (var i = 0; i < 5; i++) {
      final a = i * pi * 2 / 5;
      canvas.drawCircle(
        c + Offset(cos(a) * 8, sin(a) * 8),
        7,
        petal,
      );
    }
    canvas.drawCircle(c, 5, Paint()..color = SortJoyColors.lemon);
  }

  void _butterfly(Canvas canvas, Offset c, double t) {
    final flap = 0.6 + sin(t * pi * 8) * 0.35;
    final paint = Paint()..color = SortJoyColors.lavender;
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(flap, 1);
    canvas.drawOval(Rect.fromCenter(center: const Offset(-10, 0), width: 18, height: 14), paint);
    canvas.drawOval(Rect.fromCenter(center: const Offset(10, 0), width: 18, height: 14), paint);
    canvas.restore();
    canvas.drawCircle(c, 3, Paint()..color = SortJoyColors.ink);
  }

  void _bird(Canvas canvas, Offset c, double t) {
    final paint = Paint()
      ..color = SortJoyColors.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final wing = sin(t * pi * 6) * 6;
    canvas.drawArc(
      Rect.fromCenter(center: c + Offset(-8, wing), width: 16, height: 10),
      pi,
      pi,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: c + Offset(8, -wing), width: 16, height: 10),
      pi,
      pi,
      false,
      paint,
    );
  }

  void _bee(Canvas canvas, Offset c) {
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 14, height: 10),
      Paint()..color = SortJoyColors.lemon,
    );
    canvas.drawLine(
      c + const Offset(-4, -2),
      c + const Offset(-4, 2),
      Paint()
        ..color = SortJoyColors.ink
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      c + const Offset(2, -2),
      c + const Offset(2, 2),
      Paint()
        ..color = SortJoyColors.ink
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      c + const Offset(-2, -8),
      5,
      Paint()..color = Colors.white.withValues(alpha: 0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _FarmPainter oldDelegate) => oldDelegate.t != t;
}
