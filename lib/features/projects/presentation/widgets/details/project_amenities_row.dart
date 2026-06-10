import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ProjectAmenitiesRow extends StatelessWidget {
  final List<String> amenities;

  const ProjectAmenitiesRow({super.key, required this.amenities});

  IconData _getIconForAmenity(String amenity) {
    if (amenity.contains('مسبح')) return FluentIcons.sim_24_regular;
    if (amenity.contains('جيم')) return FluentIcons.dumbbell_24_regular;
    if (amenity.contains('أمن')) return FluentIcons.shield_24_regular;
    if (amenity.contains('جراج')) {
      return FluentIcons.vehicle_car_parking_16_regular;
    }
    return FluentIcons.star_24_regular; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: amenities.map((amenity) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: context.colors.gold.withValues(alpha: 0.15),
                child: Icon(
                  _getIconForAmenity(amenity),
                  color: context.colors.gold,
                  size: 24,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                amenity,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
