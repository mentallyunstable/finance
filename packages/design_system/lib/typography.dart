import 'package:flutter/material.dart';

final class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Manrope';

  static final TextTheme englishLike = TextTheme(
    displayLarge: _style(size: 48, height: 54, weight: FontWeight.w800),
    displayMedium: _style(size: 40, height: 46, weight: FontWeight.w700),
    displaySmall: _style(size: 32, height: 38, weight: FontWeight.w600),
    headlineLarge: _style(size: 28, height: 34, weight: FontWeight.w800),
    headlineMedium: _style(size: 24, height: 30, weight: FontWeight.w700),
    headlineSmall: _style(size: 22, height: 26, weight: FontWeight.w600),
    titleLarge: _style(size: 22, height: 26, weight: FontWeight.w600),
    titleMedium: _style(
      size: 16,
      height: 24,
      weight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: _style(
      size: 14,
      height: 20,
      weight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: _style(size: 16, height: 24, weight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: _style(size: 14, height: 20, weight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: _style(size: 12, height: 16, weight: FontWeight.w400, letterSpacing: 0.4),
    labelLarge: _style(
      size: 14,
      height: 20,
      weight: FontWeight.w700,
      letterSpacing: 0.1,
    ),
    labelMedium: _style(
      size: 12,
      height: 16,
      weight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: _style(
      size: 11,
      height: 16,
      weight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  static TextTheme light(ColorScheme colorScheme) => englishLike.apply(
    displayColor: colorScheme.onSurface,
    bodyColor: colorScheme.onSurface,
    decorationColor: colorScheme.onSurface,
  );

  static TextTheme dark(ColorScheme colorScheme) => englishLike.apply(
    displayColor: colorScheme.onSurface,
    bodyColor: colorScheme.onSurface,
    decorationColor: colorScheme.onSurface,
  );

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
  }
}
