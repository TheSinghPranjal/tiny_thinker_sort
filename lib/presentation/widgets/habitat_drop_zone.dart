import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/sort_category.dart';
import '../../theme/sortjoy_theme.dart';

/// Drop zone drawn as a cosy house (pets) or a jungle (wild animals).
class HabitatDropZone extends StatefulWidget {
  const HabitatDropZone({
    super.key,
    required this.category,
    required this.glow,
    required this.wiggle,
    required this.count,
  });

  final SortCategory category;
  final bool glow;
  final bool wiggle;
  final int count;

  @override
  State<HabitatDropZone> createState() => _HabitatDropZoneState();
}

class _HabitatDropZoneState extends State<HabitatDropZone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final house = widget.category.zoneStyle == 'house';
    final color = Color(widget.category.color);
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        final invite = sin(_bounce.value * pi) * 4;
        final wiggle = widget.wiggle ? sin(_bounce.value * pi * 6) * 5 : 0.0;
        return Transform.translate(
          offset: Offset(wiggle, -invite),
          child: child,
        );
      },
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: Color.lerp(color, Colors.black, 0.18),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: widget.glow ? 0.45 : 0.22),
              blurRadius: widget.glow ? 24 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: widget.glow ? SortJoyColors.glow : Colors.white,
              width: widget.glow ? 4 : 3,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: house
                    ? const _HousePainter()
                    : const _JunglePainter(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.category.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black54),
                        ],
                      ),
                    ),
                    if (widget.category.caption != null)
                      Text(
                        widget.category.caption!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          shadows: [
                            Shadow(blurRadius: 4, color: Colors.black45),
                          ],
                        ),
                      ),
                    Text(
                      '${widget.count}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HousePainter extends CustomPainter {
  const _HousePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8EC5FF), Color(0xFFFFE0B2)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final wall = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.42, w * 0.64, h * 0.40),
      const Radius.circular(8),
    );
    canvas.drawRRect(wall, Paint()..color = const Color(0xFFFFF3E0));
    canvas.drawRRect(
      wall,
      Paint()
        ..color = const Color(0xFFE6C39A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final roof = Path()
      ..moveTo(w * 0.10, h * 0.46)
      ..lineTo(w * 0.50, h * 0.16)
      ..lineTo(w * 0.90, h * 0.46)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFFE57373));
    canvas.drawPath(
      roof,
      Paint()
        ..color = const Color(0xFFC62828)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );

    final door = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.42, h * 0.56, w * 0.16, h * 0.26),
      const Radius.circular(6),
    );
    canvas.drawRRect(door, Paint()..color = const Color(0xFF8D6E63));
    canvas.drawCircle(
      Offset(w * 0.54, h * 0.70),
      2.4,
      Paint()..color = const Color(0xFFFFE082),
    );

    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.52, w * 0.14, h * 0.14),
      const Radius.circular(4),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFF81D4FA));
    canvas.drawLine(
      Offset(w * 0.31, h * 0.52),
      Offset(w * 0.31, h * 0.66),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(w * 0.24, h * 0.59),
      Offset(w * 0.38, h * 0.59),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1.5,
    );

    // Warm chimney.
    canvas.drawRect(
      Rect.fromLTWH(w * 0.68, h * 0.18, w * 0.08, h * 0.16),
      Paint()..color = const Color(0xFFBCAAA4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _JunglePainter extends CustomPainter {
  const _JunglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF81C784), Color(0xFF1B5E20)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    canvas.drawCircle(
      Offset(w * 0.82, h * 0.18),
      w * 0.08,
      Paint()..color = const Color(0xFFFFF59D),
    );

    void tree(double cx, double scale, Color leaves) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cx, h * 0.62),
            width: 10 * scale,
            height: h * 0.28,
          ),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF6D4C41),
      );
      canvas.drawCircle(
        Offset(cx, h * 0.42),
        22 * scale,
        Paint()..color = leaves,
      );
      canvas.drawCircle(
        Offset(cx - 14 * scale, h * 0.50),
        16 * scale,
        Paint()..color = leaves,
      );
      canvas.drawCircle(
        Offset(cx + 14 * scale, h * 0.50),
        16 * scale,
        Paint()..color = Color.lerp(leaves, Colors.black, 0.08)!,
      );
    }

    tree(w * 0.28, 1.05, const Color(0xFF2E7D32));
    tree(w * 0.72, 0.92, const Color(0xFF43A047));

    // Ground.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.82),
        width: w * 0.9,
        height: h * 0.16,
      ),
      Paint()..color = const Color(0xFF33691E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
