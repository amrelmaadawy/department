import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import '../cubit/unit_details_cubit.dart';
import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_bento_grid.dart';
import '../widgets/details/unit/unit_pricing_card.dart';
import '../widgets/details/unit/unit_rooms_list.dart';
import '../widgets/details/project_features_row.dart';
import '../widgets/details/unit/unit_details_bottom_bar.dart';

class UnitDetailsScreen extends StatefulWidget {
  final ProjectUnitEntity unit;
  final String heroTag;

  const UnitDetailsScreen({
    super.key,
    required this.unit,
    required this.heroTag,
  });

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitDetailsCubit>()
        ..loadUnitDetails(int.tryParse(widget.unit.id) ?? 0, initialUnit: widget.unit),
      child: _UnitDetailsScreenContent(heroTag: widget.heroTag),
    );
  }
}

class _UnitDetailsScreenContent extends StatelessWidget {
  final String heroTag;

  const _UnitDetailsScreenContent({required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final unit = context.select<UnitDetailsCubit, ProjectUnitEntity?>(
      (cubit) => cubit.state.unit,
    );

    if (unit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UnitFloorPlanViewer(unit: unit, heroTag: heroTag),
                const SizedBox(height: AppSpacing.lg),
                UnitBentoGrid(unit: unit),
                const SizedBox(height: AppSpacing.md),
                UnitPricingCard(unit: unit),
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
                const SizedBox(height: AppSpacing.lg),
                BlocSelector<UnitDetailsCubit, UnitDetailsState, bool>(
                  selector: (state) => state is UnitDetailsLoading,
                  builder: (context, isLoading) => UnitRoomsList(
                    unit: unit,
                    isLoading: isLoading,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: UnitDetailsBottomBar(unit: unit),
    );
  }
}
