import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_menu_list.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
      backgroundColor: context.colors.background,
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
            SizedBox(height: 60),

            // Menu Groups
            ProfileMenuList(listAnim: _listAnim),
          ],
        ),
      ),
    );
  }

}
