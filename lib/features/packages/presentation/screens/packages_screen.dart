import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../cubit/packages_cubit.dart';
import '../cubit/packages_state.dart';
import '../widgets/package_items_bottom_sheet.dart';

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
      body: BlocBuilder<PackagesCubit, PackagesState>(
        builder: (context, state) {
          if (state is PackagesLoading) {
            return Center(
              child: CircularProgressIndicator(color: context.colors.gold),
            );
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
                    child: _PackageCard(
                      package: package,
                      unit: unit,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final FinishingPackageEntity package;
  final ProjectUnitEntity unit;

  const _PackageCard({required this.package, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: context.colors.gold.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl), // Matches outer border
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary,
                        context.colors.primary.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Watermark icon
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Icon(
                          FluentIcons.premium_24_filled,
                          size: 140,
                          color: context.colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  package.name,
                                  style: TextStyle(
                                    fontSize: AppFonts.displaySmall,
                                    fontWeight: FontWeight.w900,
                                    color: context.colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            package.description,
                            style: TextStyle(
                              fontSize: AppFonts.bodyMedium,
                              color: context.colors.white.withValues(alpha: 0.75),
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          // Price row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: context.colors.gold.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.packageTotalPrice,
                                  style: TextStyle(
                                    fontSize: AppFonts.bodyMedium,
                                    color: context.colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      package.calculatedPrice
                                          .toStringAsFixed(0)
                                          .replaceAllMapped(
                                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                            (Match m) => '${m[1]},',
                                          ),
                                      style: TextStyle(
                                        fontSize: AppFonts.displayMedium,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.gold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'ر.س',
                                      style: TextStyle(
                                        fontSize: AppFonts.bodySmall,
                                        color: context.colors.gold.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Rooms summary (Chips)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.packageMaterialsTitle,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: package.roomTypes.map((roomType) {
                        final count = package.itemsForRoom(roomType).length;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.background,
                            borderRadius: BorderRadius.circular(AppRadius.round),
                            border: Border.all(
                              color: context.colors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getRoomIcon(roomType),
                                size: 16,
                                color: context.colors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${_translateRoomType(roomType)} ($count)',
                                style: TextStyle(
                                  fontSize: AppFonts.bodySmall,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    // View materials button (Secondary)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () =>
                            PackageItemsBottomSheet.show(context, package),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.primary,
                          side: BorderSide(color: context.colors.primary),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.box_24_regular,
                              size: 18,
                              color: context.colors.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                l10n.viewPackageMaterials,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: AppFonts.bodyMedium,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Select package button (Primary)
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(
                            AppRouter.unitCustomization,
                            extra: {
                              'unit': unit,
                              'selectedPackage': package,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.gold,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                l10n.selectPackageBtn,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: AppFonts.bodyMedium,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              FluentIcons.arrow_right_24_filled,
                              size: 18,
                              color: context.colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Premium Badge
        if (package.badge != null)
          Positioned(
            top: -16,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.gold, const Color(0xFFB8860B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.round),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: context.colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FluentIcons.star_16_filled,
                    size: 14,
                    color: context.colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    package.badge!,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      fontWeight: FontWeight.w800,
                      color: context.colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  IconData _getRoomIcon(String type) {
    switch (type.toLowerCase()) {
      case 'kitchen':
        return FluentIcons.food_24_regular;
      case 'salon':
      case 'living_room':
        return FluentIcons.tv_24_regular;
      case 'bedroom':
        return FluentIcons.bed_24_regular;
      case 'bathroom':
        return FluentIcons.drop_24_regular;
      default:
        return FluentIcons.home_24_regular;
    }
  }

  String _translateRoomType(String type) {
    const translations = {
      'kitchen': 'المطبخ',
      'salon': 'الصالون',
      'bedroom': 'غرفة النوم',
      'bathroom': 'الحمام',
      'balcony': 'البلكونة',
      'living_room': 'غرفة المعيشة',
    };
    return translations[type.toLowerCase()] ?? type;
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
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retryLoad),
            ),
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
