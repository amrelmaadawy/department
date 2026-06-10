import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../widgets/details/unit/unit_bottom_actions.dart';
import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_specs_chips.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.unitDetailsTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        backgroundColor: context.colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        actions: [
          IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UnitFloorPlanViewer(unit: unit, heroTag: heroTag),
            UnitSpecsChips(unit: unit),
            UnitOverviewCard(unit: unit),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: UnitBottomActions(unit: unit),
    );
  }
}
