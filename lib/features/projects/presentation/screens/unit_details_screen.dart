import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/details/unit/unit_bottom_actions.dart';
import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_specs_chips.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/details/unit/unit_rooms_section.dart';
import '../cubit/unit_details_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';

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
        ..loadUnitDetails(int.parse(widget.unit.id), initialUnit: widget.unit),
      child: _UnitDetailsScreenContent(
        heroTag: widget.heroTag,
        initialUnit: widget.unit,
      ),
    );
  }
}

class _UnitDetailsScreenContent extends StatefulWidget {
  final ProjectUnitEntity initialUnit;
  final String heroTag;

  const _UnitDetailsScreenContent({
    required this.initialUnit,
    required this.heroTag,
  });

  @override
  State<_UnitDetailsScreenContent> createState() => _UnitDetailsScreenContentState();
}

class _UnitDetailsScreenContentState extends State<_UnitDetailsScreenContent> {
  bool _isImageZoomed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
      builder: (context, state) {
        final currentUnit = state.unit ?? widget.initialUnit;

        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: AppBar(
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
           
          ),
          body: SingleChildScrollView(
            physics: _isImageZoomed ? const NeverScrollableScrollPhysics() : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                UnitFloorPlanViewer(
                  unit: currentUnit,
                  heroTag: widget.heroTag,
                  onZoomChanged: (isZoomed) {
                    setState(() {
                      _isImageZoomed = isZoomed;
                    });
                  },
                ),
                UnitSpecsChips(unit: currentUnit),
                UnitOverviewCard(unit: currentUnit),
                
                // Animated Rooms Section
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: state is UnitDetailsLoading && state.unit?.rooms.isEmpty == true
                      ? _buildRoomsShimmer(context)
                      : UnitRoomsSection(
                          rooms: currentUnit.rooms,
                          apartmentId: currentUnit.id,
                        ),
                ),
                
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          bottomNavigationBar: UnitBottomActions(
            unit: currentUnit,
            finishingCost: state.totalFinishingCost,
          ),
        );
      },
    );
  }

  Widget _buildRoomsShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: 150,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 14,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 60,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 50,
                            height: 14,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
