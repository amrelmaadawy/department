import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';

import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_bento_grid.dart';
import '../widgets/details/project_features_row.dart';

class UnitDetailsScreen extends StatelessWidget {
  final ProjectUnitEntity unit;
  final String heroTag;

  const UnitDetailsScreen({
    super.key,
    required this.unit,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              l10n.unitDetailsTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            backgroundColor: context.colors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: context.colors.textPrimary),
            pinned: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UnitFloorPlanViewer(
                  unit: unit,
                  heroTag: heroTag,
                ),
                const SizedBox(height: AppSpacing.lg),
                UnitBentoGrid(unit: unit),
                if (unit.extras.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      l10n.unitFeatures,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  ProjectFeaturesRow(features: unit.extras),
                ],
                const SizedBox(height: AppSpacing.md),
                UnitOverviewCard(unit: unit),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.priceTitle,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${formatter.format(unit.price).trim()} ${l10n.sar}',
                    style: TextStyle(
                      fontSize: AppFonts.headlineLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: l10n.startFinishingJourney,
                  onPressed: () {
                    context.push(
                      AppRouter.finishingGuide,
                      extra: {
                        'unit': unit,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
