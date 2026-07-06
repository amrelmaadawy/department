import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/contracts/domain/entities/cost_breakdown_entity.dart';
import 'package:apartment/core/network/api_endpoints.dart';

class CostBreakdownSheet extends StatelessWidget {
  final CostBreakdownEntity breakdown;

  const CostBreakdownSheet({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius:  const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                ),
              ),
            ),
            Row(
              children: [
                Icon(FluentIcons.receipt_24_regular, color: context.colors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'تفاصيل المواد والخامات',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: breakdown.rooms.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final room = breakdown.rooms[index];
                  return _buildRoomBreakdown(context, room);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomBreakdown(
    BuildContext context,
    CostBreakdownRoomEntity room,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg - 1)),
              border: Border(bottom: BorderSide(color: context.colors.border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  room.roomName,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: room.items.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: context.colors.border),
            itemBuilder: (context, index) {
              final item = room.items[index];
              
              String? imageUrl = item.imageUrl;
              if (imageUrl != null && !imageUrl.startsWith('http')) {
                imageUrl = '${ApiEndpoints.imageBaseUrl}$imageUrl';
              }

              return Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        color: context.colors.background,
                        border: Border.all(color: context.colors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm - 1),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? AppCachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                memCacheWidth: 150,
                                errorWidget: (context, url, error) => Icon(
                                  FluentIcons.image_24_regular,
                                  color: context.colors.textSecondary,
                                ),
                              )
                            : Icon(
                                FluentIcons.color_fill_24_regular,
                                color: context.colors.textSecondary,
                              ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.materialName,
                            style: TextStyle(
                              fontSize: AppFonts.bodyMedium,
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.quantity} ${item.unit}',
                            style: TextStyle(
                              fontSize: AppFonts.labelMedium,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
