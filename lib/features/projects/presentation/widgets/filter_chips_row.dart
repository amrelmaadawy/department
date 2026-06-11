import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const FilterChipsRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? context.colors.gold : context.colors.white,
                borderRadius: BorderRadius.circular(AppRadius.round),
                border: Border.all(
                  color: isSelected ? context.colors.gold : context.colors.border,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? context.colors.white : context.colors.textPrimary,
                  fontSize: AppFonts.bodySmall,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
