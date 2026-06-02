import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          // Start Edge: Avatar & User Info
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/user_avatar_mock.png'),
            backgroundColor: AppColors.border,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.helloUser('عبدالله'),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(FluentIcons.location_12_regular, color: AppColors.gold, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    l10n.riyadh,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Icon(FluentIcons.alert_24_regular, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}
