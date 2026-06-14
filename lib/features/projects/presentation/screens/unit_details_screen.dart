import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

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
  bool _isImageZoomed = false;

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
            actions: [
              IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
            ],
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
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: context.colors.gold,
                            ),
                          ),
                        )
                      : UnitRoomsSection(rooms: currentUnit.rooms),
                ),
                
                SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: UnitBottomActions(unit: currentUnit),
        );
      },
    );
  }
}
