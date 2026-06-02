import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_cubit.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_state.dart';
import 'package:apartment/features/packages/presentation/widgets/package_card.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackagesCubit()..loadPackages(),
      child: const PackagesView(),
    );
  }
}

class PackagesView extends StatelessWidget {
  const PackagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.readyPackagesScreenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: BlocBuilder<PackagesCubit, PackagesState>(
        builder: (context, state) {
          if (state is PackagesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          } else if (state is PackagesLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    l10n.readyPackagesSubtitle,
                    style: const TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ...state.packages.map(
                  (package) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: PackageCard(package: package),
                  ),
                ),
              ],
            );
          } else if (state is PackagesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
