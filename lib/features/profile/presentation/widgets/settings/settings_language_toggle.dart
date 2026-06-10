import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/core/localization/cubit/locale_cubit.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class SettingsLanguageToggle extends StatelessWidget {
  final String currentLang;
  final AppLocalizations l10n;

  const SettingsLanguageToggle({
    super.key,
    required this.currentLang,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = currentLang == 'ar';
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: context.colors.border.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<LocaleCubit>().changeLanguage('ar'),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: isAr ? FontWeight.w900 : FontWeight.w600,
                        color: isAr ? context.colors.gold : context.colors.textPrimary.withValues(alpha: 0.5),
                      ),
                      child: Text(l10n.arabicLang),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<LocaleCubit>().changeLanguage('en'),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: !isAr ? FontWeight.w900 : FontWeight.w600,
                        color: !isAr ? context.colors.gold : context.colors.textPrimary.withValues(alpha: 0.5),
                      ),
                      child: const Text('English'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
