import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/network/cubit/network_cubit.dart';
import 'package:apartment/core/network/cubit/network_state.dart';

import '../cubit/packages_cubit.dart';
import '../cubit/packages_state.dart';
import '../widgets/package_card.dart';
import '../widgets/packages_shimmer_view.dart';

class PackagesScreen extends StatelessWidget {
  final ProjectUnitEntity unit;

  const PackagesScreen({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PackagesCubit>()..loadPackages(),
      child: PackagesView(unit: unit),
    );
  }
}

class PackagesView extends StatelessWidget {
  final ProjectUnitEntity unit;

  const PackagesView({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.selectPackageBtn,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        backgroundColor: context.colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
      ),
      body: BlocListener<NetworkCubit, NetworkState>(
        listener: (context, networkState) {
          if (networkState is NetworkOnline) {
            final s = context.read<PackagesCubit>().state;
            if (s is PackagesError || s is PackagesInitial) {
              context.read<PackagesCubit>().loadPackages();
            }
          }
        },
        child: BlocBuilder<PackagesCubit, PackagesState>(
          builder: (context, state) {
            if (state is PackagesLoading) {
              return const PackagesShimmerView();
            }
            if (state is PackagesError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<PackagesCubit>().loadPackages(),
              );
            }
            if (state is PackagesLoaded) {
              if (state.packages.isEmpty) {
                return _EmptyView();
              }
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      l10n.packageModeInfo,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...state.packages.map(
                    (package) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.xl,
                        left: AppSpacing.lg,
                        right: AppSpacing.lg,
                      ),
                      child: PackageCard(package: package, unit: unit),
                    ),
                  ),
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

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FluentIcons.error_circle_24_regular,
              size: 56,
              color: context.colors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(onPressed: onRetry, child: Text(l10n.retryLoad)),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.box_24_regular,
            size: 64,
            color: context.colors.border,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.noPackagesAvailable,
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
