import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/cubit/network_state.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../widgets/my_unit_card.dart';

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
        body: BlocListener<NetworkCubit, NetworkState>(
          listener: (context, networkState) {
            if (networkState is NetworkOnline) {
              final s = context.read<ProfileCubit>().state;
              if (s is ProfileError || s is ProfileInitial) {
                context.read<ProfileCubit>().getProfile();
              }
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const _MyUnitsShimmer();
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
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: units.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return MyUnitCard(unit: units[index]);
      },
    );
  }
}

class _MyUnitsShimmer extends StatelessWidget {
  const _MyUnitsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: context.colors.border.withValues(alpha: 0.4),
          highlightColor: context.colors.white.withValues(alpha: 0.5),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 115,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(AppRadius.lg),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(width: 140, height: 16, color: Colors.white),
                        Container(width: double.infinity, height: 32, color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(width: 60, height: 12, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
