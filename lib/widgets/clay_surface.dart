import 'package:flutter/material.dart';

/// Claymorphism surface — puffy pastel fill, tinted drop shadow, soft
/// top-left light and inner shading that make it read like soft clay.
///
/// Flutter has no inset shadows, so the inner light/shade are painted as
/// gradient overlays clipped to the rounded shape.
class ClaySurface extends StatelessWidget {
  const ClaySurface({
    super.key,
    required this.color,
    required this.child,
    this.radius = 28,
    this.padding = EdgeInsets.zero,
    this.pressed = false,
    this.depth = 1.0,
  });

  /// Base clay tint. Highlights and shadows are derived from it.
  final Color color;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Squished state — shadow tightens so the surface looks pushed in.
  final bool pressed;

  /// Scales shadow distance (smaller for chips and pills).
  final double depth;

  static Color _shade(Color c, double amount) =>
      Color.lerp(c, const Color(0xFF3B2A5C), amount)!;

  static Color _tint(Color c, double amount) =>
      Color.lerp(c, Colors.white, amount)!;

  @override
  Widget build(BuildContext context) {
    final lift = (pressed ? 0.35 : 1.0) * depth;
    final shadow = _shade(color, 0.45);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_tint(color, 0.45), color, _shade(color, 0.06)],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          // Tinted cast shadow — the clay sits on the page.
          BoxShadow(
            color: shadow.withValues(alpha: 0.32),
            blurRadius: 22 * lift,
            spreadRadius: -2,
            offset: Offset(6 * lift, 12 * lift),
          ),
          // Tight contact shadow.
          BoxShadow(
            color: shadow.withValues(alpha: 0.18),
            blurRadius: 4 * lift,
            offset: Offset(0, 2 * lift),
          ),
          // Top-left light bounce.
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.55),
            blurRadius: 12 * lift,
            offset: Offset(-4 * lift, -4 * lift),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          // Tight parents (grid cells, tiles) stretch the content to fill.
          fit: StackFit.passthrough,
          children: [
            // Inner highlight — puffy top-left bulge.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.7, -0.8),
                      radius: 1.1,
                      colors: [
                        Colors.white.withValues(alpha: 0.6),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.6],
                    ),
                  ),
                ),
              ),
            ),
            // Inner shade — bottom-right rim curving away from the light.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.9, 1.1),
                      radius: 1.3,
                      colors: [
                        shadow.withValues(alpha: 0.0),
                        shadow.withValues(alpha: 0.0),
                        shadow.withValues(alpha: 0.16),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

/// Recessed clay well — pressed-in pocket for art or values.
class ClayWell extends StatelessWidget {
  const ClayWell({
    super.key,
    required this.child,
    this.radius = 20,
    this.color = Colors.white,
  });

  final Widget child;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final inner = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: inner,
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            // Inset shadow along the top edge.
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.16),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.18),
                    ],
                    stops: const [0.0, 0.14, 0.82, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
