import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../widgets/details/unit/wizard_progress_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/unit_details_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import '../widgets/details/room/room_details_page.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import 'package:apartment/features/projects/data/datasources/local/room_design_cache_service.dart';

class UnitCustomizationScreen extends StatefulWidget {
  final ProjectUnitEntity unit;
  final FinishingPackageEntity? selectedPackage;

  const UnitCustomizationScreen({
    super.key,
    required this.unit,
    this.selectedPackage,
  });

  @override
  State<UnitCustomizationScreen> createState() => _UnitCustomizationScreenState();
}

class _UnitCustomizationScreenState extends State<UnitCustomizationScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.selectedPackage != null) {
      _applyPackageToRooms(widget.unit, widget.selectedPackage!);
    }
  }

  void _applyPackageToRooms(ProjectUnitEntity unit, FinishingPackageEntity package) {
    final cacheService = sl<RoomDesignCacheService>();
    for (final room in unit.rooms) {
      var items = package.itemsForRoom(room.type);
      if (items.isEmpty) {
        final normalizedType = room.type.trim().toLowerCase();
        if (normalizedType.contains('living') || normalizedType == 'livingroom') {
          items = package.itemsForRoom('salon');
          if (items.isEmpty) items = package.itemsForRoom('living_room');
          if (items.isEmpty) items = package.itemsForRoom('living');
        } else if (normalizedType.contains('salon') || normalizedType.contains('reception')) {
          items = package.itemsForRoom('living_room');
          if (items.isEmpty) items = package.itemsForRoom('salon');
          if (items.isEmpty) items = package.itemsForRoom('livingroom');
        } else if (normalizedType.contains('bed') || normalizedType.contains('master')) {
          items = package.itemsForRoom('bedroom');
          if (items.isEmpty) items = package.itemsForRoom('bed_room');
        } else if (normalizedType.contains('bath') || normalizedType.contains('guest') || normalizedType.contains('toilet')) {
          items = package.itemsForRoom('bathroom');
          if (items.isEmpty) items = package.itemsForRoom('bath_room');
        }
      }

      if (items.isNotEmpty) {
        final materialIds = items.map((e) => e.material.id).toList();
        final cost = items.fold<double>(0.0, (sum, item) => sum + item.material.finalUnitPrice);
        cacheService.saveRoomDesignProgress(
          roomId: room.id,
          selectedMaterialIds: materialIds,
          selectedMaterialsCost: cost,
          selectedStyle: null,
          notes: 'تم الاختيار من باقة ${package.name}',
          isCompleted: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitDetailsCubit>()
        ..loadUnitDetails(int.tryParse(widget.unit.id) ?? 0, initialUnit: widget.unit),
      child: _UnitCustomizationScreenContent(
        initialUnit: widget.unit,
        selectedPackage: widget.selectedPackage,
      ),
    );
  }
}

class _UnitCustomizationScreenContent extends StatefulWidget {
  final ProjectUnitEntity initialUnit;
  final FinishingPackageEntity? selectedPackage;

  const _UnitCustomizationScreenContent({
    required this.initialUnit,
    this.selectedPackage,
  });

  @override
  State<_UnitCustomizationScreenContent> createState() => _UnitCustomizationScreenContentState();
}

class _UnitCustomizationScreenContentState extends State<_UnitCustomizationScreenContent> {
  @override
  Widget build(BuildContext context) {
    final selectedPackage = widget.selectedPackage;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
        buildWhen: (previous, current) {
          return previous.runtimeType != current.runtimeType || previous.unit != current.unit;
        },
        builder: (context, state) {
          if (state is UnitDetailsLoading || state is UnitDetailsInitial) {
            if (state.unit == null || state.unit!.rooms.isEmpty) {
              return _buildFullPageShimmer(context);
            }
          }
          if (state is UnitDetailsError && (state.unit == null || state.unit!.rooms.isEmpty)) {
            return ErrorStateView(
              message: state.message,
              onRetry: () => context.read<UnitDetailsCubit>().loadUnitDetails(int.tryParse(widget.initialUnit.id) ?? 0),
            );
          }

          final currentUnit = state.unit ?? widget.initialUnit;
          if (currentUnit.rooms.isEmpty) {
            return _buildFullPageShimmer(context);
          }

          return DefaultTabController(
            length: currentUnit.rooms.length,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                return Column(
                  children: [
                    AnimatedBuilder(
                      animation: tabController,
                      builder: (context, child) {
                        return BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
                          buildWhen: (previous, current) =>
                              previous.completedRoomIds != current.completedRoomIds ||
                              previous.roomCosts != current.roomCosts ||
                              previous.unit != current.unit,
                          builder: (context, headerState) {
                            return WizardProgressHeader(
                              currentUnit: headerState.unit ?? currentUnit,
                              completedRoomIds: headerState.completedRoomIds,
                              currentRoomIndex: tabController.index,
                              roomCosts: headerState.roomCosts,
                              onRoomSelected: (index) {
                                tabController.animateTo(index);
                              },
                              onBack: () => Navigator.pop(context),
                            );
                          },
                        );
                      },
                    ),
                    // Package mode banner
                    if (selectedPackage != null)
                      _PackageModeBanner(packageName: selectedPackage.name),
                    Expanded(
                      child: TabBarView(
                        children: currentUnit.rooms.map((room) {
                          return RoomDetailsPage(
                            room: room,
                            unit: currentUnit,
                            tabController: tabController,
                            selectedPackage: selectedPackage,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullPageShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rooms Progress Bar Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => 
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                )
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
                  Container(width: double.infinity, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: AppSpacing.xl),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) => 
                        Container(margin: const EdgeInsets.only(left: AppSpacing.md), width: 80, height: 36, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.round)))
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
                      itemBuilder: (context, index) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Bar Shimmer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
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
                          Container(width: 80, height: 12, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 8),
                          Container(width: 120, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                        ],
                      ),
                      Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: Container(height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)))),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: Container(height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageModeBanner extends StatelessWidget {
  final String packageName;

  const _PackageModeBanner({required this.packageName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      color: context.colors.gold.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(FluentIcons.star_24_filled, size: 16, color: context.colors.gold),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              '${l10n.packageModeActiveLabel}: $packageName',
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                fontWeight: FontWeight.w600,
                color: context.colors.gold,
              ),
            ),
          ),
          Tooltip(
            message: l10n.packageModeInfo,
            child: Icon(FluentIcons.info_24_regular, size: 16, color: context.colors.gold),
          ),
        ],
      ),
    );
  }
}
