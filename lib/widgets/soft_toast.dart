import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/sortjoy_theme.dart';

class SoftToast extends StatelessWidget {
  const SoftToast({
    super.key,
    required this.message,
    this.compact = false,
    this.color = SortJoyColors.mint,
  });

  final String message;
  final bool compact;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 22,
            vertical: compact ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: compact ? 18 : 22,
            ),
          ),
        ),
      ),
    );
  }
}

class CelebrationBurst extends StatefulWidget {
  const CelebrationBurst({
    super.key,
    required this.seed,
    this.continuous = false,
  });

  final int seed;
  final bool continuous;

  @override
  State<CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = Random(widget.seed);
    _particles = List.generate(widget.continuous ? 28 : 18, (i) {
      return _Particle(
        dx: rng.nextDouble(),
        dy: rng.nextDouble(),
        size: 6 + rng.nextDouble() * 10,
        color: [
          SortJoyColors.lemon,
          SortJoyColors.berry,
          SortJoyColors.mint,
          SortJoyColors.peach,
          SortJoyColors.lavender,
          Colors.white,
        ][rng.nextInt(6)],
        spin: rng.nextDouble() * pi,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.continuous ? 2800 : 900),
    );
    if (widget.continuous) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _BurstPainter(
            progress: _controller.value,
            particles: _particles,
            continuous: widget.continuous,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  const _Particle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.color,
    required this.spin,
  });

  final double dx;
  final double dy;
  final double size;
  final Color color;
  final double spin;
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({
    required this.progress,
    required this.particles,
    required this.continuous,
  });

  final double progress;
  final List<_Particle> particles;
  final bool continuous;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = continuous ? ((progress + p.dx) % 1.0) : progress;
      final opacity = continuous ? 0.75 : (1 - t).clamp(0.0, 1.0);
      final x = p.dx * size.width;
      final y = continuous
          ? size.height * (1 - t)
          : size.height * 0.45 + (p.dy - 0.5) * 160 * t - 80 * t;
      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin + t * 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(4),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
