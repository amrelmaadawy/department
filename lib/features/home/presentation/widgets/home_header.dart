import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Start Edge: Avatar & User Info
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/user_avatar_mock.png'),
            backgroundColor: context.colors.border,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.helloUser('عبدالله'),
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    FluentIcons.location_12_regular,
                    color: context.colors.gold,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.riyadh,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: AppFonts.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // End Edge: Location & Notification
          Text(
            l10n.riyadh,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Icon(
          //   FluentIcons.alert_24_regular,
          //   color: context.colors.textPrimary,
          // ),
        ],
      ),
    );
  }
}