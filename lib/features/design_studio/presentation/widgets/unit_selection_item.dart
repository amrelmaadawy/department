import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/presentation/widgets/details/unit/unit_status_badge.dart';

import '../cubit/design_context_cubit.dart';
import '../cubit/design_context_state.dart';

class UnitSelectionItem extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitSelectionItem({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveImage = unit.images.isNotEmpty && unit.images.first.isNotEmpty
        ? unit.images.first
        : unit.imagePath;

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
            padding: const EdgeInsets.all(AppSpacing.md),
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
                    image: effectiveImage.isNotEmpty
                        ? DecorationImage(
                            image: effectiveImage.startsWith('http')
                                ? NetworkImage(effectiveImage) as ImageProvider
                                : AssetImage(effectiveImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: effectiveImage.isEmpty
                      ? Icon(FluentIcons.image_off_24_regular, color: context.colors.textSecondary, size: 24)
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
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
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            l10n.areaSquareMeters(unit.area.toString()),
                            style: TextStyle(
                              fontSize: AppFonts.bodySmall,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          UnitStatusBadge(
                            status: unit.status,
                            statusLabel: unit.statusLabel,
                            isOverlay: false,
                          ),
                        ],
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
}

class CustomAreaItem extends StatelessWidget {
  const CustomAreaItem({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(AppSpacing.md),
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
                const SizedBox(width: AppSpacing.md),
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
                      const SizedBox(height: 2),
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
