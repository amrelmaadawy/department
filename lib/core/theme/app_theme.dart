import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_colors_extension.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppColorsExtension(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
          gold: AppColors.gold,
          white: AppColors.white,
          darkOverlay: AppColors.darkOverlay,
          border: AppColors.border,
          buttonDark: AppColors.buttonDark,
          error: AppColors.error,
          success: AppColors.success,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      scaffoldBackgroundColor: const Color(0xFF0B132B), // Deep Ocean Navy Background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B132B),
        elevation: 0,
        centerTitle: true,
      ),
      extensions: <ThemeExtension<dynamic>>[
        const AppColorsExtension(
          primary: Color(0xFF4A89DC), // Bright professional blue for contrast
          secondary: AppColors.secondary,
          background: Color(0xFF0B132B),
          textPrimary: Color(0xFFF0F4F8), // Icy white text
          textSecondary: Color(0xFF8B9BB4), // Blue-grey secondary text
          gold: AppColors.gold, // Keep original brand gold
          white: Color(0xFF152243), // Elevated navy for cards
          darkOverlay: AppColors.darkOverlay,
          border: Color(0xFF233559), // Blue-tinted border
          buttonDark: Color(0xFFF0F4F8), // Invert button text
          error: AppColors.error,
          success: AppColors.success,
        ),
      ],
    );
  }
}
