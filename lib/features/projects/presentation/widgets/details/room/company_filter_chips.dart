import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanyOption {
  final int? id; // -1 indicates "All", null indicates "General (No Company)"
  final String name;

  const CompanyOption({required this.id, required this.name});
}

class CompanyFilterChips extends StatelessWidget {
  final List<CompanyOption> companies;
  final int? selectedCompanyId; // -1 for All
  final ValueChanged<int?> onSelectCompany;

  const CompanyFilterChips({
    super.key,
    required this.companies,
    required this.selectedCompanyId,
    required this.onSelectCompany,
  });

  @override
  Widget build(BuildContext context) {
    if (companies.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        itemCount: companies.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final company = companies[index];
          final isSelected = selectedCompanyId == company.id;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onSelectCompany(company.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.gold.withValues(alpha: 0.15)
                    : context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.round),
                border: Border.all(
                  color: isSelected ? context.colors.gold : context.colors.border,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    company.id == -1
                        ? FluentIcons.apps_16_filled
                        : FluentIcons.building_shop_16_regular,
                    size: 16,
                    color: isSelected ? context.colors.gold : context.colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    company.name,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? context.colors.gold
                          : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
