import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/presentation/widgets/details/unit/unit_status_badge.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';

class MyUnitCard extends StatelessWidget {
  final ProjectUnitEntity unit;

  const MyUnitCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final int effectiveRoomsCount = unit.roomsCount > 0
        ? unit.roomsCount
        : (unit.rooms.isNotEmpty
            ? unit.rooms.length
            : (unit.bedrooms > 0
                ? unit.bedrooms
                : (unit.area > 0 ? (unit.area / 35).ceil().clamp(1, 10) : 1)));

    return GestureDetector(
      onTap: () {
        context.push(
          AppRouter.unitDetails,
          extra: {
            'unit': unit,
            'heroTag': 'unit_${unit.id}',
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              SizedBox(
                width: 115,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppRadius.lg),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: context.colors.border.withValues(alpha: 0.3),
                        child: unit.imagePath.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: unit.imagePath,
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) => Icon(
                                  FluentIcons.building_24_regular,
                                  size: 28,
                                  color: context.colors.textSecondary,
                                ),
                              )
                            : Icon(
                                FluentIcons.home_24_regular,
                                size: 28,
                                color: context.colors.textSecondary,
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Details Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title Area
                      Text(
                        unit.title,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Badges Row (Unit Number + Status)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (unit.unitNumber.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.gold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(AppRadius.round),
                                border: Border.all(
                                  color: context.colors.gold.withValues(alpha: 0.25),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'وحدة ${unit.unitNumber}',
                                style: TextStyle(
                                  color: context.colors.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          UnitStatusBadge(
                            status: unit.status,
                            statusLabel: unit.statusLabel,
                            isOverlay: false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Compact Specs Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: context.colors.border.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem(
                              context,
                              FluentIcons.ruler_16_regular,
                              '${unit.area} م²',
                            ),
                            Container(
                              width: 1,
                              height: 14,
                              color: context.colors.border,
                            ),
                            _buildSpecItem(
                              context,
                              FluentIcons.bed_16_regular,
                              '$effectiveRoomsCount غرف',
                            ),
                            Container(
                              width: 1,
                              height: 14,
                              color: context.colors.border,
                            ),
                            _buildSpecItem(
                              context,
                              FluentIcons.building_16_regular,
                              'الدور ${unit.floor}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Footer Details Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            l10n.details,
                            style: TextStyle(
                              color: context.colors.gold,
                              fontSize: AppFonts.labelSmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            FluentIcons.arrow_left_12_regular,
                            color: context.colors.gold,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.colors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
