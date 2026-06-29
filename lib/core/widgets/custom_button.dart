import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? context.colors.gold;
    final effectiveTextColor = textColor ?? AppColors.white;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
