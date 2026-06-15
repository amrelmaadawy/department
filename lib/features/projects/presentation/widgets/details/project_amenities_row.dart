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
    if (amenity.contains('جيم') || amenity.contains('لياقة')) return FluentIcons.dumbbell_24_regular;
    if (amenity.contains('أمن') || amenity.contains('حراسة') || amenity.contains('مراقبة')) return FluentIcons.shield_24_regular;
    if (amenity.contains('جراج') || amenity.contains('مواقف') || amenity.contains('سيارات')) return FluentIcons.vehicle_car_parking_16_regular;
    if (amenity.contains('مصعد')) return FluentIcons.building_24_regular;
    if (amenity.contains('دش مركزي') || amenity.contains('ستالايت')) return FluentIcons.desktop_signal_24_regular;
    if (amenity.contains('خزان') || amenity.contains('مياه')) return FluentIcons.drop_24_regular;
    if (amenity.contains('إنارة') || amenity.contains('اضاءة') || amenity.contains('توهج')) return FluentIcons.lightbulb_24_regular;
    if (amenity.contains('دهانات') || amenity.contains('تشطيب') || amenity.contains('ديكور')) return FluentIcons.color_24_regular;
    if (amenity.contains('تكييف') || amenity.contains('مكيف')) return FluentIcons.weather_snowflake_24_regular;
    
    return FluentIcons.star_24_regular; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: amenities.asMap().entries.map((entry) {
          final index = entry.key;
          final amenity = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index == 0 ? 0 : AppSpacing.xl,
            ),
            child: SizedBox(
              width: 75, // Fixed width for each item to keep it uniform
              child: Column(
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
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
