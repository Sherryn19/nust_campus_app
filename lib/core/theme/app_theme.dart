// ============================================================
//  core/theme/app_theme.dart
//  SHARED THEME — do not modify without team agreement.
//  All feature modules import from here for consistency.
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────
  static const Color background    = Color(0xFF0A0A0F);
  static const Color surface       = Color(0xFF13131A);
  static const Color surfaceHigh   = Color(0xFF1E1E2A);
  static const Color accent        = Color(0xFF6C63FF);
  static const Color accentGlow    = Color(0x446C63FF);
  static const Color accentAlt     = Color(0xFF00E5A0);
  static const Color textPrimary   = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color cardBorder    = Color(0xFF2A2A3A);
  static const Color tagBg         = Color(0xFF1A1A2E);
  static const Color danger        = Color(0xFFFF6B6B);
  static const Color warning       = Color(0xFFFFD166);

  // ── Typography ───────────────────────────────────────────
  static TextStyle heading(double size) => GoogleFonts.syne(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.spaceGrotesk(
        fontSize: size,
        color: color ?? textPrimary,
      );

  static TextStyle label(double size, {Color? color, FontWeight? weight}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        color: color ?? textSecondary,
        fontWeight: weight ?? FontWeight.w500,
      );

  // ── ThemeData ────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: accentAlt,
          surface: surface,
        ),
        textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          titleTextStyle: GoogleFonts.syne(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: accent,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          hintStyle: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),
        ),
      );
}
