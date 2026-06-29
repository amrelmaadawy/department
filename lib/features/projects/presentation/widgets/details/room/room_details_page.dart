import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../../core/di/injection_container.dart';

import '../../../../../home/domain/entities/unit_room_entity.dart';
import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../cubit/room_details_cubit.dart';
import '../../../cubit/room_details_state.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'finishing_options_section.dart';
import 'unified_room_bottom_bar.dart';

import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'category_tab_controller.dart';

class RoomDetailsPage extends StatefulWidget {
  final UnitRoomEntity room;
  final ProjectUnitEntity unit;
  final TabController tabController;
  final FinishingPackageEntity? selectedPackage;

  const RoomDetailsPage({
    super.key,
    required this.room,
    required this.unit,
    required this.tabController,
    this.selectedPackage,
  });

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> with AutomaticKeepAliveClientMixin {
  AiRoomDesignCubit? _aiRoomDesignCubit;
  final CategoryTabController _categoryTabController = CategoryTabController();

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    _categoryTabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    // When this tab becomes active, reload from cache in case other tabs modified it (e.g. Apply to All)
    if (widget.tabController.index == widget.unit.rooms.indexOf(widget.room)) {
      _aiRoomDesignCubit?.reloadFromCache();
    }
  }

  @override
  bool get wantKeepAlive => true; 
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    _aiRoomDesignCubit ??= sl<AiRoomDesignCubit>()
      ..init(
        apartmentId: int.tryParse(widget.unit.id) ?? 0,
        roomId: widget.room.id,
        roomArea: widget.room.area,
      );
      
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<RoomDetailsCubit>()..loadRoomDetails(widget.room),
        ),
        BlocProvider.value(
          value: _aiRoomDesignCubit!,
        ),
      ],
      child: BlocListener<AiRoomDesignCubit, AiRoomDesignState>(
        listenWhen: (previous, current) {
          return previous.selectedMaterialIds != current.selectedMaterialIds ||
                 previous.selectedMaterialsCost != current.selectedMaterialsCost ||
                 previous.selectedStyle != current.selectedStyle ||
                 previous.status != current.status;
        },
        listener: (context, state) {
          context.read<UnitDetailsCubit>().refreshFinishingCost();
        },
        child: Scaffold(
          backgroundColor: context.colors.background,
          body: BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _buildBody(state, context),
                      ),
                    ),
                  ),
                  if (state is RoomDetailsLoaded)
                    BlocSelector<UnitDetailsCubit, UnitDetailsState, double>(
                      selector: (unitState) => unitState.totalFinishingCost,
                      builder: (context, finishingCost) {
                        return UnifiedRoomBottomBar(
                          tabController: widget.tabController,
                          categoryTabController: _categoryTabController,
                          unit: widget.unit,
                          finishingCost: finishingCost,
                        );
                      },
                    )
                  else if (state is RoomDetailsLoading || state is RoomDetailsInitial)
                    _buildBottomBarShimmer(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(RoomDetailsState state, BuildContext context) {
    if (state is RoomDetailsLoading || state is RoomDetailsInitial) {
      return _buildShimmer(context);
    } else if (state is RoomDetailsError) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.withValues(alpha: 0.5)),
              const SizedBox(height: AppSpacing.md),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      );
    } else if (state is RoomDetailsLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FinishingOptionsSection(
            options: state.roomDetails.finishingOptions,
            unitRooms: widget.unit.rooms,
            currentRoom: widget.room,
            categoryTabController: _categoryTabController,
            isReadOnly: widget.selectedPackage != null,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Progress Bar Shimmer
            Container(
               width: double.infinity,
               height: 4,
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Tabs Shimmer
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) => 
                  Container(
                    margin: const EdgeInsets.only(left: AppSpacing.md),
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  )
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // Grid Shimmer
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.75,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
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
    );
  }
}
