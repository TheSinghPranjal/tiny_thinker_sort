import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/game_definition.dart';
import '../../theme/sortjoy_theme.dart';

/// Smiling washing machine (dirty clothes) or cupboard (clean clothes).
class LaundryDropZone extends StatefulWidget {
  const LaundryDropZone({
    super.key,
    required this.category,
    required this.isWashingMachine,
    required this.glow,
    required this.wiggle,
    required this.count,
    this.reaction,
  });

  final SortCategory category;
  final bool isWashingMachine;
  final bool glow;
  final bool wiggle;
  final int count;

  /// `happy`, `confused`, or null.
  final String? reaction;

  @override
  State<LaundryDropZone> createState() => _LaundryDropZoneState();
}

class _LaundryDropZoneState extends State<LaundryDropZone>
    with TickerProviderStateMixin {
  late final AnimationController _idle;
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scheduleBlink();
  }

  void _scheduleBlink() {
    Future.delayed(Duration(milliseconds: 2000 + Random().nextInt(3000)), () {
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
        final bounce = sin(_idle.value * pi) * 3;
        final wiggle = widget.wiggle ? sin(_idle.value * pi * 7) * 4 : 0.0;
        final eyeScale = _blink.value > 0.5 ? 0.15 : 1.0;
        final happy = widget.reaction == 'happy';

        return Transform.translate(
          offset: Offset(wiggle, -bounce - (happy ? 4 : 0)),
          child: widget.isWashingMachine
              ? _WashingMachineCard(
                  glow: widget.glow || happy,
                  count: widget.count,
                  eyeScale: eyeScale,
                  washSpin: happy ? _idle.value : _idle.value * 0.35,
                  label: widget.category.label,
                )
              : _CupboardCard(
                  glow: widget.glow || happy,
                  count: widget.count,
                  eyeScale: eyeScale,
                  doorOpen: happy ? 0.55 + sin(_idle.value * pi) * 0.1 : 0.12,
                  label: widget.category.label,
                ),
        );
      },
    );
  }
}

class _WashingMachineCard extends StatelessWidget {
  const _WashingMachineCard({
    required this.glow,
    required this.count,
    required this.eyeScale,
    required this.washSpin,
    required this.label,
  });

  final bool glow;
  final int count;
  final double eyeScale;
  final double washSpin;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF29B6F6).withValues(alpha: glow ? 0.45 : 0.2),
            blurRadius: glow ? 22 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Color(0xFF4FC3F7), Color(0xFF0288D1)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: glow ? SortJoyColors.glow : Colors.white,
            width: glow ? 4 : 2.5,
          ),
        ),
        child: Stack(
          children: [
            // Control panel buttons
            Positioned(
              top: 10,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Dot(color: SortJoyColors.coral),
                  _Dot(color: SortJoyColors.lemon),
                  _Dot(color: SortJoyColors.mint),
                ],
              ),
            ),
            // Door / window
            Align(
              alignment: const Alignment(0, -0.05),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF81D4FA).withValues(alpha: 0.85),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: washSpin * pi * 2,
                        child: CustomPaint(
                          size: const Size(72, 72),
                          painter: _BubbleSwirlPainter(),
                        ),
                      ),
                      Text(
                        glow ? '✨' : '🫧',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Face
            Positioned(
              top: 48,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scaleY: eyeScale,
                    child: const _Eye(),
                  ),
                  const SizedBox(width: 28),
                  Transform.scale(
                    scaleY: eyeScale,
                    child: const _Eye(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 22,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: SortJoyColors.ink.withValues(alpha: 0.55),
                        width: 2.5,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 70,
              child: Container(
                width: 10,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFAB91),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 70,
              child: Container(
                width: 10,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFAB91),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 8,
              child: Column(
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '×$count',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupboardCard extends StatelessWidget {
  const _CupboardCard({
    required this.glow,
    required this.count,
    required this.eyeScale,
    required this.doorOpen,
    required this.label,
  });

  final bool glow;
  final int count;
  final double eyeScale;
  final double doorOpen;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB74D).withValues(alpha: glow ? 0.45 : 0.22),
            blurRadius: glow ? 22 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D), Color(0xFFF57C00)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: glow ? SortJoyColors.glow : Colors.white,
            width: glow ? 4 : 2.5,
          ),
        ),
        child: Stack(
          children: [
            // Shelf sparkles
            Positioned(
              top: 12,
              left: 16,
              child: Text(
                glow ? '⭐' : '✨',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Positioned(
              top: 12,
              right: 16,
              child: Text(
                glow ? '💖' : '🌿',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Doors
            Positioned.fill(
              top: 36,
              bottom: 40,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  Expanded(
                    child: Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-doorOpen),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCC80),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white70, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.circle, size: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(doorOpen),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCC80),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white70, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.circle, size: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Eyes on top of cupboard
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(scaleY: eyeScale, child: const _Eye()),
                  const SizedBox(width: 36),
                  Transform.scale(scaleY: eyeScale, child: const _Eye()),
                ],
              ),
            ),
            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 22,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: SortJoyColors.ink.withValues(alpha: 0.55),
                        width: 2.5,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 8,
              child: Column(
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '×$count',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 12,
      decoration: const BoxDecoration(
        color: SortJoyColors.ink,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
        ],
      ),
    );
  }
}

class _BubbleSwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(c, 8.0 + i * 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
