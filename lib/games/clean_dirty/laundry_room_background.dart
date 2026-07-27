import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Cheerful cartoon laundry room with soft ambient motion.
class LaundryRoomBackground extends StatefulWidget {
  const LaundryRoomBackground({
    super.key,
    this.bubbleEffects = true,
    this.reducedMotion = false,
    this.cheerLevel = 0,
  });

  final bool bubbleEffects;
  final bool reducedMotion;

  /// Increases decorative sparkle after successful sorts (0–10).
  final int cheerLevel;

  @override
  State<LaundryRoomBackground> createState() => _LaundryRoomBackgroundState();
}

class _LaundryRoomBackgroundState extends State<LaundryRoomBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.reducedMotion ? 16 : 10),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant LaundryRoomBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) {
      _motion.duration = Duration(seconds: widget.reducedMotion ? 16 : 10);
    }
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
          painter: _LaundryRoomPainter(
            t: _motion.value,
            bubbleEffects: widget.bubbleEffects && !widget.reducedMotion,
            cheerLevel: widget.cheerLevel,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _LaundryRoomPainter extends CustomPainter {
  _LaundryRoomPainter({
    required this.t,
    required this.bubbleEffects,
    required this.cheerLevel,
  });

  final double t;
  final bool bubbleEffects;
  final int cheerLevel;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft sky-to-cream laundry room wash
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB3E5FC),
          Color(0xFFE1F5FE),
          Color(0xFFFFF8E7),
          Color(0xFFFFECB3),
        ],
        stops: [0, 0.35, 0.72, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // Wallpaper polka dots
    final dotPaint = Paint()..color = const Color(0xFFFF8FAB).withValues(alpha: 0.18);
    for (var row = 0; row < 8; row++) {
      for (var col = 0; col < 10; col++) {
        final x = size.width * (0.06 + col * 0.1);
        final y = size.height * (0.08 + row * 0.08);
        canvas.drawCircle(Offset(x, y), 5, dotPaint);
      }
    }

    // Rainbow curtains
    _curtains(canvas, size);

    // Big smiling window
    _window(canvas, size);

    // Fairy lights
    _fairyLights(canvas, size);

    // Shelf
    _shelf(canvas, Offset(size.width * 0.08, size.height * 0.38));

    // Rug
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.78),
        width: size.width * 0.55,
        height: size.height * 0.1,
      ),
      Paint()..color = const Color(0xFFFF8A65).withValues(alpha: 0.35),
    );

    // Detergent bottles
    _bottle(canvas, Offset(size.width * 0.12, size.height * 0.52), const Color(0xFF4FC3F7));
    _bottle(canvas, Offset(size.width * 0.88, size.height * 0.5), const Color(0xFFFF80AB));

    // Flower pot on sill
    _flowerPot(canvas, Offset(size.width * 0.72, size.height * 0.34));

    // Ambient bubbles
    if (bubbleEffects) {
      _bubbles(canvas, size);
    }

    // Cheer sparkles
    final sparkles = 4 + cheerLevel.clamp(0, 10);
    for (var i = 0; i < sparkles; i++) {
      final px = size.width * (0.15 + (i * 0.09) % 0.7);
      final py = size.height * (0.18 + sin(t * pi * 2 + i) * 0.04);
      canvas.drawCircle(
        Offset(px, py),
        2.5,
        Paint()..color = SortJoyColors.glow.withValues(alpha: 0.55),
      );
    }

    // Tiny bird peek
    final birdX = size.width * 0.62 + sin(t * pi * 2) * 6;
    _bird(canvas, Offset(birdX, size.height * 0.2));

    // Butterfly
    final bfX = size.width * 0.78 + cos(t * pi * 2) * 18;
    final bfY = size.height * 0.16 + sin(t * pi * 4) * 10;
    _butterfly(canvas, Offset(bfX, bfY));
  }

  void _curtains(Canvas canvas, Size size) {
    final left = Path()
      ..moveTo(size.width * 0.28, size.height * 0.1)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.22 + sin(t * pi * 2) * 4,
        size.width * 0.3,
        size.height * 0.36,
      )
      ..lineTo(size.width * 0.22, size.height * 0.36)
      ..close();
    canvas.drawPath(
      left,
      Paint()..color = const Color(0xFFFF8FAB).withValues(alpha: 0.7),
    );

    final right = Path()
      ..moveTo(size.width * 0.72, size.height * 0.1)
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.22 + cos(t * pi * 2) * 4,
        size.width * 0.7,
        size.height * 0.36,
      )
      ..lineTo(size.width * 0.78, size.height * 0.36)
      ..close();
    canvas.drawPath(
      right,
      Paint()..color = const Color(0xFF80DEEA).withValues(alpha: 0.7),
    );
  }

  void _window(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.1,
        size.width * 0.36,
        size.height * 0.24,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFF9C4), Color(0xFF81D4FA)],
        ).createShader(rect.outerRect),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    final midX = size.width * 0.5;
    canvas.drawLine(
      Offset(midX, size.height * 0.1),
      Offset(midX, size.height * 0.34),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 3,
    );
    // Sunshine beams
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.18),
      14,
      Paint()..color = const Color(0xFFFFF176).withValues(alpha: 0.85),
    );
  }

  void _fairyLights(Canvas canvas, Size size) {
    final y = size.height * 0.08;
    for (var i = 0; i < 9; i++) {
      final x = size.width * (0.15 + i * 0.09);
      final glow = 0.45 + 0.35 * sin(t * pi * 2 + i);
      canvas.drawCircle(
        Offset(x, y + sin(i + t * pi * 2) * 2),
        4,
        Paint()
          ..color = [
            SortJoyColors.lemon,
            SortJoyColors.berry,
            SortJoyColors.mint,
            SortJoyColors.lavender,
          ][i % 4]
              .withValues(alpha: glow),
      );
    }
  }

  void _shelf(Canvas canvas, Offset origin) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, origin.dy, 90, 12),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFA1887F),
    );
    canvas.drawCircle(
      origin + const Offset(20, -10),
      8,
      Paint()..color = SortJoyColors.coral,
    );
    canvas.drawCircle(
      origin + const Offset(48, -12),
      9,
      Paint()..color = SortJoyColors.mint,
    );
  }

  void _bottle(Canvas canvas, Offset c, Color color) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: 28, height: 48),
        const Radius.circular(10),
      ),
      Paint()..color = color,
    );
    canvas.drawCircle(
      c + const Offset(-4, -6),
      3,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      c + const Offset(5, -6),
      3,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      c + const Offset(-4, -6),
      1.4,
      Paint()..color = SortJoyColors.ink,
    );
    canvas.drawCircle(
      c + const Offset(5, -6),
      1.4,
      Paint()..color = SortJoyColors.ink,
    );
    canvas.drawArc(
      Rect.fromCenter(center: c + const Offset(0, 4), width: 12, height: 8),
      0.2,
      pi - 0.4,
      false,
      Paint()
        ..color = SortJoyColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _flowerPot(Canvas canvas, Offset c) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c + const Offset(0, 10), width: 28, height: 22),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFF8A65),
    );
    canvas.drawCircle(
      c + Offset(0, -6 + sin(t * pi * 2) * 2),
      10,
      Paint()..color = const Color(0xFFFF80AB),
    );
  }

  void _bubbles(Canvas canvas, Size size) {
    for (var i = 0; i < 10; i++) {
      final x = size.width * ((0.1 + i * 0.08 + t * 0.15) % 0.9);
      final y = size.height * (0.55 - ((t + i * 0.07) % 1.0) * 0.35);
      final r = 6.0 + (i % 3) * 3;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawCircle(
        Offset(x - r * 0.25, y - r * 0.25),
        r * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.5),
      );
    }
  }

  void _bird(Canvas canvas, Offset c) {
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 16, height: 10),
      Paint()..color = const Color(0xFFFFCA28),
    );
    canvas.drawCircle(
      c + const Offset(6, -2),
      1.5,
      Paint()..color = SortJoyColors.ink,
    );
  }

  void _butterfly(Canvas canvas, Offset c) {
    final wing = Paint()..color = const Color(0xFFCE93D8).withValues(alpha: 0.85);
    canvas.drawOval(
      Rect.fromCenter(center: c + const Offset(-6, 0), width: 12, height: 8),
      wing,
    );
    canvas.drawOval(
      Rect.fromCenter(center: c + const Offset(6, 0), width: 12, height: 8),
      wing,
    );
    canvas.drawCircle(c, 2.5, Paint()..color = SortJoyColors.inkSoft);
  }

  @override
  bool shouldRepaint(covariant _LaundryRoomPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.bubbleEffects != bubbleEffects ||
      oldDelegate.cheerLevel != cheerLevel;
}
