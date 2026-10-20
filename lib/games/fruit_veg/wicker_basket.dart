import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_definition.dart';

/// Woven wicker basket drop zone with a cloth liner in the category colour,
/// a cream badge showing the category emoji, and flowers at its feet.
class WickerBasketZone extends StatefulWidget {
  const WickerBasketZone({
    super.key,
    required this.category,
    required this.glow,
    required this.wiggle,
    required this.count,
    this.reducedMotion = false,
  });

  final SortCategory category;
  final bool glow;
  final bool wiggle;

  /// Items sorted here — each change plays a happy squash.
  final int count;
  final bool reducedMotion;

  @override
  State<WickerBasketZone> createState() => _WickerBasketZoneState();
}

class _WickerBasketZoneState extends State<WickerBasketZone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.reducedMotion) _idle.repeat(reverse: true);
  }

  @override
  void dispose() {
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.category.color);

    return Semantics(
      label: '${widget.category.label} basket, ${widget.count} sorted',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 230),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: AnimatedBuilder(
              animation: _idle,
              builder: (context, child) {
                final wiggle = widget.wiggle
                    ? sin(_idle.value * pi * 6) * 0.04
                    : 0.0;
                return Transform.rotate(angle: wiggle, child: child);
              },
              // Keyed on count so every correct drop replays the squash.
              child: TweenAnimationBuilder<double>(
                key: ValueKey(widget.count),
                tween: Tween(begin: widget.count == 0 ? 1 : 0.86, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.elasticOut,
                builder: (context, s, child) => Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.diagonal3Values(2 - s, s, 1),
                  child: child,
                ),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final w = c.maxWidth;
                    final h = c.maxHeight;
                    final badge = w * 0.36;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Guidance glow.
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: widget.glow ? 1 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.3),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFFF176,
                                    ).withValues(alpha: 0.85),
                                    blurRadius: 36,
                                    spreadRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _BasketPainter(liner: color),
                          ),
                        ),
                        Positioned(
                          left: (w - badge) / 2,
                          top: h * 0.43,
                          child: _Badge(
                            size: badge,
                            emoji: widget.category.emoji,
                          ),
                        ),
                        Positioned(
                          left: -4,
                          bottom: -6,
                          child: Text(
                            '🌿',
                            style: TextStyle(fontSize: w * 0.13),
                          ),
                        ),
                        Positioned(
                          left: w * 0.06,
                          bottom: -2,
                          child: Text(
                            '🌼',
                            style: TextStyle(fontSize: w * 0.12),
                          ),
                        ),
                        Positioned(
                          right: w * 0.04,
                          bottom: -4,
                          child: Text(
                            '🌸',
                            style: TextStyle(fontSize: w * 0.11),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -8,
                          child: Text(
                            '🌿',
                            style: TextStyle(fontSize: w * 0.13),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.size, required this.emoji});

  final double size;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFFFFCF3), Color(0xFFFCEFD6)],
        ),
        border: Border.all(color: const Color(0xFFF2B544), width: size * 0.07),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A4512).withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
    );
  }
}

class _BasketPainter extends CustomPainter {
  const _BasketPainter({required this.liner});

  final Color liner;

  static const _wickerLight = Color(0xFFF4BE63);
  static const _wickerMid = Color(0xFFDB9A43);
  static const _wickerDark = Color(0xFFA9661F);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rim = Rect.fromLTWH(0, h * 0.04, w, h * 0.3);
    final rimCy = rim.center.dy;

    // Basket body — gently tapering bowl.
    final body = Path()
      ..moveTo(w * 0.01, rimCy)
      ..cubicTo(w * 0.02, h * 0.7, w * 0.08, h * 0.97, w * 0.2, h * 0.98)
      ..lineTo(w * 0.8, h * 0.98)
      ..cubicTo(w * 0.92, h * 0.97, w * 0.98, h * 0.7, w * 0.99, rimCy)
      ..close();

    canvas.drawShadow(body, const Color(0xFF5A3510), 6, false);
    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_wickerMid, _wickerDark],
        ).createShader(Offset.zero & size),
    );

    // Brick-style weave.
    canvas.save();
    canvas.clipPath(body);
    final rowH = h * 0.1;
    final cellW = w * 0.13;
    final cell = Paint()..color = _wickerLight;
    final seam = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = _wickerDark.withValues(alpha: 0.7);
    var row = 0;
    for (var y = rimCy; y < h; y += rowH, row++) {
      final offset = row.isEven ? 0.0 : cellW / 2;
      for (var x = -cellW + offset; x < w + cellW; x += cellW) {
        final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 1.5, y + 1.5, cellW - 3, rowH - 3),
          Radius.circular(rowH * 0.45),
        );
        canvas.drawRRect(r, cell);
        canvas.drawRRect(r, seam);
      }
    }
    // Side shading for roundness.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _wickerDark.withValues(alpha: 0.45),
            Colors.transparent,
            Colors.transparent,
            _wickerDark.withValues(alpha: 0.5),
          ],
          stops: const [0.0, 0.22, 0.78, 1.0],
        ).createShader(Offset.zero & size),
    );
    canvas.restore();

    // Rim + liner.
    final linerDark = Color.lerp(liner, Colors.black, 0.25)!;
    canvas.drawOval(rim, Paint()..color = linerDark);
    canvas.drawOval(
      rim.deflate(w * 0.07),
      Paint()..color = Color.lerp(liner, Colors.black, 0.5)!,
    );
    // Inner back wall catches a bit of light.
    canvas.drawArc(
      rim.deflate(w * 0.085),
      pi,
      pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03
        ..color = liner.withValues(alpha: 0.8),
    );

    // Cloth drape over the front lip, with scallops.
    final drape = Path()..moveTo(rim.left, rimCy);
    drape.arcTo(rim, pi, -pi, false);
    final drop = h * 0.13;
    const waves = 4;
    for (var i = waves; i > 0; i--) {
      final x0 = rim.left + rim.width * i / waves;
      final x1 = rim.left + rim.width * (i - 1) / waves;
      final yEdge = rimCy + rim.height / 2 * sin(pi * (i - 0.5) / waves);
      drape.quadraticBezierTo(
        (x0 + x1) / 2,
        yEdge + drop * 1.8,
        x1,
        rimCy + rim.height / 2 * sin(pi * (i - 1) / waves) + drop * 0.4,
      );
    }
    drape.close();
    // Soft shadow the cloth casts on the weave.
    canvas.drawPath(
      drape.shift(Offset(0, h * 0.025)),
      Paint()
        ..color = const Color(0xFF5A3510).withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(
      drape,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(liner, Colors.white, 0.15)!, linerDark],
        ).createShader(Rect.fromLTWH(0, rimCy, w, rim.height / 2 + drop * 2)),
    );
    // Highlight along the lip.
    canvas.drawArc(
      rim.deflate(1),
      0.15 * pi,
      0.7 * pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(covariant _BasketPainter oldDelegate) =>
      oldDelegate.liner != liner;
}
