import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/routes/app_router.dart';
import '../cubit/design_context_cubit.dart';
import '../cubit/design_context_state.dart';
import '../widgets/unit_selection_bottom_sheet.dart';

class DesignStudioScreen extends StatelessWidget {
  const DesignStudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DesignContextCubit, DesignContextState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.background,
          body: CustomScrollView(
            slivers: [
              _buildHeroHeader(context, state),
              SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, l10n.availablePaths),
                  const SizedBox(height: AppSpacing.md),
                  _buildAiCard(context),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSecondaryCard(
                    context: context,
                    title: l10n.browseFinishingPackages,
                    subtitle: l10n.exploreTailoredPackages,
                    icon: FluentIcons.box_24_regular,
                    onTap: () => context.push(AppRouter.packages),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSecondaryCard(
                    context: context,
                    title: l10n.mySavedDesigns,
                    subtitle: l10n.returnToSavedDesigns,
                    icon: FluentIcons.folder_24_regular,
                    onTap: () {
                      // Placeholder
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.featureComingSoon)),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
            ),
          ],
        ),
        );
      },
    );
  }

  Widget _buildHeroHeader(BuildContext context, DesignContextState state) {
    final l10n = AppLocalizations.of(context)!;
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: context.colors.background, // Match background
      elevation: 0,
      scrolledUnderElevation: 0, // Removes the scroll shadow
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/design_studio_hero_bright.png',
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Text Content
            Positioned(
              bottom: AppSpacing.xl,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(FluentIcons.sparkle_16_filled, color: AppColors.gold, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              l10n.designLab,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppFonts.bodySmall,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.designStudio,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.displayMedium,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.buildDreamHomeSubtitle,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: AppFonts.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildContextSelectorBar(context, state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextSelectorBar(BuildContext context, DesignContextState state) {
    final l10n = AppLocalizations.of(context)!;
    final isCustom = state.isCustomArea;
    final title = isCustom ? l10n.estimatedAreaTitle(state.baseArea.toString()) : l10n.unitTitle(state.selectedUnit?.title.split(' ')[0] ?? '');

    return GestureDetector(
      onTap: () {
        final cubit = context.read<DesignContextCubit>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BlocProvider.value(
            value: cubit,
            child: const UnitSelectionBottomSheet(),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCustom ? FluentIcons.ruler_16_regular : FluentIcons.building_16_regular,
                  color: AppColors.white,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.designForTitle(title),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(FluentIcons.chevron_down_16_regular, color: AppColors.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppFonts.headlineSmall,
        fontWeight: FontWeight.bold,
        color: context.colors.primary,
      ),
    );
  }

  Widget _buildAiCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _buildComingSoonDialog(context),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF1E2A40)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                FluentIcons.sparkle_24_filled,
                size: 100,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    FluentIcons.sparkle_24_filled,
                    color: AppColors.gold,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.discoverStyleAI,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFonts.headlineMedium,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.answerQuestionsForAI,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: AppFonts.bodyMedium,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text(
                      l10n.startExperience,
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.gold,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, color: context.colors.primary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: context.colors.textSecondary,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: context.colors.background,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(FluentIcons.sparkle_24_filled, color: AppColors.gold, size: 40),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.aiAssistant,
              style: TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.aiFeatureUnderDevelopment,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.okWaitingForIt,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
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
