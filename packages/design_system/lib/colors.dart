import 'package:flutter/material.dart';

final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF003D9B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDCE8FF);
  static const Color onPrimaryContainer = Color(0xFF001A43);
  static const Color primaryFixed = Color(0xFF0052CC);
  static const Color onPrimaryFixed = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF535A70);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE9EEF9);
  static const Color onSecondaryContainer = Color(0xFF1F2535);

  static const Color tertiary = Color(0xFF006C49);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD8F8EA);
  static const Color onTertiaryContainer = Color(0xFF003826);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color surface = Color(0xFFF7F9FB);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color surfaceDim = Color(0xFFDEE3E8);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color surfaceContainer = Color(0xFFECEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE0E3E5);
  static const Color surfaceContainerHighest = Color(0xFFD7DBDF);
  static const Color onSurfaceVariant = Color(0xFF434654);

  static const Color outline = Color(0xFF94A3B8);
  static const Color outlineVariant = Color(0xFFECEEF0);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF191C1E);
  static const Color onInverseSurface = Color(0xFFF7F9FB);
  static const Color inversePrimary = Color(0xFF80AFFF);
  static const Color surfaceTint = primary;

  static const Color success = Color(0xFF006C49);
  static const Color successContainer = Color(0xFFD8F8EA);
  static const Color successAccent = Color(0xFF00714D);
  static const Color warning = Color(0xFFBA1A1A);
  static const Color warningContainer = Color(0xFFFFDAD6);
  static const Color info = Color(0xFF2563EB);
  static const Color infoContainer = Color(0xFFDCE8FF);

  static const Color primaryDark = Color(0xFF95CCFF);
  static const Color onPrimaryDark = Color(0xFF003353);
  static const Color primaryContainerDark = Color(0xFF004A76);
  static const Color onPrimaryContainerDark = Color(0xFFCDE5FF);
  static const Color primaryFixedDark = Color(0xFF80AFFF);
  static const Color onPrimaryFixedDark = Color(0xFF001D33);

  static const Color secondaryDark = Color(0xFFBEC6DD);
  static const Color onSecondaryDark = Color(0xFF262C3E);
  static const Color secondaryContainerDark = Color(0xFF3B4257);
  static const Color onSecondaryContainerDark = Color(0xFFE9EEF9);

  static const Color tertiaryDark = Color(0xFF84DA8F);
  static const Color onTertiaryDark = Color(0xFF003921);
  static const Color tertiaryContainerDark = Color(0xFF005236);
  static const Color onTertiaryContainerDark = Color(0xFFD8F8EA);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color surfaceDark = Color(0xFF111416);
  static const Color onSurfaceDark = Color(0xFFE1E3E6);
  static const Color surfaceDimDark = Color(0xFF111416);
  static const Color surfaceBrightDark = Color(0xFF37393C);
  static const Color surfaceContainerLowestDark = Color(0xFF0C0F11);
  static const Color surfaceContainerLowDark = Color(0xFF191C1E);
  static const Color surfaceContainerDark = Color(0xFF1D2022);
  static const Color surfaceContainerHighDark = Color(0xFF272A2D);
  static const Color surfaceContainerHighestDark = Color(0xFF323538);
  static const Color onSurfaceVariantDark = Color(0xFFC0C8CD);

  static const Color outlineDark = Color(0xFF899297);
  static const Color outlineVariantDark = Color(0xFF40484C);
  static const Color shadowDark = Color(0xFF000000);
  static const Color scrimDark = Color(0xFF000000);
  static const Color inverseSurfaceDark = Color(0xFFE1E3E6);
  static const Color onInverseSurfaceDark = Color(0xFF2E3133);
  static const Color inversePrimaryDark = Color(0xFF00639A);
  static const Color surfaceTintDark = primaryDark;

  static const Color successDark = Color(0xFF84DA8F);
  static const Color successContainerDark = Color(0xFF005236);
  static const Color successAccentDark = Color(0xFF9AE0BC);
  static const Color warningDark = Color(0xFFFFB4AB);
  static const Color warningContainerDark = Color(0xFF93000A);
  static const Color infoDark = Color(0xFFA5C8FF);
  static const Color infoContainerDark = Color(0xFF004379);

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: inversePrimary,
    surfaceTint: surfaceTint,
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    onPrimary: onPrimaryDark,
    primaryContainer: primaryContainerDark,
    onPrimaryContainer: onPrimaryContainerDark,
    secondary: secondaryDark,
    onSecondary: onSecondaryDark,
    secondaryContainer: secondaryContainerDark,
    onSecondaryContainer: onSecondaryContainerDark,
    tertiary: tertiaryDark,
    onTertiary: onTertiaryDark,
    tertiaryContainer: tertiaryContainerDark,
    onTertiaryContainer: onTertiaryContainerDark,
    error: errorDark,
    onError: onErrorDark,
    errorContainer: errorContainerDark,
    onErrorContainer: onErrorContainerDark,
    surface: surfaceDark,
    onSurface: onSurfaceDark,
    onSurfaceVariant: onSurfaceVariantDark,
    outline: outlineDark,
    outlineVariant: outlineVariantDark,
    shadow: shadowDark,
    scrim: scrimDark,
    inverseSurface: inverseSurfaceDark,
    onInverseSurface: onInverseSurfaceDark,
    inversePrimary: inversePrimaryDark,
    surfaceTint: surfaceTintDark,
  );
}
