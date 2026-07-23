import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_definition.dart';
import '../../theme/sortjoy_theme.dart';

/// Adorable toddler drop target for Healthy Hero / Junk Food Kid.
class ToddlerDropZone extends StatefulWidget {
  const ToddlerDropZone({
    super.key,
    required this.category,
    required this.glow,
    required this.wiggle,
    required this.count,
    required this.isHealthyHero,
    this.reaction,
  });

  final SortCategory category;
  final bool glow;
  final bool wiggle;
  final int count;
  final bool isHealthyHero;

  /// `happy`, `confused`, or null for idle.
  final String? reaction;

  @override
  State<ToddlerDropZone> createState() => _ToddlerDropZoneState();
}

class _ToddlerDropZoneState extends State<ToddlerDropZone>
    with TickerProviderStateMixin {
  late final AnimationController _idle;
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scheduleBlink();
  }

  void _scheduleBlink() {
    Future.delayed(Duration(milliseconds: 2200 + Random().nextInt(2800)), () {
      if (!mounted) return;
      _blink.forward(from: 0).then((_) {
        if (mounted) _scheduleBlink();
      });
    });
  }

  @override
  void dispose() {
    _idle.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idle, _blink]),
      builder: (context, _) {
        final breathe = sin(_idle.value * pi) * 3;
        final wave = sin(_idle.value * pi * 2) * 6;
        final wiggle = widget.wiggle ? sin(_idle.value * pi * 6) * 4 : 0.0;
        final blinkScale = _blink.value > 0.5 ? 0.15 : 1.0;

        return Transform.translate(
          offset: Offset(wiggle, -breathe),
          child: _buildCard(blinkScale, wave),
        );
      },
    );
  }

  Widget _buildCard(double blinkScale, double wave) {
    final color = Color(widget.category.color);
    final reaction = widget.reaction;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 148,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.95),
              color.withValues(alpha: widget.isHealthyHero ? 0.72 : 0.78),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: widget.glow ? SortJoyColors.glow : Colors.white.withValues(alpha: 0.85),
            width: widget.glow ? 4 : 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: widget.glow ? 0.55 : 0.28),
              blurRadius: widget.glow ? 28 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 8,
              child: Text(
                widget.category.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            Positioned(
              bottom: 36,
              child: _ToddlerFace(
                blinkScale: blinkScale,
                waveAngle: wave / 60,
                isHealthyHero: widget.isHealthyHero,
                reaction: reaction,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                children: [
                  Text(
                    widget.category.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                    ),
                  ),
                  Text(
                    '${widget.count}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isHealthyHero)
              Positioned(
                left: 12,
                bottom: 52,
                child: Text('🍎', style: TextStyle(fontSize: 16 + sin(_idle.value * pi) * 2)),
              ),
            if (reaction == 'confused')
              Positioned(
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Not this one!',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: SortJoyColors.inkSoft,
                    ),
                  ),
                ),
              ),
          ],
        ),
    );
  }
}

class _ToddlerFace extends StatelessWidget {
  const _ToddlerFace({
    required this.blinkScale,
    required this.waveAngle,
    required this.isHealthyHero,
    this.reaction,
  });

  final double blinkScale;
  final double waveAngle;
  final bool isHealthyHero;
  final String? reaction;

  @override
  Widget build(BuildContext context) {
    final surprised = reaction == 'confused' && isHealthyHero;

    return SizedBox(
      width: 72,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body / clothes
          Positioned(
            bottom: 0,
            child: Container(
              width: 52,
              height: 28,
              decoration: BoxDecoration(
                color: isHealthyHero
                    ? const Color(0xFFA5D6A7)
                    : const Color(0xFFFFCC80),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          // Head
          Positioned(
            top: 8,
            child: Container(
              width: 54,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cheeks
                  Positioned(
                    left: 6,
                    bottom: 14,
                    child: Container(
                      width: 10,
                      height: 7,
                      decoration: BoxDecoration(
                        color: SortJoyColors.coral.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 14,
                    child: Container(
                      width: 10,
                      height: 7,
                      decoration: BoxDecoration(
                        color: SortJoyColors.coral.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // Eyes
                  Positioned(
                    top: 16,
                    left: 12,
                    child: _Eye(blinkScale: blinkScale, sparkle: reaction == 'happy'),
                  ),
                  Positioned(
                    top: 16,
                    right: 12,
                    child: _Eye(blinkScale: blinkScale, sparkle: reaction == 'happy'),
                  ),
                  // Mouth
                  Positioned(
                    bottom: 12,
                    child: surprised
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: SortJoyColors.inkSoft.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                          )
                        : CustomPaint(
                            size: const Size(22, 12),
                            painter: _SmilePainter(
                              confused: reaction == 'confused',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Waving hand
          Positioned(
            right: 0,
            top: 28,
            child: Transform.rotate(
              angle: waveAngle,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.blinkScale, this.sparkle = false});

  final double blinkScale;
  final bool sparkle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14 * blinkScale.clamp(0.15, 1.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 14,
            height: 14 * blinkScale.clamp(0.15, 1.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          if (blinkScale > 0.4)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: SortJoyColors.inkSoft,
                shape: BoxShape.circle,
              ),
            ),
          if (sparkle && blinkScale > 0.4)
            Positioned(
              top: 1,
              right: 1,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SmilePainter extends CustomPainter {
  _SmilePainter({this.confused = false});

  final bool confused;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SortJoyColors.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    if (confused) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 + 2),
          width: size.width * 0.7,
          height: size.height * 0.5,
        ),
        pi * 0.15,
        pi * 0.7,
        false,
        paint,
      );
    } else {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
        0.15,
        pi - 0.3,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SmilePainter oldDelegate) =>
      oldDelegate.confused != confused;
}
