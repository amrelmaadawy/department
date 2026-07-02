import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:apartment/core/widgets/full_screen_gallery.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'unit_status_badge.dart';

class ProjectUnitCardImage extends StatefulWidget {
  final ProjectUnitEntity unit;
  final bool isSelected;
  final bool isComparisonMode;

  const ProjectUnitCardImage({
    super.key,
    required this.unit,
    this.isSelected = false,
    this.isComparisonMode = false,
  });

  @override
  State<ProjectUnitCardImage> createState() => _ProjectUnitCardImageState();
}

class _ProjectUnitCardImageState extends State<ProjectUnitCardImage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.unit.images.where((e) => e.isNotEmpty).toList();
    if (images.isEmpty && widget.unit.imagePath.isNotEmpty) {
      images.add(widget.unit.imagePath);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (images.isNotEmpty)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final img = images[index];
              return img.startsWith('http')
                  ? AppCachedNetworkImage(
                      imageUrl: Uri.encodeFull(img),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _buildPlaceholder(context),
                    )
                  : Image.asset(img, fit: BoxFit.cover);
            },
          )
        else
          _buildPlaceholder(context),

        // Status Overlay
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: UnitStatusBadge(
            status: widget.unit.status,
            statusLabel: widget.unit.statusLabel,
            isOverlay: true,
            isCurrentUserUnit: widget.unit.isCurrentUserUnit,
          ),
        ),

        // Multi-Image Badge
        if (images.length > 1)
          Positioned(
            bottom: AppSpacing.sm,
            left: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FluentIcons.image_16_regular, size: 12, color: AppColors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${_currentPage + 1}/${images.length}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.labelSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Fullscreen preview button
        if (images.isNotEmpty)
          Positioned(
            bottom: AppSpacing.sm,
            right: AppSpacing.sm,
            child: GestureDetector(
              onTap: () => FullScreenGallery.show(
                context,
                images: images,
                initialIndex: _currentPage,
                heroTagPrefix: 'unit_card_${widget.unit.id}',
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FluentIcons.arrow_expand_16_regular,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

        // Comparison Checkbox Overlay
        if (widget.isComparisonMode)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.isSelected ? context.colors.gold : context.colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected ? context.colors.gold : context.colors.border,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  FluentIcons.checkmark_16_filled,
                  size: 14,
                  color: widget.isSelected ? context.colors.white : AppColors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        FluentIcons.image_off_24_regular,
        size: 32,
        color: context.colors.textSecondary,
      ),
    );
  }
}
