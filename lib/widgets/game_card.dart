import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'clay_surface.dart';

/// Claymorphism game card — pastel clay body tinted per game, recessed art
/// well, clay badge and a puffy play button.
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
    this.playable = true,
    this.pressed = false,
  });

  final String image;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color titleColor;
  final String? placeholderEmoji;

  /// Implemented games show a play button; others a sleepy flower sticker.
  final bool playable;
  final bool pressed;

  static const _subtitleColor = Color(0xFF4A5560);

  @override
  Widget build(BuildContext context) {
    final clay = Color.lerp(badgeColor, Colors.white, 0.8)!;

    return ClaySurface(
      color: clay,
      radius: 30,
      pressed: pressed,
      padding: const EdgeInsets.fromLTRB(9, 9, 9, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClayWell(
                    radius: 22,
                    color: Color.lerp(badgeColor, Colors.white, 0.85)!,
                    child: _CardImage(
                      image: image,
                      tint: badgeColor,
                      placeholderEmoji: placeholderEmoji,
                      dimmed: !playable,
                    ),
                  ),
                ),
                if (badge.isNotEmpty)
                  Positioned(
                    top: 9,
                    right: 9,
                    child: _Badge(text: badge, color: badgeColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          // Title gets the full width so two-word names never truncate;
          // the play button sits beside the subtitle.
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.baloo2(
                fontSize: 16.5,
                height: 1.05,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.baloo2(
                      fontSize: 12.5,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: _subtitleColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              playable
                  ? _PlayButton(color: badgeColor, pressed: pressed)
                  : const Padding(
                      padding: EdgeInsets.all(8),
                      child: _DecorIcon(),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.image,
    required this.tint,
    this.placeholderEmoji,
    this.dimmed = false,
  });

  final String image;
  final Color tint;
  final String? placeholderEmoji;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final art = Image.asset(
      image,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Until per-game art lands in assets/games/: a tinted mini scene —
        // soft sky, rolling grass and the game's emoji as the hero.
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(tint, Colors.white, 0.55)!,
                Color.lerp(tint, Colors.white, 0.8)!,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -30,
                right: -30,
                bottom: -40,
                height: 80,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CD65A).withValues(alpha: 0.9),
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(200, 80),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 12,
                top: 14,
                child: Text('✨', style: TextStyle(fontSize: 14)),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    placeholderEmoji ?? '🎮',
                    style: TextStyle(
                      fontSize: 64,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return dimmed ? Opacity(opacity: 0.6, child: art) : art;
  }
}

/// Puffy clay play button — bottom-right of the text block.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.color, required this.pressed});

  final Color color;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: ClaySurface(
        color: color,
        radius: 21,
        depth: 0.5,
        pressed: pressed,
        child: const Center(
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

/// Decorative flower sticker — shown on games that are coming soon.
class _DecorIcon extends StatelessWidget {
  const _DecorIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _FlowerPainter()),
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

/// Clay pill badge ("3 left", "Soon").
class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClaySurface(
      color: color,
      radius: 999,
      depth: 0.35,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      child: Text(
        text,
        style: GoogleFonts.baloo2(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
          height: 1.2,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clay squish press feedback + navigation wrapper for [GameCard].
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
    this.playable = true,
    required this.onTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final Color titleColor;
  final String? placeholderEmoji;
  final bool playable;
  final VoidCallback onTap;

  @override
  State<PressableGameCard> createState() => _PressableGameCardState();
}

class _PressableGameCardState extends State<PressableGameCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: _pressed ? 120 : 420),
          curve: _pressed ? Curves.easeOut : Curves.elasticOut,
          scale: _pressed ? 0.95 : 1,
          child: GameCard(
            image: widget.image,
            title: widget.title,
            subtitle: widget.subtitle,
            badge: widget.badge,
            badgeColor: widget.badgeColor,
            titleColor: widget.titleColor,
            placeholderEmoji: widget.placeholderEmoji,
            playable: widget.playable,
            pressed: _pressed,
          ),
        ),
      ),
    );
  }
}
