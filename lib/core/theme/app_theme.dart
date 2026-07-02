import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_colors_extension.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      fontFamilyFallback: const ['NotoSansArabic'],
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColorsExtension(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
          gold: AppColors.gold,
          goldLight: AppColors.goldLight,
          goldDark: AppColors.goldDark,
          white: AppColors.white,
          darkSlate: AppColors.darkSlate,
          whatsapp: AppColors.whatsapp,
          darkOverlay: AppColors.darkOverlay,
          border: AppColors.border,
          buttonDark: AppColors.buttonDark,
          error: AppColors.error,
          success: AppColors.success,
          warning: AppColors.warning,
          transparent: AppColors.transparent,
          black: AppColors.black,
          grey: AppColors.grey,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      fontFamilyFallback: const ['NotoSansArabic'],
      scaffoldBackgroundColor: const Color(0xFF0B132B), // Deep Ocean Navy Background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B132B),
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColorsExtension(
          primary: Color(0xFF4A89DC), // Bright professional blue for contrast
          secondary: AppColors.secondary,
          background: Color(0xFF0B132B),
          textPrimary: Color(0xFFF0F4F8), // Icy white text
          textSecondary: Color(0xFF8B9BB4), // Blue-grey secondary text
          gold: AppColors.gold, // Keep original brand gold
          goldLight: AppColors.goldLight,
          goldDark: AppColors.goldDark,
          white: Color(0xFF152243), // Elevated navy for cards
          darkSlate: AppColors.darkSlate,
          whatsapp: AppColors.whatsapp,
          darkOverlay: AppColors.darkOverlay,
          border: Color(0xFF233559), // Blue-tinted border
          buttonDark: Color(0xFFF0F4F8), // Invert button text
          error: AppColors.error,
          success: AppColors.success,
          warning: AppColors.warning,
          transparent: AppColors.transparent,
          black: AppColors.black,
          grey: AppColors.grey,
        ),
      ],
    );
  }
}
