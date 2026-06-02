import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_entity.dart';

class ProjectDetailsHeader extends StatelessWidget {
  final ProjectEntity project;
  final String heroTag;

  const ProjectDetailsHeader({
    super.key,
    required this.project,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    // Determine back arrow direction based on RTL
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final backIcon = isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0, // Removes Material 3 scrolling tint/shadow
      leadingWidth: 64,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.85),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(backIcon, size: 20, color: AppColors.textPrimary),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                FluentIcons.share_24_regular,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                FluentIcons.heart_24_regular,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: Image.asset(project.imagePath, fit: BoxFit.cover),
            ),
            // Gradient to ensure buttons are visible
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  ),
                ),
              ),
            ),
            // White overlapping rounded corners
            Positioned(
              bottom: -1, // -1 to prevent rendering gap pixel
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
