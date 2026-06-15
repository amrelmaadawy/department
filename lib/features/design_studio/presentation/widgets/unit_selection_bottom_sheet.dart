import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import '../cubit/design_context_cubit.dart';
import '../cubit/design_context_state.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class UnitSelectionBottomSheet extends StatelessWidget {
  const UnitSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<DesignContextCubit>();
    final units = cubit.getMockOwnedUnits();

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              l10n.selectUnitToDesign,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Units List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: units.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return _buildUnitItem(context, units[index]);
              },
            ),
          ),

          SizedBox(height: AppSpacing.lg),
          Divider(color: context.colors.border),
          SizedBox(height: AppSpacing.sm),

          // Custom Area Option
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _buildCustomAreaItem(context),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildUnitItem(BuildContext context, ProjectUnitEntity unit) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DesignContextCubit, DesignContextState>(
      builder: (context, state) {
        final isSelected = state.selectedUnit?.id == unit.id;

        return GestureDetector(
          onTap: () {
            context.read<DesignContextCubit>().selectUnit(unit);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.gold.withValues(alpha: 0.1) : context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected ? context.colors.gold : context.colors.border.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    image: unit.imagePath.isNotEmpty
                        ? DecorationImage(
                            image: unit.imagePath.startsWith('http')
                                ? NetworkImage(unit.imagePath) as ImageProvider
                                : AssetImage(unit.imagePath),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: unit.imagePath.isEmpty
                      ? Icon(FluentIcons.image_off_24_regular,
                          color: context.colors.textSecondary, size: 24)
                      : null,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.title,
                        style: TextStyle(
                          fontSize: AppFonts.bodyLarge,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? context.colors.gold : context.colors.primary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        l10n.areaSquareMeters(unit.area.toString()),
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(FluentIcons.checkmark_circle_24_filled, color: context.colors.gold),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAreaItem(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<DesignContextCubit, DesignContextState>(
      builder: (context, state) {
        final isSelected = state.selectedUnit == null;

        return GestureDetector(
          onTap: () {
            context.read<DesignContextCubit>().clearUnitSelection();
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.primary.withValues(alpha: 0.05) : context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected ? context.colors.primary : context.colors.border.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(FluentIcons.ruler_24_regular, color: context.colors.primary),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.estimatedAreaNoUnit,
                        style: TextStyle(
                          fontSize: AppFonts.bodyLarge,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? context.colors.primary : context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        l10n.forInitialCostEstimateOnly,
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(FluentIcons.checkmark_circle_24_filled, color: context.colors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
