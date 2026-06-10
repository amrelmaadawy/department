import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../../core/localization/cubit/locale_state.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import '../widgets/settings/settings_animated_item.dart';
import '../widgets/settings/settings_glass_card.dart';
import '../widgets/settings/settings_language_toggle.dart';
import '../widgets/settings/settings_premium_app_bar.dart';
import '../widgets/settings/settings_premium_toggle_row.dart';
import '../widgets/settings/settings_section_title.dart';

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
  void initState() {
    super.initState();
    _isDarkMode = context.read<ThemeCubit>().state.themeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colors.background,
                  context.colors.background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.gold.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SettingsPremiumAppBar(l10n: l10n),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingsAnimatedItem(
                          delay: 100,
                          child: SettingsSectionTitle(title: l10n.appLanguage),
                        ),
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, state) {
                            final currentLang = state.locale.languageCode;
                            return SettingsAnimatedItem(
                              delay: 200,
                              child: SettingsGlassCard(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                children: [
                                  SettingsLanguageToggle(
                                    currentLang: currentLang,
                                    l10n: l10n,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        SettingsAnimatedItem(
                          delay: 300,
                          child: SettingsSectionTitle(title: l10n.appearance),
                        ),
                        SettingsAnimatedItem(
                          delay: 400,
                          child: SettingsGlassCard(
                            children: [
                              SettingsPremiumToggleRow(
                                icon: FluentIcons.weather_moon_24_regular,
                                title: l10n.darkMode,
                                subtitle: l10n.darkModeDesc,
                                value: _isDarkMode,
                                onChanged: (val) {
                                  setState(() => _isDarkMode = val);
                                  context.read<ThemeCubit>().changeTheme(
                                      val ? ThemeMode.dark : ThemeMode.light);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        SettingsAnimatedItem(
                          delay: 500,
                          child: SettingsSectionTitle(title: l10n.notifications),
                        ),
                        SettingsAnimatedItem(
                          delay: 600,
                          child: SettingsGlassCard(
                            children: [
                              SettingsPremiumToggleRow(
                                icon: FluentIcons.alert_24_regular,
                                title: l10n.appNotifications,
                                subtitle: l10n.appNotificationsDesc,
                                value: _pushNotifications,
                                onChanged: (val) =>
                                    setState(() => _pushNotifications = val),
                              ),
                              Divider(
                                color: context.colors.border.withValues(alpha: 0.5),
                                height: 1,
                              ),
                              SettingsPremiumToggleRow(
                                icon: FluentIcons.mail_24_regular,
                                title: l10n.newsletter,
                                subtitle: l10n.newsletterDesc,
                                value: _emailNotifications,
                                onChanged: (val) =>
                                    setState(() => _emailNotifications = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
