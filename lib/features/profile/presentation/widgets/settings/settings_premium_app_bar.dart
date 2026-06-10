import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class SettingsPremiumAppBar extends StatelessWidget {
  final AppLocalizations l10n;
  
  const SettingsPremiumAppBar({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.white, width: 1.5),
              ),
              child: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.primary, size: 20),
            ),
            onPressed: () => context.pop(),
          ),
          Text(
            l10n.profileSectionApp,
            style: TextStyle(
              color: context.colors.primary,
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }
}
