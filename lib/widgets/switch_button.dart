import 'package:flutter/material.dart';

import 'clay_surface.dart';

/// Glossy green clay "Switch ›" button for changing age world.
class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key, required this.onPressed, this.height = 44});

  final VoidCallback onPressed;
  final double height;

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Switch age world',
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: Duration(milliseconds: _pressed ? 100 : 380),
          curve: _pressed ? Curves.easeOut : Curves.elasticOut,
          scale: _pressed ? 0.94 : 1,
          child: SizedBox(
            height: widget.height,
            child: ClaySurface(
              color: const Color(0xFF3FC51F),
              radius: widget.height / 2,
              depth: 0.45,
              pressed: _pressed,
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Color(0x55136B00),
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
