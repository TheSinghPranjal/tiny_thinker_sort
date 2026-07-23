import 'package:flutter/material.dart';

import 'sortjoy_background.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const SortJoyBackground(),
          child,
        ],
      ),
    );
  }
}
