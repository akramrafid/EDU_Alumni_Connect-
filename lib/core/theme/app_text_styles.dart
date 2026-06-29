import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme getTextTheme(ColorScheme colorScheme) {
    // Start with a generic baseline TextTheme
    final baseTextTheme = Typography.material2021().black;

    // Apply Playfair Display for display and headlines
    final headlineTheme = GoogleFonts.playfairDisplayTextTheme(baseTextTheme).copyWith(
      displayLarge: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.displayLarge),
      displayMedium: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.displayMedium),
      displaySmall: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.displaySmall),
      headlineLarge: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.headlineLarge),
      headlineMedium: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.headlineMedium),
      headlineSmall: GoogleFonts.playfairDisplay(textStyle: baseTextTheme.headlineSmall),
    );

    // Apply Inter for title, body, and label styles
    final bodyTheme = GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      titleLarge: GoogleFonts.inter(textStyle: baseTextTheme.titleLarge),
      titleMedium: GoogleFonts.inter(textStyle: baseTextTheme.titleMedium),
      titleSmall: GoogleFonts.inter(textStyle: baseTextTheme.titleSmall),
      bodyLarge: GoogleFonts.inter(textStyle: baseTextTheme.bodyLarge),
      bodyMedium: GoogleFonts.inter(textStyle: baseTextTheme.bodyMedium),
      bodySmall: GoogleFonts.inter(textStyle: baseTextTheme.bodySmall),
      labelLarge: GoogleFonts.inter(textStyle: baseTextTheme.labelLarge),
      labelMedium: GoogleFonts.inter(textStyle: baseTextTheme.labelMedium),
      labelSmall: GoogleFonts.inter(textStyle: baseTextTheme.labelSmall),
    );

    // Merge them into a single coherent text theme
    return headlineTheme.copyWith(
      titleLarge: bodyTheme.titleLarge,
      titleMedium: bodyTheme.titleMedium,
      titleSmall: bodyTheme.titleSmall,
      bodyLarge: bodyTheme.bodyLarge,
      bodyMedium: bodyTheme.bodyMedium,
      bodySmall: bodyTheme.bodySmall,
      labelLarge: bodyTheme.labelLarge,
      labelMedium: bodyTheme.labelMedium,
      labelSmall: bodyTheme.labelSmall,
    ).apply(
      displayColor: colorScheme.onBackground,
      bodyColor: colorScheme.onBackground,
    );
  }

  // JetBrains Mono style for code snippets and IDs
  static TextStyle monoStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
