import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';



class ProjectFeaturesRow extends StatelessWidget {
  final List<String> features;

  const ProjectFeaturesRow({super.key, required this.features});

  IconData _getIconForFeature(String feature) {
    if (feature.contains('مسبح')) return FluentIcons.sim_24_regular;
    if (feature.contains('جيم') || feature.contains('لياقة')) return FluentIcons.dumbbell_24_regular;
    if (feature.contains('أمن') || feature.contains('حراسة') || feature.contains('مراقبة')) return FluentIcons.shield_24_regular;
    if (feature.contains('جراج') || feature.contains('مواقف') || feature.contains('سيارات')) return FluentIcons.vehicle_car_parking_16_regular;
    if (feature.contains('مصعد')) return FluentIcons.building_24_regular;
    if (feature.contains('دش مركزي') || feature.contains('ستالايت')) return FluentIcons.desktop_signal_24_regular;
    if (feature.contains('خزان') || feature.contains('مياه')) return FluentIcons.drop_24_regular;
    if (feature.contains('إنارة') || feature.contains('اضاءة') || feature.contains('توهج')) return FluentIcons.lightbulb_24_regular;
    if (feature.contains('دهانات') || feature.contains('تشطيب') || feature.contains('ديكور')) return FluentIcons.color_24_regular;
    if (feature.contains('تكييف') || feature.contains('مكيف')) return FluentIcons.weather_snowflake_24_regular;
    
    return FluentIcons.star_24_regular; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index == 0 ? 0 : AppSpacing.xl,
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: 75, maxWidth: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: context.colors.gold.withValues(alpha: 0.15),
                    child: Icon(
                      _getIconForFeature(feature),
                      color: context.colors.gold,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    feature,
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
