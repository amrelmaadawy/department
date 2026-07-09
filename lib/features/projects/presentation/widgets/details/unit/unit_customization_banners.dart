import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_state.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageModeBanner extends StatelessWidget {
  final String packageName;

  const PackageModeBanner({super.key, required this.packageName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: context.colors.gold.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(FluentIcons.star_24_filled, size: 16, color: context.colors.gold),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              '${l10n.packageModeActiveLabel}: $packageName',
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                fontWeight: FontWeight.w600,
                color: context.colors.gold,
              ),
            ),
          ),
          Tooltip(
            message: l10n.packageModeInfo,
            child: Icon(FluentIcons.info_24_regular, size: 16, color: context.colors.gold),
          ),
        ],
      ),
    );
  }
}

class AiCreditsBanner extends StatelessWidget {
  const AiCreditsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: sl<ProfileCubit>(),
      builder: (context, profileState) {
        int? credits;
        String? errorMessage;
        if (profileState is ProfileLoaded) {
          credits = profileState.profile.user.aiCredits;
        } else if (profileState is ProfileUpdateSuccess) {
          credits = profileState.profile.user.aiCredits;
        } else if (profileState is ProfileError) {
          errorMessage = profileState.message;
          credits = 0;
        }

        final bool hasError = errorMessage != null;
        final bool isWarning = credits != null && credits <= 1 && !hasError;
        final Color contentColor = hasError || isWarning ? context.colors.error : context.colors.primary;
        final Color bgColor = contentColor.withValues(alpha: 0.1);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          color: bgColor,
          child: Row(
            children: [
              Icon(hasError ? FluentIcons.error_circle_24_regular : FluentIcons.sparkle_24_filled, size: 18, color: contentColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: credits == null && !hasError
                    ? Row(
                        children: [
                          Text(
                            'جاري تحميل رصيد التصميم...',
                            style: TextStyle(
                              fontSize: AppFonts.bodySmall,
                              fontWeight: FontWeight.bold,
                              color: contentColor,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: contentColor,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        hasError ? 'لم يتم جلب الرصيد ($errorMessage)' : 'رصيد التصميم الذكي المتبقي: ${credits! > 200 ? 'غير محدود' : credits}',
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                      ),
              ),
              if (!hasError)
                Tooltip(
                  message: 'استخدم هذا الرصيد لتوليد تصميمات ذكية لغرفتك',
                  child: Icon(FluentIcons.info_24_regular, size: 16, color: contentColor),
                ),
            ],
          ),
        );
      },
    );
  }
}
