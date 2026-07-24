import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SortJoy visual language — bright, rounded, TinyThink-like polish.
abstract final class SortJoyColors {
  static const skyTop = Color(0xFF7ED6FF);
  static const skyBottom = Color(0xFFE8F9FF);
  static const grass = Color(0xFF7BC67E);
  static const grassDark = Color(0xFF5AA85E);
  static const coral = Color(0xFFFF6B6B);
  static const peach = Color(0xFFFFB347);
  static const lemon = Color(0xFFFFE66D);
  static const mint = Color(0xFF4ECDC4);
  static const lavender = Color(0xFFA78BFA);
  static const berry = Color(0xFFFF8FAB);
  static const cream = Color(0xFFFFFBF5);
  static const ink = Color(0xFF2D3436);
  static const inkSoft = Color(0xFF636E72);
  static const card = Color(0xFFFFFFFF);
  static const fruitBasket = Color(0xFFFF8A65);
  static const vegBasket = Color(0xFF81C784);
  static const coin = Color(0xFFFFD54F);
  static const star = Color(0xFFFFB300);
  static const glow = Color(0xFFFFF59D);
}

abstract final class SortJoyTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SortJoyColors.mint,
        primary: SortJoyColors.mint,
        secondary: SortJoyColors.peach,
        tertiary: SortJoyColors.lavender,
        surface: SortJoyColors.cream,
      ),
      scaffoldBackgroundColor: SortJoyColors.skyBottom,
    );

    return base.copyWith(
      textTheme: GoogleFonts.baloo2TextTheme(base.textTheme).apply(
        bodyColor: SortJoyColors.ink,
        displayColor: SortJoyColors.ink,
      ).copyWith(
        displayLarge: GoogleFonts.baloo2(fontWeight: FontWeight.w800),
        headlineMedium: GoogleFonts.baloo2(fontWeight: FontWeight.w800),
        titleLarge: GoogleFonts.baloo2(fontWeight: FontWeight.w800),
        labelLarge: GoogleFonts.baloo2(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: SortJoyColors.ink,
      ),
      cardTheme: CardThemeData(
        color: SortJoyColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SortJoyColors.mint,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
