import 'package:flutter/material.dart';

final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00639A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFCDE5FF);
  static const Color onPrimaryContainer = Color(0xFF001D33);

  static const Color secondary = Color(0xFF4D616C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD0E6F2);
  static const Color onSecondaryContainer = Color(0xFF081E27);

  static const Color tertiary = Color(0xFF62597C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFE8DDFF);
  static const Color onTertiaryContainer = Color(0xFF1E1735);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color surface = Color(0xFFFAFCFF);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color surfaceDim = Color(0xFFD9DADD);
  static const Color surfaceBright = Color(0xFFFAFCFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F5F8);
  static const Color surfaceContainer = Color(0xFFEDEFF2);
  static const Color surfaceContainerHigh = Color(0xFFE7E9EC);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E6);
  static const Color onSurfaceVariant = Color(0xFF40484C);

  static const Color outline = Color(0xFF70787D);
  static const Color outlineVariant = Color(0xFFC0C8CD);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF2E3133);
  static const Color onInverseSurface = Color(0xFFEFF1F4);
  static const Color inversePrimary = Color(0xFF95CCFF);

  static const Color surfaceTint = primary;

  static const Color success = Color(0xFF146C2E);
  static const Color successContainer = Color(0xFFA0F7A9);
  static const Color warning = Color(0xFF7A5900);
  static const Color warningContainer = Color(0xFFFFDEA5);
  static const Color info = Color(0xFF005B9F);
  static const Color infoContainer = Color(0xFFD2E4FF);
}

final class AppDarkColors {
  AppDarkColors._();

  static const Color primary = Color(0xFF95CCFF);
  static const Color onPrimary = Color(0xFF003353);
  static const Color primaryContainer = Color(0xFF004A76);
  static const Color onPrimaryContainer = Color(0xFFCDE5FF);

  static const Color secondary = Color(0xFFB4CAD6);
  static const Color onSecondary = Color(0xFF1E333D);
  static const Color secondaryContainer = Color(0xFF354954);
  static const Color onSecondaryContainer = Color(0xFFD0E6F2);

  static const Color tertiary = Color(0xFFCCC1E9);
  static const Color onTertiary = Color(0xFF332C4B);
  static const Color tertiaryContainer = Color(0xFF4A4263);
  static const Color onTertiaryContainer = Color(0xFFE8DDFF);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color surface = Color(0xFF111416);
  static const Color onSurface = Color(0xFFE1E3E6);
  static const Color surfaceDim = Color(0xFF111416);
  static const Color surfaceBright = Color(0xFF37393C);
  static const Color surfaceContainerLowest = Color(0xFF0C0F11);
  static const Color surfaceContainerLow = Color(0xFF191C1E);
  static const Color surfaceContainer = Color(0xFF1D2022);
  static const Color surfaceContainerHigh = Color(0xFF272A2D);
  static const Color surfaceContainerHighest = Color(0xFF323538);
  static const Color onSurfaceVariant = Color(0xFFC0C8CD);

  static const Color outline = Color(0xFF899297);
  static const Color outlineVariant = Color(0xFF40484C);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFFE1E3E6);
  static const Color onInverseSurface = Color(0xFF2E3133);
  static const Color inversePrimary = Color(0xFF00639A);

  static const Color surfaceTint = primary;

  static const Color success = Color(0xFF84DA8F);
  static const Color successContainer = Color(0xFF005318);
  static const Color warning = Color(0xFFF1BE48);
  static const Color warningContainer = Color(0xFF5A4300);
  static const Color info = Color(0xFFA5C8FF);
  static const Color infoContainer = Color(0xFF004379);
}

final class AppColorSchemes {
  AppColorSchemes._();

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceTint: AppColors.surfaceTint,
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppDarkColors.primary,
    onPrimary: AppDarkColors.onPrimary,
    primaryContainer: AppDarkColors.primaryContainer,
    onPrimaryContainer: AppDarkColors.onPrimaryContainer,
    secondary: AppDarkColors.secondary,
    onSecondary: AppDarkColors.onSecondary,
    secondaryContainer: AppDarkColors.secondaryContainer,
    onSecondaryContainer: AppDarkColors.onSecondaryContainer,
    tertiary: AppDarkColors.tertiary,
    onTertiary: AppDarkColors.onTertiary,
    tertiaryContainer: AppDarkColors.tertiaryContainer,
    onTertiaryContainer: AppDarkColors.onTertiaryContainer,
    error: AppDarkColors.error,
    onError: AppDarkColors.onError,
    errorContainer: AppDarkColors.errorContainer,
    onErrorContainer: AppDarkColors.onErrorContainer,
    surface: AppDarkColors.surface,
    onSurface: AppDarkColors.onSurface,
    onSurfaceVariant: AppDarkColors.onSurfaceVariant,
    outline: AppDarkColors.outline,
    outlineVariant: AppDarkColors.outlineVariant,
    shadow: AppDarkColors.shadow,
    scrim: AppDarkColors.scrim,
    inverseSurface: AppDarkColors.inverseSurface,
    onInverseSurface: AppDarkColors.onInverseSurface,
    inversePrimary: AppDarkColors.inversePrimary,
    surfaceTint: AppDarkColors.surfaceTint,
  );
}
