import 'package:flutter/material.dart';

class AppTheme {
  // Brand Palette - Modern Clean Light Luxury Travel (Matching UI Reference)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F7FF); // Soft Ice Blue tint
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Primary Action Button (Deep Luxury Navy from Reference)
  static const Color primary = Color(0xFF0F172A);
  // Brand Ocean Blue (Accents, active icons, badges, logo swoosh)
  static const Color primaryLight = Color(0xFF0284C7);
  static const Color primaryDark = Color(0xFF0369A1);
  static const Color brandBlue = Color(0xFF0284C7);
  static const Color brandBlueSoft = Color(0xFFE0F2FE);

  static const Color accent = Color(0xFF2563EB); // Royal Blue Accent
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color danger = Color(0xFFEF4444); // Crimson
  static const Color error = Color(0xFFEF4444);

  // Typography
  static const Color textPrimary = Color(0xFF0F172A); // Sharp Slate Navy
  static const Color textSecondary = Color(0xFF475569); // Slate Gray
  static const Color textMuted = Color(0xFF94A3B8); // Muted Slate

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.05),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get floatShadow => [
        BoxShadow(
          color: const Color(0xFF0284C7).withValues(alpha: 0.18),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF1E3A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0369A1), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softBlueGradient = LinearGradient(
    colors: [Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient luxuryGoldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme => lightTheme;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryLight,
        surface: surface,
        error: danger,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: cardBorder,
        thickness: 1,
      ),
    );
  }
}
