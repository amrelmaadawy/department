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

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? context.colors.gold;
    final effectiveTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Text(
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
