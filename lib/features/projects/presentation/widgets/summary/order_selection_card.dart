import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/features/contracts/domain/entities/apartment_finishing_order_entity.dart';
import 'package:apartment/core/network/api_endpoints.dart';
import 'package:shimmer/shimmer.dart';

class OrderSelectionCard extends StatelessWidget {
  final ApartmentFinishingOrderEntity order;
  final bool isSelected;
  final VoidCallback onTap;
  final String fallbackRoomName;

  const OrderSelectionCard({
    super.key,
    required this.order,
    required this.isSelected,
    required this.onTap,
    required this.fallbackRoomName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // We expect the backend to provide a relative path that we need to prefix with the storage url.
    String? imageUrl = order.aiRenders.isNotEmpty ? order.aiRenders.first.url : null;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      // Import needed at top: import 'package:apartment/core/network/api_endpoints.dart';
      // Wait, since I'm doing this in the build method, I just need to make sure I add the import.
      imageUrl = '${ApiEndpoints.imageBaseUrl}$imageUrl';
    }
    final String roomName = order.aiRenders.isNotEmpty ? order.aiRenders.first.roomName : fallbackRoomName;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 160,
        margin: const EdgeInsets.only(left: AppSpacing.md), // Left margin for RTL spacing
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? context.colors.gold : context.colors.border.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg - 2)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl, // Assuming full URL or handled by network layer
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.grey300,
                              highlightColor: AppColors.grey100,
                              child: Container(color: AppColors.white),
                            ),
                            errorWidget: (context, url, error) => _buildFallbackImage(context, roomName),
                          )
                        : _buildFallbackImage(context, roomName),
                    
                    // Selection Checkmark
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.colors.gold,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            FluentIcons.checkmark_16_filled,
                            color: context.colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Price & Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'طلب #${order.id}',
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          order.totalCost,
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? context.colors.primary : context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.sar,
                          style: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            color: isSelected ? context.colors.gold : context.colors.textSecondary,
                          ),
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
    );
  }

  Widget _buildFallbackImage(BuildContext context, String title) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.image_24_regular, color: context.colors.primary, size: 32),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
