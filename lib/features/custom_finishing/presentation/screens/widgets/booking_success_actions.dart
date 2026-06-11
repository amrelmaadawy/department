import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class BookingSuccessActions extends StatelessWidget {
  const BookingSuccessActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.colors.gold, Color(0xFFC99B40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: context.colors.gold.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              onTap: () {
                // Logic to navigate to tracking screen later
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.trackExecutionBtn,
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Icon(
                    FluentIcons.chevron_left_24_regular,
                    color: context.colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: AppSpacing.lg),

        OutlinedButton(
          onPressed: () {
            context.go('/'); // Clear stack and go to root
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18),
            side: BorderSide(
              color: context.colors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
          child: Text(
            l10n.returnToHomeBtn,
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
