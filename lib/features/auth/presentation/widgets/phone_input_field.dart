import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: context.colors.white,
      ),
      child: Row(
        children: [
          // Text Input Field (Renders on the right in RTL)
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr, // Phone numbers are LTR
              textAlign:
                  TextAlign.right, // Align text to the right where the hint is
              decoration: InputDecoration(
                hintText: l10n.mobileNumber,
                hintStyle: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: AppFonts.bodyMedium,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
              ),
            ),
          ),

          // Vertical Separator
          Container(width: 1, height: 30, color: context.colors.border),

          // Country Code Prefix (Renders on the left in RTL)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Directionality(
              textDirection: TextDirection
                  .ltr, // Force LTR for prefix so icon stays on the far left
              child: Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '+966',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
