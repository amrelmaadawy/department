import 'package:apartment/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerAnim;
  late Animation<double> _cardAnim;
  late Animation<double> _listAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _cardAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );

    _listAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock Data
    const userName = 'أحمد محمد';
    final userType = l10n.premiumCustomer;
    const avatarUrl = 'assets/images/profile_avatar.png';
    const designsCount = 12;
    const contractsCount = 5;
    const unitsCount = 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with stacked stats card
            Stack(
              clipBehavior: Clip.none,
              children: [
                FadeTransition(
                  opacity: _headerAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.2),
                      end: Offset.zero,
                    ).animate(_headerAnim),
                    child: ProfileHeader(
                      userName: userName,
                      userType: userType,
                      avatarUrl: avatarUrl,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40, // Half of the card height approximately
                  left: 0,
                  right: 0,
                  child: ScaleTransition(
                    scale: _cardAnim,
                    child: ProfileStatsCard(
                      designsCount: designsCount,
                      contractsCount: contractsCount,
                      unitsCount: unitsCount,
                      designsLabel: l10n.myDesigns,
                      contractsLabel: l10n.myContracts,
                      unitsLabel: l10n.myUnits,
                    ),
                  ),
                ),
              ],
            ),

            // Provide space for the overlapping card
            const SizedBox(height: 60),

            // Menu Groups
            FadeTransition(
              opacity: _listAnim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(_listAnim),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Section: My Real Estate
                      _buildSectionTitle('إدارة العقارات'),
                      _buildMenuGroup([
                        ProfileMenuItem(
                          icon: FluentIcons.building_24_regular,
                          title: 'الوحدات المحجوزة',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: FluentIcons.money_24_regular,
                          title: 'جدول الأقساط والمدفوعات',
                          showDivider: false,
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.xl),

                      // Section: Account Settings
                      _buildSectionTitle('إعدادات الحساب'),
                      _buildMenuGroup([
                        ProfileMenuItem(
                          icon: FluentIcons.person_edit_24_regular,
                          title: 'تعديل البيانات الشخصية',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: FluentIcons.shield_keyhole_24_regular,
                          title: 'الأمان وكلمة المرور',
                          showDivider: false,
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.xl),

                      // Section: App Settings
                      _buildSectionTitle('إعدادات التطبيق'),
                      _buildMenuGroup([
                        ProfileMenuItem(
                          icon: FluentIcons.globe_24_regular,
                          title: l10n.appLanguage,
                          trailingText: 'العربية',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: FluentIcons.alert_24_regular,
                          title: l10n.notifications,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: FluentIcons.weather_moon_24_regular,
                          title: 'الوضع الداكن',
                          trailingText: 'إيقاف',
                          showDivider: false,
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.xl),

                      // Section: Support
                      _buildSectionTitle('الدعم والمساعدة'),
                      _buildMenuGroup([
                        ProfileMenuItem(
                          icon: FluentIcons.headset_24_regular,
                          title: 'مركز المساعدة',
                          onTap: () => context.push('/support'),
                        ),
                        ProfileMenuItem(
                          icon: FluentIcons.chat_bubbles_question_24_regular,
                          title: 'تواصل مع المبيعات',
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
            ),
          ],
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
