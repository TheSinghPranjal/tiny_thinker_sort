import 'dart:math';

import 'package:flutter/material.dart';

/// Glossy white bubble containing a large food emoji for toddler drag targets.
class FoodBubbleChip extends StatelessWidget {
  const FoodBubbleChip({
    super.key,
    required this.size,
    required this.emoji,
    this.bobPhase = 0,
  });

  final double size;
  final String emoji;
  final double bobPhase;

  @override
  Widget build(BuildContext context) {
    final rotation = sin(bobPhase) * 0.06;
    final bob = sin(bobPhase * 1.4) * 4;

    return Transform.translate(
      offset: Offset(0, bob),
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: const Alignment(-0.35, -0.45),
              radius: 0.95,
              colors: [
                Colors.white,
                Colors.white.withValues(alpha: 0.96),
                const Color(0xFFE3F2FD).withValues(alpha: 0.5),
              ],
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.lightBlueAccent.withValues(alpha: 0.15),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: size * 0.12,
                left: size * 0.18,
                child: Container(
                  width: size * 0.22,
                  height: size * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Text(
                emoji,
                style: TextStyle(fontSize: size * 0.48),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
