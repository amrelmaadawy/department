import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

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
            child: unit.imagePath.isNotEmpty
                ? (unit.imagePath.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: Uri.encodeFull(unit.imagePath),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _buildImagePlaceholder(context),
                      )
                    : Image.asset(unit.imagePath, fit: BoxFit.cover))
                : _buildImagePlaceholder(context),
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

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          FluentIcons.image_off_24_regular,
          size: 24,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
