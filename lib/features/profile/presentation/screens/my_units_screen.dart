import 'dart:ui';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/error_state_view.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../../../../core/routes/app_router.dart';

class MyUnitsScreen extends StatelessWidget {
  const MyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          title: Text(
            l10n.myProperties,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            indicatorColor: context.colors.primary,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.bodyMedium),
            tabs: [
              Tab(text: l10n.ownedUnits),
              Tab(text: l10n.interestedUnits),
            ],
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return ErrorStateView(
                message: state.message,
                onRetry: () => context.read<ProfileCubit>().getProfile(),
              );
            }

            if (state is ProfileLoaded) {
              final soldUnits = state.profile.apartments.where((u) => u.status == UnitStatus.sold).toList();
              final availableUnits = state.profile.apartments.where((u) => u.status == UnitStatus.available).toList();

              return TabBarView(
                children: [
                  _UnitsList(units: soldUnits, isSold: true),
                  _UnitsList(units: availableUnits, isSold: false),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _UnitsList extends StatelessWidget {
  final List<ProjectUnitEntity> units;
  final bool isSold;

  const _UnitsList({required this.units, required this.isSold});

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FluentIcons.building_24_regular, size: 64, color: context.colors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.md),
            Text(
              isSold ? AppLocalizations.of(context)!.noOwnedUnits : AppLocalizations.of(context)!.noInterestedUnits,
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: units.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) {
        return _buildUnitCard(context, units[index]);
      },
    );
  }

  Widget _buildUnitCard(BuildContext context, ProjectUnitEntity unit) {
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
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    color: context.colors.border,
                    child: unit.imagePath.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: unit.imagePath,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) => Icon(
                              FluentIcons.building_24_regular,
                              size: 40,
                              color: context.colors.textSecondary,
                            ),
                          )
                        : Center(child: Icon(FluentIcons.home_24_regular, size: 40, color: context.colors.textSecondary)),
                  ),
                  // Glassmorphism Status Badge
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: (isSold ? context.colors.success : context.colors.gold)
                                .withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(AppRadius.round),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSold ? FluentIcons.checkmark_16_filled : FluentIcons.eye_16_filled,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                unit.statusLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFonts.bodySmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'وحدة ${unit.unitNumber}',
                          style: TextStyle(
                            color: context.colors.gold,
                            fontSize: AppFonts.bodySmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // The Bento Grid
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        _buildBentoSpec(
                          context,
                          icon: FluentIcons.ruler_20_regular,
                          label: 'المساحة',
                          value: '${unit.area} م²',
                        ),
                        _buildBentoDivider(context),
                        _buildBentoSpec(
                          context,
                          icon: FluentIcons.bed_20_regular,
                          label: 'الغرف',
                          value: unit.roomsCount.toString(),
                        ),
                        _buildBentoDivider(context),
                        _buildBentoSpec(
                          context,
                          icon: FluentIcons.building_20_regular,
                          label: 'الدور',
                          value: unit.floor.toString(),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Text Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.details,
                        style: TextStyle(
                          color: context.colors.gold,
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        FluentIcons.arrow_left_16_regular,
                        color: context.colors.gold,
                        size: 16,
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

  Widget _buildBentoSpec(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: context.colors.textSecondary),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: AppFonts.labelSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: context.colors.border.withValues(alpha: 0.5),
    );
  }
}
