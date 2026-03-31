import 'package:flutter/material.dart';

final class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Manrope';

  static final TextTheme englishLike = TextTheme(
    displayLarge: _style(size: 57, height: 64, weight: FontWeight.w400),
    displayMedium: _style(size: 45, height: 52, weight: FontWeight.w400),
    displaySmall: _style(size: 36, height: 44, weight: FontWeight.w400),
    headlineLarge: _style(size: 32, height: 40, weight: FontWeight.w400),
    headlineMedium: _style(size: 28, height: 36, weight: FontWeight.w400),
    headlineSmall: _style(size: 24, height: 32, weight: FontWeight.w400),
    titleLarge: _style(size: 22, height: 28, weight: FontWeight.w400),
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
      weight: FontWeight.w500,
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
