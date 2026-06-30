import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UnitCustomizationShimmer extends StatelessWidget {
  const UnitCustomizationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.grey800 : AppColors.grey300;
    final highlightColor = isDark ? AppColors.grey700 : AppColors.grey100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin: const EdgeInsets.only(left: AppSpacing.md),
                          width: 80,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              boxShadow: [
                BoxShadow(color: AppColors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 80, height: 12, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 8),
                          Container(width: 120, height: 24, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(4))),
                        ],
                      ),
                      Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: Container(height: 48, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppRadius.lg)))),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Container(height: 48, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppRadius.lg)))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
