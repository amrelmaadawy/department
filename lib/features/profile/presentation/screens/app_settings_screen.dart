import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../../core/localization/cubit/locale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _isDarkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: Text(
          l10n.profileSectionApp,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FluentIcons.ios_arrow_rtl_24_regular, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Language
            _buildSectionTitle(l10n.appLanguage),
            BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, state) {
                final currentLang = state.locale.languageCode;
                return _buildSettingsCard(
                  children: [
                    _buildLanguageRow(l10n.arabicLang, currentLang == 'ar', 'ar', context),
                    const Divider(color: AppColors.border, height: 1),
                    _buildLanguageRow('English', currentLang == 'en', 'en', context),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Section: Appearance
            _buildSectionTitle(l10n.appearance),
            _buildSettingsCard(
              children: [
                _buildToggleRow(
                  icon: FluentIcons.weather_moon_24_regular,
                  title: l10n.darkMode,
                  subtitle: l10n.darkModeDesc,
                  value: _isDarkMode,
                  onChanged: (val) => setState(() => _isDarkMode = val),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Section: Notifications
            _buildSectionTitle(l10n.notifications),
            _buildSettingsCard(
              children: [
                _buildToggleRow(
                  icon: FluentIcons.alert_24_regular,
                  title: l10n.appNotifications,
                  subtitle: l10n.appNotificationsDesc,
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(color: AppColors.border, height: 1),
                _buildToggleRow(
                  icon: FluentIcons.mail_24_regular,
                  title: l10n.newsletter,
                  subtitle: l10n.newsletterDesc,
                  value: _emailNotifications,
                  onChanged: (val) => setState(() => _emailNotifications = val),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, right: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppFonts.bodyLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildLanguageRow(String label, bool isSelected, String languageCode, BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<LocaleCubit>().changeLanguage(languageCode);
      },
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.gold : AppColors.textPrimary,
              ),
            ),
            if (isSelected)
              const Icon(FluentIcons.checkmark_24_regular, color: AppColors.gold),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppFonts.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.gold,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
