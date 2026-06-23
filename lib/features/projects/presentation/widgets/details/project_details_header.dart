import 'dart:async';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/full_screen_gallery.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

class ProjectDetailsHeader extends StatefulWidget {
  final ProjectEntity project;
  final String heroTag;

  const ProjectDetailsHeader({
    super.key,
    required this.project,
    required this.heroTag,
  });

  @override
  State<ProjectDetailsHeader> createState() => _ProjectDetailsHeaderState();
}

class _ProjectDetailsHeaderState extends State<ProjectDetailsHeader> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.project.images.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= widget.project.images.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onUserInteraction() {
    // Reset timer when user manually swipes
    _autoPlayTimer?.cancel();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine back arrow direction based on RTL
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final backIcon = isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new;
    final images = widget.project.images.isNotEmpty
        ? widget.project.images
        : ['']; // Fallback to empty string for error builder

    return SliverAppBar(
      expandedHeight: context.screenHeight * 0.4,
      pinned: true,
      backgroundColor: context.colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 64,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.white.withValues(alpha: 0.85),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(backIcon, size: 20, color: context.colors.textPrimary),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Images PageView
            GestureDetector(
              onPanDown: (_) => _autoPlayTimer?.cancel(),
              onPanCancel: _onUserInteraction,
              onPanEnd: (_) => _onUserInteraction,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imagePath = images[index];
                  Widget imageWidget;
                  
                  if (imagePath.isNotEmpty) {
                    if (imagePath.startsWith('http')) {
                      imageWidget = AppCachedNetworkImage(
                        imageUrl: Uri.encodeFull(imagePath),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            _buildErrorImage(context),
                      );
                    } else {
                      imageWidget = Image.asset(imagePath, fit: BoxFit.cover);
                    }
                  } else {
                    imageWidget = _buildErrorImage(context);
                  }

                  final tag = index == 0 ? widget.heroTag : '${widget.heroTag}_$index';

                  return GestureDetector(
                    onTap: () {
                      FullScreenGallery.show(
                        context,
                        images: images,
                        initialIndex: index,
                        heroTagPrefix: widget.heroTag,
                      );
                    },
                    child: Hero(
                      tag: tag,
                      child: imageWidget,
                    ),
                  );
                },
              ),
            ),

            // Top Gradient to ensure buttons are visible
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
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Gradient to ensure dots are visible
            if (images.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Dots Indicator
            if (images.length > 1)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    final isActive = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: isActive ? 24 : 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? context.colors.gold
                            : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

            // White overlapping rounded corners
            Positioned(
              bottom: -1, // -1 to prevent rendering gap pixel
              left: 0,
              right: 0,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: const BorderRadius.vertical(
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

  Widget _buildErrorImage(BuildContext context) {
    return Container(
      color: context.colors.border,
      child: Center(
        child: Icon(
          FluentIcons.image_off_24_regular,
          size: 48,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
