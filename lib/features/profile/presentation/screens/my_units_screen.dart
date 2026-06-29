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
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                  height: 160,
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
                // Status Badge
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isSold ? context.colors.success.withValues(alpha: 0.9) : context.colors.gold.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Text(
                      unit.statusLabel,
                      style: TextStyle(
                        color: context.colors.white,
                        fontSize: AppFonts.bodySmall,
                        fontWeight: FontWeight.bold,
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
                Text(
                  'وحدة ${unit.unitNumber}',
                  style: TextStyle(
                    color: context.colors.gold,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  unit.title,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                            AppRouter.unitDetails,
                            extra: {
                              'unit': unit,
                              'heroTag': 'unit_${unit.id}',
                            },
                          );
                        },
                        icon: const Icon(
                          FluentIcons.building_24_regular,
                          size: 20,
                        ),
                        label: Text(AppLocalizations.of(context)!.details),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.gold,
                          foregroundColor: context.colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
