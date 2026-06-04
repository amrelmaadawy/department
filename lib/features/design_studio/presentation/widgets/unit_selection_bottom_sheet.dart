import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import '../cubit/design_context_cubit.dart';
import '../cubit/design_context_state.dart';

class UnitSelectionBottomSheet extends StatelessWidget {
  const UnitSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DesignContextCubit>();
    final units = cubit.getMockOwnedUnits();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.background,
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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'اختر الوحدة المراد تصميمها',
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Units List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: units.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return _buildUnitItem(context, units[index]);
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSpacing.sm),

          // Custom Area Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: _buildCustomAreaItem(context),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildUnitItem(BuildContext context, ProjectUnitEntity unit) {
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
              color: isSelected ? AppColors.gold.withValues(alpha: 0.1) : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.border.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Small Image/Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    image: DecorationImage(
                      image: AssetImage(unit.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                          color: isSelected ? AppColors.gold : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'المساحة: ${unit.area} م²',
                        style: const TextStyle(
                          fontSize: AppFonts.bodySmall,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(FluentIcons.checkmark_circle_24_filled, color: AppColors.gold),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomAreaItem(BuildContext context) {
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
              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(FluentIcons.ruler_24_regular, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مساحة تقديرية (بدون وحدة)',
                        style: TextStyle(
                          fontSize: AppFonts.bodyLarge,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'للحصول على تقدير تكلفة مبدئي فقط',
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(FluentIcons.checkmark_circle_24_filled, color: AppColors.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
