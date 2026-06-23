import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_extension.dart';

class AiRendersPageView extends StatelessWidget {
  final List<String> renders;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const AiRendersPageView({
    super.key,
    required this.renders,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          itemCount: renders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: AppCachedNetworkImage(
                    imageUrl: renders[index],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Center(
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            strokeWidth: 3,
                            color: context.colors.primary,
                            backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(FluentIcons.image_off_24_regular, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (renders.length > 1)
          Positioned(
            bottom: AppSpacing.xl,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                renders.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  width: currentIndex == index ? AppSpacing.lg : AppSpacing.sm,
                  height: AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? context.colors.primary : context.colors.border,
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
