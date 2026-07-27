import 'package:flutter/material.dart';

import '../../theme/sortjoy_theme.dart';

/// Soft clothing chip — sparkly when clean, playfully stained when dirty.
class ClothingChip extends StatelessWidget {
  const ClothingChip({
    super.key,
    required this.emoji,
    required this.size,
    required this.isDirty,
    this.accentColor,
  });

  final String emoji;
  final double size;
  final bool isDirty;
  final int? accentColor;

  @override
  Widget build(BuildContext context) {
    final base = Color(accentColor ?? (isDirty ? 0xFFBCAAA4 : 0xFF81D4FA));
    final fill = isDirty
        ? Color.lerp(base, const Color(0xFF8D6E63), 0.28)!
        : base;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  fill.withValues(alpha: 0.95),
                  Color.lerp(fill, Colors.white, 0.25)!,
                ],
              ),
              borderRadius: BorderRadius.circular(size * 0.28),
              border: Border.all(
                color: isDirty
                    ? const Color(0xFFA1887F)
                    : Colors.white.withValues(alpha: 0.95),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDirty ? const Color(0xFF8D6E63) : SortJoyColors.mint)
                      .withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          Text(emoji, style: TextStyle(fontSize: size * 0.42)),
          if (!isDirty)
            Positioned(
              top: size * 0.12,
              right: size * 0.14,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: size * 0.18,
                color: SortJoyColors.glow.withValues(alpha: 0.95),
              ),
            ),
          if (isDirty) ...[
            Positioned(
              left: size * 0.18,
              bottom: size * 0.22,
              child: _Stain(size: size * 0.16, color: const Color(0xFF8D6E63)),
            ),
            Positioned(
              right: size * 0.2,
              top: size * 0.28,
              child: _Stain(size: size * 0.12, color: const Color(0xFF6D4C41)),
            ),
            Positioned(
              right: size * 0.28,
              bottom: size * 0.18,
              child: _Stain(size: size * 0.1, color: const Color(0xFF7CB342)),
            ),
          ],
          // Tiny smile so dirty clothes stay friendly
          Positioned(
            bottom: size * 0.12,
            child: CustomPaint(
              size: Size(size * 0.22, size * 0.1),
              painter: _SmilePainter(
                color: SortJoyColors.ink.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stain extends StatelessWidget {
  const _Stain({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.85,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  _SmilePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height,
        size.width,
        size.height * 0.3,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SmilePainter oldDelegate) =>
      oldDelegate.color != color;
}
