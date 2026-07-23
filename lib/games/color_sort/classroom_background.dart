import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Cheerful preschool classroom for Color Sort.
class ClassroomBackground extends StatefulWidget {
  const ClassroomBackground({super.key});

  @override
  State<ClassroomBackground> createState() => _ClassroomBackgroundState();
}

class _ClassroomBackgroundState extends State<ClassroomBackground>
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
          painter: _ClassroomPainter(t: _motion.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ClassroomPainter extends CustomPainter {
  _ClassroomPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft classroom wall
    final wall = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE3F2FD),
          Color(0xFFFFF8E1),
          Color(0xFFFFECB3),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wall);

    // Rainbow arc decoration
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
          center: Offset(size.width * 0.5, size.height * 0.22),
          width: size.width * 0.7 - i * 14,
          height: size.height * 0.28 - i * 10,
        ),
        pi,
        pi,
        false,
        Paint()
          ..color = rainbowColors[i].withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round,
      );
    }

    // Window + sunshine
    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.72, size.height * 0.12, size.width * 0.22, size.height * 0.22),
      const Radius.circular(14),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFFBBDEFB));
    canvas.drawRRect(
      window,
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.18),
      18,
      Paint()..color = SortJoyColors.lemon,
    );
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.18),
      28,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.25),
    );

    // Smiling clouds
    _cloud(canvas, Offset(size.width * 0.18 + sin(t * pi * 2) * 8, 64), 28);
    _cloud(canvas, Offset(size.width * 0.4 + cos(t * pi * 2) * 6, 88), 22);

    // Bunting flags
    final flagColors = [
      SortJoyColors.coral,
      SortJoyColors.lemon,
      SortJoyColors.mint,
      SortJoyColors.lavender,
      SortJoyColors.berry,
      const Color(0xFF1E88E5),
    ];
    final buntY = size.height * 0.34;
    for (var i = 0; i < 8; i++) {
      final x = size.width * (0.08 + i * 0.11);
      final path = Path()
        ..moveTo(x, buntY)
        ..lineTo(x + 18, buntY)
        ..lineTo(x + 9, buntY + 22)
        ..close();
      canvas.drawPath(path, Paint()..color = flagColors[i % flagColors.length]);
    }
    canvas.drawLine(
      Offset(size.width * 0.06, buntY),
      Offset(size.width * 0.94, buntY),
      Paint()
        ..color = SortJoyColors.inkSoft
        ..strokeWidth = 2,
    );

    // Bookshelf
    _bookshelf(canvas, Offset(18, size.height * 0.42));

    // Crayon / pencil cups
    _crayon(canvas, Offset(size.width * 0.28, size.height * 0.55), SortJoyColors.coral);
    _crayon(canvas, Offset(size.width * 0.32, size.height * 0.53), const Color(0xFF1E88E5));
    _crayon(canvas, Offset(size.width * 0.36, size.height * 0.55), SortJoyColors.grass);

    // Paint splashes (soft)
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.48),
      22,
      Paint()..color = SortJoyColors.berry.withValues(alpha: 0.28),
    );
    canvas.drawCircle(
      Offset(size.width * 0.62, size.height * 0.52),
      16,
      Paint()..color = SortJoyColors.mint.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      Offset(size.width * 0.48, size.height * 0.58),
      14,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.35),
    );

    // Flowers
    _flower(canvas, Offset(size.width * 0.42, size.height * 0.68), SortJoyColors.berry);
    _flower(canvas, Offset(size.width * 0.5, size.height * 0.72), SortJoyColors.lavender);

    // Floor strip
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.78, size.width, size.height * 0.22),
      Paint()..color = const Color(0xFFFFE0B2).withValues(alpha: 0.55),
    );

    // Balloons
    _balloon(canvas, Offset(size.width * 0.12, size.height * 0.28 + sin(t * pi * 2) * 8), SortJoyColors.coral);
    _balloon(canvas, Offset(size.width * 0.2, size.height * 0.24 + cos(t * pi * 2) * 6), const Color(0xFF1E88E5));

    // Butterfly & bird
    final bx = size.width * (0.35 + 0.35 * ((sin(t * pi * 2) + 1) / 2));
    final by = size.height * 0.2 + sin(t * pi * 4) * 12;
    _butterfly(canvas, Offset(bx, by), t);
    _bird(canvas, Offset(size.width * 0.65 + t * 20, size.height * 0.16), t);
  }

  void _cloud(Canvas canvas, Offset c, double r) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.95);
    canvas.drawCircle(c, r, paint);
    canvas.drawCircle(c + Offset(-r * 0.65, 5), r * 0.7, paint);
    canvas.drawCircle(c + Offset(r * 0.6, 6), r * 0.72, paint);
    canvas.drawCircle(c + Offset(-8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawCircle(c + Offset(8, -3), 2.5, Paint()..color = SortJoyColors.inkSoft);
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 4), width: r * 0.55, height: r * 0.35),
      0.2,
      pi - 0.4,
      false,
      Paint()
        ..color = SortJoyColors.inkSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _bookshelf(Canvas canvas, Offset origin) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, 78, 100),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFA1887F),
    );
    final colors = [
      SortJoyColors.coral,
      const Color(0xFF1E88E5),
      SortJoyColors.grass,
      SortJoyColors.lemon,
      SortJoyColors.lavender,
    ];
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              origin.dx + 8 + col * 22.0,
              origin.dy + 12 + row * 28.0,
              16,
              22,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = colors[(row + col) % colors.length],
        );
      }
    }
  }

  void _crayon(Canvas canvas, Offset tip, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: tip, width: 10, height: 36),
        const Radius.circular(4),
      ),
      Paint()..color = color,
    );
    final path = Path()
      ..moveTo(tip.dx - 5, tip.dy - 18)
      ..lineTo(tip.dx, tip.dy - 28)
      ..lineTo(tip.dx + 5, tip.dy - 18)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
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
  bool shouldRepaint(covariant _ClassroomPainter oldDelegate) =>
      oldDelegate.t != t;
}
