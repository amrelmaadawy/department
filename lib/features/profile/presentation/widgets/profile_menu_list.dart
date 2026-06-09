import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  final Animation<double> listAnim;

  const ProfileMenuList({super.key, required this.listAnim});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: listAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(listAnim),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              // Section: My Real Estate
              _buildSectionTitle(l10n.profileSectionRealEstate),
              _buildMenuGroup([
                ProfileMenuItem(
                  icon: FluentIcons.building_24_regular,
                  title: l10n.profileMenuMyUnits,
                  onTap: () => context.push('/my-units'),
                ),
                ProfileMenuItem(
                  icon: FluentIcons.money_24_regular,
                  title: l10n.profileMenuInstallments,
                  showDivider: false,
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),

              // Section: Account Settings
              _buildSectionTitle(l10n.profileSectionAccount),
              _buildMenuGroup([
                ProfileMenuItem(
                  icon: FluentIcons.person_edit_24_regular,
                  title: l10n.profileMenuEditProfile,
                  onTap: () => context.push('/edit-profile'),
                ),
                ProfileMenuItem(
                  icon: FluentIcons.shield_keyhole_24_regular,
                  title: l10n.profileMenuSecurity,
                  showDivider: false,
                  onTap: () => context.push('/security'),
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),

              // Section: App Settings
              _buildSectionTitle(l10n.profileSectionApp),
              _buildMenuGroup([
                ProfileMenuItem(
                  icon: FluentIcons.settings_24_regular,
                  title: l10n.profileSectionApp,
                  showDivider: false,
                  onTap: () => context.push('/app-settings'),
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),

              // Section: Support
              _buildSectionTitle(l10n.profileSectionSupport),
              _buildMenuGroup([
                ProfileMenuItem(
                  icon: FluentIcons.headset_24_regular,
                  title: l10n.profileMenuHelpCenter,
                  onTap: () => context.push('/support'),
                ),
                ProfileMenuItem(
                  icon: FluentIcons.chat_bubbles_question_24_regular,
                  title: l10n.profileMenuContactSales,
                  showDivider: false,
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: AppSpacing.xl),

              // Section: Logout
              _buildMenuGroup([
                ProfileMenuItem(
                  icon: FluentIcons.sign_out_24_regular,
                  title: l10n.logout,
                  isDestructive: true,
                  showDivider: false,
                  onTap: () {},
                ),
              ]),

              const SizedBox(
                height: AppSpacing.xxxl * 2,
              ), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            spreadRadius: -5,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Column(children: children),
      ),
    );
  }
}
