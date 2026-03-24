import 'package:design_system/colors.dart';
import 'package:design_system/typography.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(AppColorSchemes.light);

  static ThemeData get darkTheme => _buildTheme(AppColorSchemes.dark);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = isDark
        ? AppTypography.dark(colorScheme)
        : AppTypography.light(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      cardColor: isDark
          ? AppDarkColors.surfaceContainerLow
          : AppColors.surfaceContainerLow,
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.38),
      dividerColor: colorScheme.outlineVariant,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark
            ? AppDarkColors.surfaceContainerLow
            : AppColors.surfaceContainerLow,
        surfaceTintColor: colorScheme.surfaceTint,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppDarkColors.surfaceContainerHigh
            : AppColors.surfaceContainerHigh,
        selectedColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        deleteIconColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppDarkColors.surfaceContainerLow
            : AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return textTheme.bodyLarge!.copyWith(color: colorScheme.error);
          }

          if (states.contains(WidgetState.focused)) {
            return textTheme.bodyLarge!.copyWith(color: colorScheme.primary);
          }

          return textTheme.bodyLarge!.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
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
        disabledBorder: _outlineInputBorder(
          colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        focusedBorder: _outlineInputBorder(colorScheme.primary, width: 2),
        errorBorder: _outlineInputBorder(colorScheme.error),
        focusedErrorBorder: _outlineInputBorder(colorScheme.error, width: 2),
      ),
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
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }

            return colorScheme.primary;
          }),
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
              );
            }

            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colorScheme.primary, width: 1.5);
            }

            return BorderSide(color: colorScheme.outline);
          }),
          overlayColor: WidgetStateColor.resolveWith(
            (states) => _stateLayerColor(states, colorScheme.primary),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        hoverColor: colorScheme.primaryContainer.withValues(alpha: 0.92),
        focusColor: colorScheme.primaryContainer.withValues(alpha: 0.9),
        splashColor: colorScheme.primary.withValues(alpha: 0.12),
        elevation: 0,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? AppDarkColors.surfaceContainer
            : AppColors.surfaceContainer,
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
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
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
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? AppDarkColors.surfaceContainerLow
            : AppColors.surfaceContainerLow,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? AppDarkColors.surfaceContainerHigh
            : AppColors.surfaceContainerHigh,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      switchTheme: SwitchThemeData(
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
      ),
    );
  }

  static ButtonStyle _filledButtonStyle({
    required ColorScheme colorScheme,
    required Color backgroundColor,
    required Color foregroundColor,
    double elevation = 0,
  }) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        AppTypography.englishLike.labelLarge,
      ),
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
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
