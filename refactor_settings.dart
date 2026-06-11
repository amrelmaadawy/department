import 'dart:io';

void main() {
  final path = 'lib/features/profile/presentation/widgets/settings';
  final dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  File('$path/settings_premium_app_bar.dart').writeAsStringSync('''
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
''');

  File('$path/settings_animated_item.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

class SettingsAnimatedItem extends StatelessWidget {
  final Widget child;
  final int delay;

  const SettingsAnimatedItem({super.key, required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
''');

  File('$path/settings_section_title.dart').writeAsStringSync('''
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
      padding: EdgeInsets.only(bottom: AppSpacing.md, right: AppSpacing.sm),
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
''');

  File('$path/settings_glass_card.dart').writeAsStringSync('''
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class SettingsGlassCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsGlassCard({super.key, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Column(children: children),
          ),
        ),
      ),
    );
  }
}
''');

  File('$path/settings_language_toggle.dart').writeAsStringSync('''
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
''');

  File('$path/settings_premium_toggle_row.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class SettingsPremiumToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsPremiumToggleRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: context.colors.primary, size: 22),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFonts.bodySmall,
                    color: context.colors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 50,
              height: 28,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? context.colors.gold : context.colors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: context.colors.gold.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
''');

  File('lib/features/profile/presentation/screens/app_settings_screen.dart').writeAsStringSync('''
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
''');

}
