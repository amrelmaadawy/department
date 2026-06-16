import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class FloorZonesTabs extends StatelessWidget {
  final List<String> zones;
  final String? selectedZone;
  final ValueChanged<String?> onZoneSelected;

  const FloorZonesTabs({
    super.key,
    required this.zones,
    required this.selectedZone,
    required this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'نطاق الأدوار',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              _buildZoneChip(
                context: context,
                zone: 'الكل',
                isSelected: selectedZone == null,
                onTap: () => onZoneSelected(null),
              ),
              ...zones.map((zone) {
                return _buildZoneChip(
                  context: context,
                  zone: zone,
                  isSelected: selectedZone == zone,
                  onTap: () => onZoneSelected(zone),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoneChip({
    required BuildContext context,
    required String zone,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md), // RTL support
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      context.colors.gold,
                      context.colors.gold.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.xl), // Pill shape for tabs
            border: Border.all(
              color: isSelected ? Colors.transparent : context.colors.border.withValues(alpha: 0.3),
              width: 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_circle_rounded,
                  color: context.colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                zone,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? context.colors.white : context.colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
