import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color gold;
  final Color white;
  final Color darkOverlay;
  final Color border;
  final Color buttonDark;
  final Color error;
  final Color success;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.gold,
    required this.white,
    required this.darkOverlay,
    required this.border,
    required this.buttonDark,
    required this.error,
    required this.success,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? gold,
    Color? white,
    Color? darkOverlay,
    Color? border,
    Color? buttonDark,
    Color? error,
    Color? success,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      gold: gold ?? this.gold,
      white: white ?? this.white,
      darkOverlay: darkOverlay ?? this.darkOverlay,
      border: border ?? this.border,
      buttonDark: buttonDark ?? this.buttonDark,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      white: Color.lerp(white, other.white, t)!,
      darkOverlay: Color.lerp(darkOverlay, other.darkOverlay, t)!,
      border: Color.lerp(border, other.border, t)!,
      buttonDark: Color.lerp(buttonDark, other.buttonDark, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}
