import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/material_category.dart';
import '../cubit/custom_finishing_cubit.dart';
import '../cubit/custom_finishing_state.dart';

class FinishingCategoryTabs extends StatelessWidget {
  const FinishingCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CustomFinishingCubit, CustomFinishingState>(
      buildWhen: (previous, current) =>
          previous.currentCategory != current.currentCategory,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: MaterialCategory.values.map((category) {
              final isSelected = state.currentCategory == category;
              return GestureDetector(
                onTap: () => context
                    .read<CustomFinishingCubit>()
                    .selectCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.gold, Color(0xFFE5B962)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: !isSelected ? AppColors.white : null,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : AppColors.border.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _getCategoryName(category, l10n),
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary.withValues(alpha: 0.6),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _getCategoryName(MaterialCategory category, AppLocalizations l10n) {
    switch (category) {
      case MaterialCategory.floors:
        return l10n.categoryFloors;
      case MaterialCategory.walls:
        return l10n.categoryWalls;
      case MaterialCategory.ceilings:
        return l10n.categoryCeilings;
      case MaterialCategory.doors:
        return l10n.categoryDoors;
      case MaterialCategory.review:
        return l10n.categoryReview;
    }
  }
}
