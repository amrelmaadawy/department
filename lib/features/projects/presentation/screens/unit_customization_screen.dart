import 'package:apartment/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';

import '../widgets/details/unit/unit_rooms_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/unit_details_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import '../widgets/details/room/room_details_page.dart';

class UnitCustomizationScreen extends StatefulWidget {
  final ProjectUnitEntity unit;

  const UnitCustomizationScreen({
    super.key,
    required this.unit,
  });

  @override
  State<UnitCustomizationScreen> createState() => _UnitCustomizationScreenState();
}

class _UnitCustomizationScreenState extends State<UnitCustomizationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitDetailsCubit>()
        ..loadUnitDetails(int.parse(widget.unit.id), initialUnit: widget.unit),
      child: _UnitCustomizationScreenContent(
        initialUnit: widget.unit,
      ),
    );
  }
}

class _UnitCustomizationScreenContent extends StatefulWidget {
  final ProjectUnitEntity initialUnit;

  const _UnitCustomizationScreenContent({
    required this.initialUnit,
  });

  @override
  State<_UnitCustomizationScreenContent> createState() => _UnitCustomizationScreenContentState();
}

class _UnitCustomizationScreenContentState extends State<_UnitCustomizationScreenContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
      builder: (context, state) {
        final currentUnit = state.unit ?? widget.initialUnit;

        return DefaultTabController(
          length: currentUnit.rooms.isNotEmpty ? currentUnit.rooms.length : 1,
          child: Builder(
            builder: (context) {
              final tabController = DefaultTabController.of(context);
              return Scaffold(
                backgroundColor: context.colors.background,
                appBar: AppBar(
                  title: AnimatedBuilder(
                    animation: tabController,
                    builder: (context, child) {
                      final currentIndex = tabController.index;
                      final roomName = currentUnit.rooms.isNotEmpty 
                        ? currentUnit.rooms[currentIndex].name 
                        : 'الغرفة';
                      final totalRooms = currentUnit.rooms.length;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            roomName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppFonts.headlineSmall,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          if (totalRooms > 0)
                            Text(
                              'غرفة ${currentIndex + 1} من $totalRooms',
                              style: TextStyle(
                                fontSize: AppFonts.labelSmall,
                                color: context.colors.textSecondary,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  backgroundColor: context.colors.background,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: context.colors.textPrimary),
                ),
                body: currentUnit.rooms.isEmpty
                    ? _buildFullPageShimmer(context)
                    : Column(
                        children: [
                          UnitRoomsProgressBar(
                            rooms: currentUnit.rooms,
                            completedRoomIds: state.completedRoomIds,
                            onRoomSelected: (index) {
                              tabController.animateTo(index);
                            },
                          ),
                          Expanded(
                            child: TabBarView(
                              children: currentUnit.rooms.map((room) {
                                return RoomDetailsPage(
                                  room: room,
                                  unit: currentUnit,
                                  tabController: tabController,
                                  unitFinishingCost: state.totalFinishingCost,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        );
      },
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
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
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
                  SizedBox(height: AppSpacing.md),
                  Container(width: double.infinity, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                  SizedBox(height: AppSpacing.xl),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) => 
                        Container(margin: EdgeInsets.only(left: AppSpacing.md), width: 80, height: 36, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.round)))
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
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
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
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
                          SizedBox(height: 8),
                          Container(width: 120, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                        ],
                      ),
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: Container(height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)))),
                      SizedBox(width: AppSpacing.md),
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
