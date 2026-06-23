import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, right: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFonts.bodyLarge,
          fontWeight: FontWeight.w900,
          color: context.colors.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
