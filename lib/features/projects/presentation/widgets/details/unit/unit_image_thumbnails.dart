import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class UnitImageThumbnails extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onThumbnailTap;

  const UnitImageThumbnails({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    if (images.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onThumbnailTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected ? context.colors.primary : context.colors.border,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected 
                  ? [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ] 
                  : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md - 2),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
