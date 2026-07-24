import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium toy-like game card — drop in artwork via [image] path.
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

  static const _cardBg = Color(0xFFFEFDFA);
  static const _subtitle = Color(0xFF634E40);
  static const _radius = 36.0;
  static const _borderWidth = 6.0;

  @override
  Widget build(BuildContext context) {
    final innerRadius = _radius - _borderWidth;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: Colors.white, width: _borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28,
            spreadRadius: -2,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 58,
                  child: _CardImage(
                    image: image,
                    placeholderEmoji: placeholderEmoji,
                  ),
                ),
                Expanded(
                  flex: 42,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.baloo2(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            height: 1.12,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.baloo2(
                                      fontSize: 13,
                                      height: 1.25,
                                      color: _subtitle,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 2),
                                child: _DecorIcon(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (badge.isNotEmpty)
              Positioned(
                top: 10,
                right: 10,
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
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        alignment: Alignment.center,
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
              style: const TextStyle(fontSize: 52),
            ),
          );
        },
      ),
    );
  }
}

/// Small decorative flower sticker, bottom-right of the text block.
class _DecorIcon extends StatelessWidget {
  const _DecorIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const _FlowerFallback(),
    );
  }
}

class _FlowerFallback extends StatelessWidget {
  const _FlowerFallback();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(28, 28),
      painter: _FlowerPainter(),
    );
  }
}

class _FlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.48;
    final cy = size.height * 0.42;
    final petalPaint = Paint()..color = const Color(0xFFF06FA6);
    final centerPaint = Paint()..color = const Color(0xFFFFC94D);
    final leafPaint = Paint()..color = const Color(0xFF7CBF3A);

    // Leaves
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

    // Petals
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.baloo2(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
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
        scale: _pressed ? 0.96 : 1,
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
