import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color mulledWine = Color(0xFF670627);
  static const Color matcha = Color(0xFFBAD797);

  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFFDFAF7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onAccentLight = Color(0xFF1C2B15);
  static const Color textPrimaryLight = Color(0xFF1A0A0E);
  static const Color textSecondaryLight = Color(0xFF6B4A52);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF1A0A0E);
  static const Color surfaceDark = Color(0xFF2C1018);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onAccentDark = Color(0xFF1C2B15);
  static const Color textPrimaryDark = Color(0xFFF5EEF0);
  static const Color textSecondaryDark = Color(0xFFA88A90);

  // Shared Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);

  static ColorScheme get lightScheme {
    return ColorScheme.fromSeed(
      seedColor: mulledWine,
      brightness: Brightness.light,
    ).copyWith(
      primary: mulledWine,
      onPrimary: onPrimaryLight,
      secondary: matcha,
      onSecondary: onAccentLight,
      background: backgroundLight,
      onBackground: textPrimaryLight,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      error: error,
      onError: onError,
      surfaceVariant: const Color(0xFFF2ECE8),
      onSurfaceVariant: textSecondaryLight,
    );
  }

  static ColorScheme get darkScheme {
    return ColorScheme.fromSeed(
      seedColor: mulledWine,
      brightness: Brightness.dark,
    ).copyWith(
      primary: mulledWine,
      onPrimary: onPrimaryDark,
      secondary: matcha,
      onSecondary: onAccentDark,
      background: backgroundDark,
      onBackground: textPrimaryDark,
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      error: error,
      onError: onError,
      surfaceVariant: const Color(0xFF381A21),
      onSurfaceVariant: textSecondaryDark,
    );
  }
}
