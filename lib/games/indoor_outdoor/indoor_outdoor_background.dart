import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Split playroom + park atmosphere for Indoor & Outdoor Games Sort.
class IndoorOutdoorBackground extends StatefulWidget {
  const IndoorOutdoorBackground({super.key});

  @override
  State<IndoorOutdoorBackground> createState() =>
      _IndoorOutdoorBackgroundState();
}

class _IndoorOutdoorBackgroundState extends State<IndoorOutdoorBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
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
          painter: _IndoorOutdoorPainter(t: _motion.value),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _IndoorOutdoorPainter extends CustomPainter {
  _IndoorOutdoorPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.width * 0.5;

    // Indoor left
    final indoor = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE0B2), Color(0xFFFFF3E0), Color(0xFFFFCC80)],
      ).createShader(Rect.fromLTWH(0, 0, mid + 40, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, mid + 40, size.height), indoor);

    // Soft indoor wall stripe
    canvas.drawRect(
      Rect.fromLTWH(0, 0, mid, size.height * 0.55),
      Paint()..color = const Color(0xFFFFE8C8).withValues(alpha: 0.55),
    );

    // Window glow (indoor soft lighting)
    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(mid * 0.18, size.height * 0.12, mid * 0.35, size.height * 0.22),
      const Radius.circular(12),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFFFFF8E1));
    canvas.drawRRect(
      window,
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawLine(
      Offset(mid * 0.18 + mid * 0.175, size.height * 0.12),
      Offset(mid * 0.18 + mid * 0.175, size.height * 0.34),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 3,
    );

    // Bookshelf
    _bookshelf(canvas, Offset(24, size.height * 0.38));

    // Rug
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(mid * 0.42, size.height * 0.72),
        width: mid * 0.55,
        height: size.height * 0.12,
      ),
      Paint()..color = SortJoyColors.berry.withValues(alpha: 0.45),
    );

    // Blocks pile
    _block(canvas, Offset(mid * 0.22, size.height * 0.62), SortJoyColors.mint);
    _block(canvas, Offset(mid * 0.28, size.height * 0.58), SortJoyColors.lemon);
    _block(canvas, Offset(mid * 0.34, size.height * 0.62), SortJoyColors.lavender);

    // Teddy
    _emojiBlob(canvas, Offset(mid * 0.55, size.height * 0.55), 22, const Color(0xFFD7CCC8));
    // Cushion
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(mid * 0.7, size.height * 0.68),
          width: 54,
          height: 28,
        ),
        const Radius.circular(14),
      ),
      Paint()..color = SortJoyColors.peach,
    );
    // Indoor plant
    canvas.drawCircle(
      Offset(mid * 0.12, size.height * 0.58),
      16,
      Paint()..color = SortJoyColors.grass,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(mid * 0.12, size.height * 0.62),
          width: 18,
          height: 16,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFA1887F),
    );

    // Outdoor right
    final outdoor = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [SortJoyColors.skyTop, Color(0xFFE3F2FD), SortJoyColors.grass],
      ).createShader(Rect.fromLTWH(mid - 40, 0, size.width - mid + 40, size.height));
    canvas.drawRect(
      Rect.fromLTWH(mid - 40, 0, size.width - mid + 40, size.height),
      outdoor,
    );

    // Soft blend seam
    canvas.drawRect(
      Rect.fromLTWH(mid - 28, 0, 56, size.height),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFFCC80).withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.35),
            SortJoyColors.skyTop.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(mid - 28, 0, 56, size.height)),
    );

    // Sun
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.14),
      34,
      Paint()..color = SortJoyColors.lemon,
    );
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.14),
      48,
      Paint()..color = SortJoyColors.lemon.withValues(alpha: 0.22),
    );

    // Clouds
    _cloud(canvas, Offset(size.width * 0.62 + sin(t * pi * 2) * 10, 70), 30);
    _cloud(canvas, Offset(size.width * 0.78 + cos(t * pi * 2) * 8, 108), 24);

    // Tree
    _tree(canvas, Offset(size.width * 0.72, size.height * 0.52));
    _tree(canvas, Offset(size.width * 0.9, size.height * 0.55), scale: 0.75);

    // Flowers
    _flower(canvas, Offset(size.width * 0.58, size.height * 0.7), SortJoyColors.berry);
    _flower(canvas, Offset(size.width * 0.64, size.height * 0.74), SortJoyColors.lemon);
    _flower(canvas, Offset(size.width * 0.84, size.height * 0.72), SortJoyColors.lavender);

    // Swing frame
    final swingX = size.width * 0.6;
    final swingY = size.height * 0.48;
    final swingPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(swingX, swingY), Offset(swingX - 18, swingY + 70), swingPaint);
    canvas.drawLine(Offset(swingX + 40, swingY), Offset(swingX + 58, swingY + 70), swingPaint);
    canvas.drawLine(Offset(swingX - 8, swingY), Offset(swingX + 48, swingY), swingPaint);
    final seatSwing = sin(t * pi * 2) * 10;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(swingX + 20 + seatSwing, swingY + 55),
          width: 28,
          height: 10,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = SortJoyColors.coral,
    );

    // Slide
    final slidePath = Path()
      ..moveTo(size.width * 0.78, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.86,
        size.height * 0.5,
        size.width * 0.92,
        size.height * 0.62,
      );
    canvas.drawPath(
      slidePath,
      Paint()
        ..color = SortJoyColors.mint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );

    // Butterfly & bird
    final bx = size.width * (0.58 + 0.28 * ((sin(t * pi * 2) + 1) / 2));
    final by = size.height * 0.26 + sin(t * pi * 4) * 14;
    _butterfly(canvas, Offset(bx, by), t);
    _bird(canvas, Offset(size.width * 0.7 + t * 24, size.height * 0.2), t);

    // Balloon
    final balloonY = size.height * 0.3 + sin(t * pi * 2) * 12;
    canvas.drawCircle(
      Offset(size.width * 0.95, balloonY),
      14,
      Paint()..color = SortJoyColors.berry,
    );
    canvas.drawLine(
      Offset(size.width * 0.95, balloonY + 14),
      Offset(size.width * 0.95, balloonY + 42),
      Paint()
        ..color = SortJoyColors.inkSoft
        ..strokeWidth = 1.5,
    );

    // Drifting leaves
    for (var i = 0; i < 4; i++) {
      final lx = size.width * (0.55 + 0.4 * ((t + i * 0.2) % 1));
      final ly = size.height * (0.35 + 0.08 * i) + sin((t + i) * pi * 2) * 10;
      canvas.save();
      canvas.translate(lx, ly);
      canvas.rotate(t * pi * 2 + i);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 12, height: 7),
        Paint()..color = SortJoyColors.grassDark.withValues(alpha: 0.7),
      );
      canvas.restore();
    }
  }

  void _bookshelf(Canvas canvas, Offset origin) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, 70, 90),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFA1887F),
    );
    final colors = [
      SortJoyColors.coral,
      SortJoyColors.mint,
      SortJoyColors.lavender,
      SortJoyColors.lemon,
    ];
    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              origin.dx + 8 + col * 18.0,
              origin.dy + 10 + row * 26.0,
              14,
              20,
            ),
            const Radius.circular(3),
          ),
          Paint()..color = colors[(row + col) % colors.length],
        );
      }
    }
  }

  void _block(Canvas canvas, Offset c, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: 22, height: 22),
        const Radius.circular(6),
      ),
      Paint()..color = color,
    );
  }

  void _emojiBlob(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c, r, Paint()..color = color);
    canvas.drawCircle(c + const Offset(-6, -4), 3, Paint()..color = SortJoyColors.ink);
    canvas.drawCircle(c + const Offset(6, -4), 3, Paint()..color = SortJoyColors.ink);
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 2), width: 14, height: 10),
      0.15,
      pi - 0.3,
      false,
      Paint()
        ..color = SortJoyColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _tree(Canvas canvas, Offset base, {double scale = 1}) {
    canvas.drawRect(
      Rect.fromCenter(
        center: base,
        width: 12 * scale,
        height: 40 * scale,
      ),
      Paint()..color = const Color(0xFF8D6E63),
    );
    canvas.drawCircle(
      base + Offset(0, -28 * scale),
      28 * scale,
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

  void _cloud(Canvas canvas, Offset c, double r) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.92);
    canvas.drawCircle(c, r, paint);
    canvas.drawCircle(c + Offset(-r * 0.7, 6), r * 0.7, paint);
    canvas.drawCircle(c + Offset(r * 0.65, 8), r * 0.72, paint);
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
  bool shouldRepaint(covariant _IndoorOutdoorPainter oldDelegate) =>
      oldDelegate.t != t;
}
