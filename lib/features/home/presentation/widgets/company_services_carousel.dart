import 'dart:async';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class CompanyServicesCarousel extends StatefulWidget {
  const CompanyServicesCarousel({super.key});

  @override
  State<CompanyServicesCarousel> createState() => _CompanyServicesCarouselState();
}

class _CompanyServicesCarouselState extends State<CompanyServicesCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          // We have 9 services
          _currentIndex = (_currentIndex + 1) % 9;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<_ServiceData> services = [
      _ServiceData(title: l10n.srvRealEstateDevTitle, subtitle: l10n.srvRealEstateDevDesc, icon: FluentIcons.building_24_regular),
      _ServiceData(title: l10n.srvContractingTitle, subtitle: l10n.srvContractingDesc, icon: FluentIcons.wrench_24_regular),
      _ServiceData(title: l10n.srvInvestmentTitle, subtitle: l10n.srvInvestmentDesc, icon: FluentIcons.money_24_regular),
      _ServiceData(title: l10n.srvMarketingTitle, subtitle: l10n.srvMarketingDesc, icon: FluentIcons.megaphone_24_regular),
      _ServiceData(title: l10n.srvSellingTitle, subtitle: l10n.srvSellingDesc, icon: FluentIcons.tag_24_regular),
      _ServiceData(title: l10n.srvBuyingTitle, subtitle: l10n.srvBuyingDesc, icon: FluentIcons.handshake_24_regular),
      _ServiceData(title: l10n.srvPropertyMgtTitle, subtitle: l10n.srvPropertyMgtDesc, icon: FluentIcons.home_24_regular),
      _ServiceData(title: l10n.srvLeasingTitle, subtitle: l10n.srvLeasingDesc, icon: FluentIcons.key_24_regular),
      _ServiceData(title: l10n.srvEContractsTitle, subtitle: l10n.srvEContractsDesc, icon: FluentIcons.signature_24_regular),
    ];

    final currentService = services[_currentIndex];

    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? context.colors.darkOverlay : context.colors.primary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            
            // Fading Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<int>(_currentIndex),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
                      ),
                      child: Icon(
                        currentService.icon,
                        color: context.colors.gold,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.colors.gold.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              l10n.ourServices,
                              style: TextStyle(
                                fontSize: AppFonts.labelSmall,
                                color: context.colors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            currentService.title,
                            style: const TextStyle(
                              fontSize: AppFonts.headlineMedium,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            currentService.subtitle,
                            style: TextStyle(
                              fontSize: AppFonts.bodyMedium,
                              color: Colors.white.withValues(alpha: 0.8),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pagination Dots
            Positioned(
              bottom: AppSpacing.md,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  services.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? context.colors.gold : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceData {
  final String title;
  final String subtitle;
  final IconData icon;

  _ServiceData({required this.title, required this.subtitle, required this.icon});
}
