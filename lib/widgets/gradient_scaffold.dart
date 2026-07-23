import 'package:flutter/material.dart';

import '../theme/sortjoy_theme.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
    this.colors = const [SortJoyColors.skyTop, SortJoyColors.skyBottom],
  });

  final Widget child;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: child,
      ),
    );
  }
}
