import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_state.dart';

import 'package:apartment/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';

class MyPropertiesSection extends StatelessWidget {
  const MyPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final soldUnits = state.profile.apartments
              .where((u) => u.status.isUnavailable || u.status == UnitStatus.owned)
              .toList();

          if (soldUnits.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(FluentIcons.home_checkmark_24_filled, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.myProperties,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: soldUnits.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final unit = soldUnits[index];
                    return _OwnedUnitCard(unit: unit);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          );
        }
        
        if (state is ProfileLoading || state is ProfileInitial) {
          return const _MyPropertiesShimmer();
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _MyPropertiesShimmer extends StatelessWidget {
  const _MyPropertiesShimmer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: [
              Icon(FluentIcons.home_checkmark_24_filled, color: context.colors.primary.withValues(alpha: 0.5)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.myProperties,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: context.colors.border.withValues(alpha: 0.5),
                highlightColor: context.colors.white.withValues(alpha: 0.5),
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
                          ),
                        ),
                      ),
                      // Details
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 120, height: 20, color: Colors.white),
                            const SizedBox(height: AppSpacing.sm),
                            Container(width: 80, height: 16, color: Colors.white),
                            const SizedBox(height: AppSpacing.sm),
                            Container(width: 60, height: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _OwnedUnitCard extends StatelessWidget {
  final ProjectUnitEntity unit;

  const _OwnedUnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
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
        width: 220,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.darkOverlay.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md),
                    ),
                    child: Hero(
                      tag: 'owned_unit_image_${unit.id}',
                      child: unit.imagePath.isEmpty
                          ? Container(
                              width: double.infinity,
                              color: context.colors.primary.withValues(alpha: 0.1),
                              child: Icon(Icons.image_not_supported,
                                  color: context.colors.textSecondary, size: 40),
                            )
                          : AppCachedNetworkImage(
                              imageUrl: Uri.encodeFull(unit.imagePath),
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                color: context.colors.primary.withValues(alpha: 0.1),
                                child: Icon(Icons.broken_image,
                                    color: context.colors.textSecondary),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.gold.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FluentIcons.key_16_filled,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'ملكك',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          unit.title,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          FluentIcons.arrow_left_16_regular,
                          color: context.colors.primary,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(FluentIcons.number_symbol_16_regular, size: 14, color: context.colors.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'وحدة: ${unit.unitNumber}',
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: AppFonts.bodySmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.ruler_16_regular,
                        size: 16,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${unit.area} م²',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: AppFonts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.building_16_regular,
                        size: 16,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit.locationTypeLabel.isNotEmpty ? unit.locationTypeLabel : 'وحدة سكنية',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: AppFonts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
