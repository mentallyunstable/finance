import 'package:design_system/colors.dart';
import 'package:design_system/typography.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = _createTheme(AppColors.lightScheme);
  static final ThemeData darkTheme = _createTheme(AppColors.darkScheme);

  static const double _cardRadius = 24;
  static const double _buttonRadius = 20;
  static const double _inputRadius = 16;
  static const double _dialogRadius = 28;
  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static ThemeData _createTheme(ColorScheme colorScheme) {
    final textTheme = _textTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      cardColor: _surfaceContainerLow(colorScheme),
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.38),
      dividerColor: colorScheme.outlineVariant,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: _appBarTheme(colorScheme, textTheme),
      cardTheme: _cardTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme, textTheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme, textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _filledButtonStyle(
          colorScheme: colorScheme,
          backgroundColor: colorScheme.surfaceContainerHigh,
          foregroundColor: colorScheme.primary,
          elevation: 1,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _filledButtonStyle(
          colorScheme: colorScheme,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedButtonStyle(colorScheme, textTheme),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _textButtonStyle(colorScheme, textTheme),
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(colorScheme, textTheme),
      navigationBarTheme: _navigationBarTheme(colorScheme, textTheme),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: _segmentedButtonStyle(colorScheme, textTheme),
      ),
      snackBarTheme: _snackBarTheme(colorScheme, textTheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme, textTheme),
      switchTheme: _switchTheme(colorScheme),
      extensions: [
        const AppColorsExtension(success: AppColors.success),
      ],
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark
        ? AppTypography.dark(colorScheme)
        : AppTypography.light(colorScheme);
  }

  static AppBarTheme _appBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: colorScheme.surface,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: 18,
        color: colorScheme.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      color: _surfaceContainerLow(colorScheme),
      surfaceTintColor: colorScheme.surfaceTint,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return ChipThemeData(
      backgroundColor: _surfaceContainerHigh(colorScheme),
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
      deleteIconColor: colorScheme.onSurfaceVariant,
      labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      side: BorderSide(color: colorScheme.outlineVariant),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: _surfaceContainerLow(colorScheme),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      labelStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return textTheme.bodyLarge!.copyWith(color: colorScheme.error);
        }

        if (states.contains(WidgetState.focused)) {
          return textTheme.bodyLarge!.copyWith(color: colorScheme.primary);
        }

        return textTheme.bodyLarge!.copyWith(color: colorScheme.onSurfaceVariant);
      }),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return colorScheme.error;
        }

        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary;
        }

        return colorScheme.onSurfaceVariant;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.error)) {
          return colorScheme.error;
        }

        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary;
        }

        return colorScheme.onSurfaceVariant;
      }),
      border: _outlineInputBorder(colorScheme.outlineVariant),
      enabledBorder: _outlineInputBorder(colorScheme.outlineVariant),
      disabledBorder: _outlineInputBorder(colorScheme.onSurface.withValues(alpha: 0.12)),
      focusedBorder: _outlineInputBorder(colorScheme.primary, width: 2),
      errorBorder: _outlineInputBorder(colorScheme.error),
      focusedErrorBorder: _outlineInputBorder(colorScheme.error, width: 2),
    );
  }

  static ButtonStyle _outlinedButtonStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.primary;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.12));
        }

        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colorScheme.primary, width: 1.5);
        }

        return BorderSide(color: colorScheme.outline);
      }),
      overlayColor: WidgetStateColor.resolveWith(
        (states) => _stateLayerColor(states, colorScheme.primary),
      ),
      padding: const WidgetStatePropertyAll(_buttonPadding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
      ),
    );
  }

  static ButtonStyle _textButtonStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.primary;
      }),
      overlayColor: WidgetStateColor.resolveWith(
        (states) => _stateLayerColor(states, colorScheme.primary),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(_inputRadius)),
      ),
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      hoverColor: colorScheme.primaryContainer.withValues(alpha: 0.92),
      focusColor: colorScheme.primaryContainer.withValues(alpha: 0.9),
      splashColor: colorScheme.primary.withValues(alpha: 0.12),
      elevation: 0,
      highlightElevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_inputRadius)),
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: _bottomNavigationBackground(colorScheme),
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      selectedIconTheme: const IconThemeData(size: 20),
      unselectedIconTheme: const IconThemeData(size: 20),
      selectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
        letterSpacing: 0.25,
      ),
      unselectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        letterSpacing: 0.25,
      ),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return NavigationBarThemeData(
      backgroundColor: _surfaceContainer(colorScheme),
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
        final baseStyle = textTheme.labelMedium!;

        if (states.contains(WidgetState.selected)) {
          return baseStyle.copyWith(color: colorScheme.onSurface);
        }

        return baseStyle.copyWith(color: colorScheme.onSurfaceVariant);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.onSecondaryContainer);
        }

        return IconThemeData(color: colorScheme.onSurfaceVariant);
      }),
    );
  }

  static ButtonStyle _segmentedButtonStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onSecondaryContainer;
        }

        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.onSurface;
      }),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.secondaryContainer;
        }

        return Colors.transparent;
      }),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return BorderSide(color: colorScheme.secondaryContainer);
        }

        return BorderSide(color: colorScheme.outlineVariant);
      }),
      overlayColor: WidgetStateColor.resolveWith(
        (states) => _stateLayerColor(states, colorScheme.primary),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onInverseSurface),
      actionTextColor: colorScheme.inversePrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_inputRadius)),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: _surfaceContainerLow(colorScheme),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_dialogRadius)),
      ),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme colorScheme, TextTheme textTheme) {
    return DialogThemeData(
      backgroundColor: _surfaceContainerHigh(colorScheme),
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
      ),
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: colorScheme.onSurface),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static SwitchThemeData _switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }

        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.outline;
      }),
      trackColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }

        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }

        return colorScheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }

        return colorScheme.outline;
      }),
    );
  }

  static ButtonStyle _filledButtonStyle({
    required ColorScheme colorScheme,
    required Color backgroundColor,
    required Color foregroundColor,
    double elevation = 0,
  }) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(AppTypography.englishLike.labelLarge),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return foregroundColor;
      }),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }

        if (states.contains(WidgetState.pressed)) {
          return Color.alphaBlend(
            colorScheme.onPrimary.withValues(alpha: 0.08),
            backgroundColor,
          );
        }

        if (states.contains(WidgetState.hovered)) {
          return Color.alphaBlend(
            colorScheme.onPrimary.withValues(alpha: 0.04),
            backgroundColor,
          );
        }

        return backgroundColor;
      }),
      overlayColor: WidgetStateColor.resolveWith(
        (states) => _stateLayerColor(states, foregroundColor),
      ),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return 0;
        }

        if (states.contains(WidgetState.hovered)) {
          return elevation + 1;
        }

        if (states.contains(WidgetState.pressed)) {
          return 0;
        }

        return elevation;
      }),
      padding: const WidgetStatePropertyAll(_buttonPadding),
      minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
      ),
    );
  }

  static Color _stateLayerColor(Set<WidgetState> states, Color color) {
    if (states.contains(WidgetState.pressed)) {
      return color.withValues(alpha: 0.12);
    }

    if (states.contains(WidgetState.hovered)) {
      return color.withValues(alpha: 0.08);
    }

    if (states.contains(WidgetState.focused)) {
      return color.withValues(alpha: 0.12);
    }

    return Colors.transparent;
  }

  static OutlineInputBorder _outlineInputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_inputRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static Color _surfaceContainerLow(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark
        ? AppColors.surfaceContainerLowDark
        : AppColors.surfaceContainerLow;
  }

  static Color _surfaceContainer(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark ? AppColors.surfaceContainerDark : AppColors.surfaceContainer;
  }

  static Color _surfaceContainerHigh(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark
        ? AppColors.surfaceContainerHighDark
        : AppColors.surfaceContainerHigh;
  }

  static Color _bottomNavigationBackground(ColorScheme colorScheme) {
    return colorScheme.brightness == Brightness.dark
        ? AppColors.surfaceContainerLowDark
        : AppColors.surfaceContainerLowest;
  }
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color? success;

  const AppColorsExtension({
    this.success,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    final Color? success,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant final ThemeExtension<AppColorsExtension>? other,
    final double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      success: Color.lerp(success, other.success, t),
    );
  }
}
