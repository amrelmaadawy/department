import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../widgets/details/unit/unit_bottom_actions.dart';
import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_specs_chips.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
              unit: widget.unit,
              heroTag: widget.heroTag,
              onZoomChanged: (isZoomed) {
                setState(() {
                  _isImageZoomed = isZoomed;
                });
              },
            ),
            UnitSpecsChips(unit: widget.unit),
            UnitOverviewCard(unit: widget.unit),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: UnitBottomActions(unit: widget.unit),
    );
  }
}
