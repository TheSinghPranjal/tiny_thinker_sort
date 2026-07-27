import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Soft premium kids-app game card (Figma: warm fill, triple shadow, inset art).
class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.titleColor,
    this.placeholderEmoji,
  });

  final String image;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color titleColor;
  final String? placeholderEmoji;

  static const _subtitleColor = Color(0xFF5C5145);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFDF8),
            Color(0xFFFFF3E8),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 2.5,
        ),
        boxShadow: [
          // Contact shadow — sits right under the card
          BoxShadow(
            color: const Color(0xFF8A6F4A).withValues(alpha: 0.18),
            blurRadius: 6,
            spreadRadius: -1,
            offset: const Offset(0, 3),
          ),
          // Mid lift
          BoxShadow(
            color: const Color(0xFF8A6F4A).withValues(alpha: 0.16),
            blurRadius: 22,
            spreadRadius: -2,
            offset: const Offset(0, 12),
          ),
          // Soft ambient float
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 40,
            spreadRadius: -6,
            offset: const Offset(0, 22),
          ),
          // Side bloom for pillowy edges
          BoxShadow(
            color: const Color(0xFF8A6F4A).withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.5),
        child: Stack(
          children: [
            // Convex bulge lighting (bright center-top)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.35, -0.85),
                      radius: 1.15,
                      colors: [
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
            // Top rim highlight (inset light)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 14,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Left rim highlight
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              width: 10,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom inner shade — grounds the bulge
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 28,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF8A6F4A).withValues(alpha: 0.10),
                        const Color(0xFF8A6F4A).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CardImage(
                      image: image,
                      placeholderEmoji: placeholderEmoji,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: _subtitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 12,
              bottom: 12,
              child: _DecorIcon(),
            ),
            if (badge.isNotEmpty)
              Positioned(
                top: 16,
                right: 16,
                child: _Badge(text: badge, color: badgeColor),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.image,
    this.placeholderEmoji,
  });

  final String image;
  final String? placeholderEmoji;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A6F4A).withValues(alpha: 0.14),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF9CCDF4),
                          Color(0xFFA3CC46),
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      placeholderEmoji ?? '🎮',
                      style: const TextStyle(fontSize: 48),
                    ),
                  );
                },
              ),
              // Soft gloss on image well
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.22),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.06),
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative flower sticker — bottom-right of the text block.
class _DecorIcon extends StatelessWidget {
  const _DecorIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const CustomPaint(painter: _FlowerPainter()),
      ),
    );
  }
}

class _FlowerPainter extends CustomPainter {
  const _FlowerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.48;
    final cy = size.height * 0.42;
    final petalPaint = Paint()..color = const Color(0xFFF06FA6);
    final centerPaint = Paint()..color = const Color(0xFFFFC94D);
    final leafPaint = Paint()..color = const Color(0xFF7CBF3A);

    final leftLeaf = Path()
      ..moveTo(cx - 2, cy + 4)
      ..quadraticBezierTo(cx - 14, cy + 10, cx - 4, cy + 14)
      ..quadraticBezierTo(cx - 2, cy + 10, cx - 2, cy + 4);
    final rightLeaf = Path()
      ..moveTo(cx + 2, cy + 5)
      ..quadraticBezierTo(cx + 14, cy + 12, cx + 5, cy + 14)
      ..quadraticBezierTo(cx + 3, cy + 10, cx + 2, cy + 5);
    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);

    for (var i = 0; i < 5; i++) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(i * 72 * 3.1415926 / 180);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, -6.5), width: 9, height: 12),
        petalPaint,
      );
      canvas.restore();
    }

    canvas.drawCircle(Offset(cx, cy), 4.2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Prefer Figma blue gradient; fall back to tinted gradient from [color].
    final isDefaultBlue =
        color == const Color(0xFF4D82C4) || color == const Color(0xFF4F9EFF);

    final gradient = isDefaultBlue
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F9EFF), Color(0xFF2F6FEA)],
          )
        : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(color, Colors.white, 0.25)!,
              color,
            ],
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B60D9).withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Toy press feedback + navigation wrapper for [GameCard].
class PressableGameCard extends StatefulWidget {
  const PressableGameCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.titleColor,
    this.placeholderEmoji,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color titleColor;
  final String? placeholderEmoji;
  final VoidCallback onTap;

  @override
  State<PressableGameCard> createState() => _PressableGameCardState();
}

class _PressableGameCardState extends State<PressableGameCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : 1,
        child: GameCard(
          image: widget.image,
          title: widget.title,
          subtitle: widget.subtitle,
          badge: widget.badge,
          badgeColor: widget.badgeColor,
          titleColor: widget.titleColor,
          placeholderEmoji: widget.placeholderEmoji,
        ),
      ),
    );
  }
}
