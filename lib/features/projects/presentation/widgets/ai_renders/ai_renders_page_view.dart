import 'package:apartment/core/theme/app_colors.dart';
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
          itemCount: renders.length * 4,
          itemBuilder: (context, index) {
            final urlIndex = index ~/ 4;
            final quadrantIndex = index % 4;
            final url = renders[urlIndex];

            Alignment getQuadrantAlignment(int quadrant) {
              switch (quadrant) {
                case 0: return const Alignment(-1.0, -1.0); // Top Left
                case 1: return const Alignment(1.0, -1.0);  // Top Right
                case 2: return const Alignment(-1.0, 1.0);  // Bottom Left
                case 3: return const Alignment(1.0, 1.0);   // Bottom Right
                default: return Alignment.center;
              }
            }

            Alignment getLoaderAlignment(int quadrant) {
              switch (quadrant) {
                case 0: return const Alignment(-0.5, -0.5); // Top Left
                case 1: return const Alignment(0.5, -0.5);  // Top Right
                case 2: return const Alignment(-0.5, 0.5);  // Bottom Left
                case 3: return const Alignment(0.5, 0.5);   // Bottom Right
                default: return Alignment.center;
              }
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: ClipRect(
                        child: Transform.scale(
                          scale: 2.0,
                          alignment: getQuadrantAlignment(quadrantIndex),
                          child: AppCachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder: (context, url, downloadProgress) {
                              return Align(
                                alignment: getLoaderAlignment(quadrantIndex),
                                child: Transform.scale(
                                  scale: 0.5,
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
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Align(
                              alignment: getLoaderAlignment(quadrantIndex),
                              child: Transform.scale(
                                scale: 0.5,
                                child: const Icon(FluentIcons.image_off_24_regular, size: 64, color: AppColors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (renders.length * 4 > 1)
          Positioned(
            bottom: AppSpacing.xl,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: List.generate(
                renders.length * 4,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentIndex == index ? AppSpacing.lg : AppSpacing.sm,
                  height: AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? context.colors.primary : context.colors.border.withValues(alpha: 0.5),
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
