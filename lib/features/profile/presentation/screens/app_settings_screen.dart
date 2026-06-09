import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../../core/localization/cubit/locale_state.dart';

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
      body: Stack(
        children: [
          // Premium Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF9F6F0),
                  Color(0xFFEFECE5),
                ],
              ),
            ),
          ),
          
          // Subtle Gold Glow behind elements
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.15),
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
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          // Apply a large blur over the abstract shapes
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildPremiumAppBar(l10n),
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
                        // Section: Language
                        _buildAnimatedItem(
                          delay: 100,
                          child: _buildSectionTitle(l10n.appLanguage),
                        ),
                        BlocBuilder<LocaleCubit, LocaleState>(
                          builder: (context, state) {
                            final currentLang = state.locale.languageCode;
                            return _buildAnimatedItem(
                              delay: 200,
                              child: _buildGlassCard(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                children: [
                                  _buildLanguageToggle(currentLang, context, l10n),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Section: Appearance
                        _buildAnimatedItem(
                          delay: 300,
                          child: _buildSectionTitle(l10n.appearance),
                        ),
                        _buildAnimatedItem(
                          delay: 400,
                          child: _buildGlassCard(
                            children: [
                              _buildPremiumToggleRow(
                                icon: FluentIcons.weather_moon_24_regular,
                                title: l10n.darkMode,
                                subtitle: l10n.darkModeDesc,
                                value: _isDarkMode,
                                onChanged: (val) => setState(() => _isDarkMode = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Section: Notifications
                        _buildAnimatedItem(
                          delay: 500,
                          child: _buildSectionTitle(l10n.notifications),
                        ),
                        _buildAnimatedItem(
                          delay: 600,
                          child: _buildGlassCard(
                            children: [
                              _buildPremiumToggleRow(
                                icon: FluentIcons.alert_24_regular,
                                title: l10n.appNotifications,
                                subtitle: l10n.appNotificationsDesc,
                                value: _pushNotifications,
                                onChanged: (val) => setState(() => _pushNotifications = val),
                              ),
                              Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
                              _buildPremiumToggleRow(
                                icon: FluentIcons.mail_24_regular,
                                title: l10n.newsletter,
                                subtitle: l10n.newsletterDesc,
                                value: _emailNotifications,
                                onChanged: (val) => setState(() => _emailNotifications = val),
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

  Widget _buildPremiumAppBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: const Icon(FluentIcons.ios_arrow_rtl_24_regular, color: AppColors.primary, size: 20),
            ),
            onPressed: () => context.pop(),
          ),
          Text(
            l10n.profileSectionApp,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required Widget child, required int delay}) {
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, right: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppFonts.bodyLarge,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildGlassCard({required List<Widget> children, EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
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

  Widget _buildLanguageToggle(String currentLang, BuildContext context, AppLocalizations l10n) {
    final isAr = currentLang == 'ar';
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.3),
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
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
                        color: isAr ? AppColors.gold : AppColors.textSecondary,
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
                        color: !isAr ? AppColors.gold : AppColors.textSecondary,
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

  Widget _buildPremiumToggleRow({
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
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.lg),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppFonts.bodySmall,
                    color: AppColors.textSecondary,
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
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? AppColors.gold : AppColors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: value
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.4),
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
                  decoration: const BoxDecoration(
                    color: AppColors.white,
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
