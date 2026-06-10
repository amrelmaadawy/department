import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_cubit.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_state.dart';
import 'package:apartment/features/packages/presentation/widgets/package_card.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.readyPackagesScreenTitle,
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
      body: BlocBuilder<PackagesCubit, PackagesState>(
        builder: (context, state) {
          if (state is PackagesLoading) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.gold),
            );
          } else if (state is PackagesLoaded) {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    l10n.readyPackagesSubtitle,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                ...state.packages.map(
                  (package) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xl),
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
