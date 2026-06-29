import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

class FinishingJourneyGuideScreen extends StatefulWidget {
  final ProjectUnitEntity unit;

  const FinishingJourneyGuideScreen({
    super.key,
    required this.unit,
  });

  @override
  State<FinishingJourneyGuideScreen> createState() => _FinishingJourneyGuideScreenState();
}

class _FinishingJourneyGuideScreenState extends State<FinishingJourneyGuideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      _GuideStep(
        icon: FluentIcons.color_24_regular,
        title: l10n.guideStep1Title,
        description: l10n.guideStep1Desc,
      ),
      _GuideStep(
        icon: FluentIcons.sparkle_24_regular,
        title: l10n.guideStep2Title,
        description: l10n.guideStep2Desc,
      ),
      _GuideStep(
        icon: FluentIcons.save_copy_24_regular,
        title: l10n.guideStep3Title,
        description: l10n.guideStep3Desc,
      ),
      _GuideStep(
        icon: FluentIcons.document_text_24_regular,
        title: l10n.guideStep4Title,
        description: l10n.guideStep4Desc,
      ),
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? FluentIcons.chevron_right_24_regular
                : FluentIcons.chevron_left_24_regular,
            color: context.colors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background graphic
          Positioned(
            top: -100,
            right: -50,
            child: Opacity(
              opacity: isDark ? 0.05 : 0.08,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animController,
                              curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.2), end: Offset.zero)
                                .animate(
                              CurvedAnimation(
                                parent: _animController,
                                curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: context.colors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    FluentIcons.rocket_24_filled,
                                    color: context.colors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  l10n.guideTitle,
                                  style: TextStyle(
                                    fontSize: AppFonts.headlineMedium,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  l10n.guideSubtitle,
                                  style: TextStyle(
                                    fontSize: AppFonts.bodyLarge,
                                    color: context.colors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Steps List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            final step = steps[index];
                            // Staggered animation for each step
                            final delay = 0.3 + (index * 0.15);
                            final animation = CurvedAnimation(
                              parent: _animController,
                              curve: Interval(delay.clamp(0.0, 1.0),
                                  (delay + 0.3).clamp(0.0, 1.0),
                                  curve: Curves.easeOut),
                            );

                            return FadeTransition(
                              opacity: Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(animation),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.2),
                                        end: Offset.zero)
                                    .animate(animation),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step Number & Line
                                      Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: context.colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: context.colors.border,
                                                width: 1.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.black
                                                      .withValues(alpha: 0.03),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  fontSize: AppFonts.headlineSmall,
                                                  fontWeight: FontWeight.bold,
                                                  color: context.colors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (index < steps.length - 1)
                                            Container(
                                              width: 2,
                                              height: 40,
                                              margin: const EdgeInsets.only(top: 4),
                                              decoration: BoxDecoration(
                                                color: context.colors.border
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: AppSpacing.md),

                                      // Step Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  step.icon,
                                                  size: 20,
                                                  color: context.colors.gold,
                                                ),
                                                const SizedBox(width: AppSpacing.sm),
                                                Expanded(
                                                  child: Text(
                                                    step.title,
                                                    style: TextStyle(
                                                      fontSize: AppFonts.bodyLarge,
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          context.colors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: AppSpacing.sm),
                                            Text(
                                              step.description,
                                              style: TextStyle(
                                                fontSize: AppFonts.bodyMedium,
                                                color: context.colors.textSecondary,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Bar
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animController,
                      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Primary: Choose a ready package
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: l10n.selectPackageBtn,
                              onPressed: () {
                                context.push(
                                  AppRouter.packages,
                                  extra: {'unit': widget.unit},
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          // Secondary: Manual customization
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                context.pushReplacement(
                                  AppRouter.unitCustomization,
                                  extra: {'unit': widget.unit},
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.colors.primary,
                                side: BorderSide(color: context.colors.primary),
                                minimumSize: const Size(double.infinity, 52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.lg),
                                ),
                              ),
                              child: Text(
                                l10n.startManualBtn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppFonts.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

class _GuideStep {
  final IconData icon;
  final String title;
  final String description;

  _GuideStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}
