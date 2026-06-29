import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color gold;
  final Color goldLight;
  final Color goldDark;
  final Color white;
  final Color darkSlate;
  final Color whatsapp;
  final Color darkOverlay;
  final Color border;
  final Color buttonDark;
  final Color error;
  final Color success;
  final Color warning;
  final Color transparent;
  final Color black;
  final Color grey;

  const AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.gold,
    required this.goldLight,
    required this.goldDark,
    required this.white,
    required this.darkSlate,
    required this.whatsapp,
    required this.darkOverlay,
    required this.border,
    required this.buttonDark,
    required this.error,
    required this.success,
    required this.warning,
    required this.transparent,
    required this.black,
    required this.grey,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? gold,
    Color? goldLight,
    Color? goldDark,
    Color? white,
    Color? darkSlate,
    Color? whatsapp,
    Color? darkOverlay,
    Color? border,
    Color? buttonDark,
    Color? error,
    Color? success,
    Color? warning,
    Color? transparent,
    Color? black,
    Color? grey,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      gold: gold ?? this.gold,
      goldLight: goldLight ?? this.goldLight,
      goldDark: goldDark ?? this.goldDark,
      white: white ?? this.white,
      darkSlate: darkSlate ?? this.darkSlate,
      whatsapp: whatsapp ?? this.whatsapp,
      darkOverlay: darkOverlay ?? this.darkOverlay,
      border: border ?? this.border,
      buttonDark: buttonDark ?? this.buttonDark,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      transparent: transparent ?? this.transparent,
      black: black ?? this.black,
      grey: grey ?? this.grey,
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
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      goldDark: Color.lerp(goldDark, other.goldDark, t)!,
      white: Color.lerp(white, other.white, t)!,
      darkSlate: Color.lerp(darkSlate, other.darkSlate, t)!,
      whatsapp: Color.lerp(whatsapp, other.whatsapp, t)!,
      darkOverlay: Color.lerp(darkOverlay, other.darkOverlay, t)!,
      border: Color.lerp(border, other.border, t)!,
      buttonDark: Color.lerp(buttonDark, other.buttonDark, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      black: Color.lerp(black, other.black, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
    );
  }
}
