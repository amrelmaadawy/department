import 'package:apartment/features/projects/presentation/cubit/comparison_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'unit_comparison_sheet.dart';

class UnitComparisonBar extends StatelessWidget {
  final List<ProjectUnitEntity> selectedUnits;

  const UnitComparisonBar({super.key, required this.selectedUnits});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canCompare = selectedUnits.length >= 2;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.unitsSelected(selectedUnits.length.toString()),
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.selectUnitsToCompare,
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selectedUnits.isNotEmpty)
              TextButton(
                onPressed: () => context.read<ComparisonCubit>().clearSelection(),
                child: Text(
                  l10n.clearComparison,
                  style: TextStyle(
                    color: context.colors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton(
              onPressed: canCompare
                  ? () {
                      UnitComparisonSheet.show(context, selectedUnits);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.white,
                disabledBackgroundColor: context.colors.border,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: canCompare ? 4 : 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.compareNow,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(FluentIcons.arrow_right_24_regular, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
