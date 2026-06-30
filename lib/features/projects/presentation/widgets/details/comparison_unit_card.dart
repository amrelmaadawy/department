import 'package:flutter/material.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'unit/project_unit_card_image.dart';

class ComparisonUnitCard extends StatelessWidget {
  final ProjectUnitEntity unit;

  const ComparisonUnitCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: ProjectUnitCardImage(unit: unit),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Title
        Text(
          unit.unitNumber.isNotEmpty
              ? '${unit.title} - ${unit.unitNumber}'
              : unit.title,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
