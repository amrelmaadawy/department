import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_category_entity.dart';
import 'finishing_material_card.dart';

class FinishingOptionsSection extends StatelessWidget {
  final List<FinishingCategoryEntity> options;

  const FinishingOptionsSection({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: context.colors.textPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'خيارات التشطيب المتاحة',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _buildCategoryAccordion(context, options[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAccordion(BuildContext context, FinishingCategoryEntity category) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: context.colors.border,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Remove borders inside ExpansionTile
        ),
        child: ExpansionTile(
          collapsedIconColor: context.colors.primary,
          iconColor: context.colors.primary,
          title: Text(
            category.categoryName,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          childrenPadding: EdgeInsets.all(AppSpacing.md),
          children: category.subtypes.map((subtype) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtype.subtypeName.isNotEmpty && subtype.subtypeName != category.categoryName)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      subtype.subtypeName,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
                ...subtype.materials.map((material) => FinishingMaterialCard(material: material)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
