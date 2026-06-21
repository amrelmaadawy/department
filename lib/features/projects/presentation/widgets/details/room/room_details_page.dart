import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_state.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../../core/di/injection_container.dart';

import '../../../../../home/domain/entities/unit_room_entity.dart';
import '../../../cubit/room_details_cubit.dart';
import '../../../cubit/room_details_state.dart';
import '../../../cubit/unit_details_cubit.dart';
import 'finishing_options_section.dart';
import 'room_design_bottom_bar.dart';

import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';

class RoomDetailsPage extends StatefulWidget {
  final UnitRoomEntity room;
  final int apartmentId;
  final List<UnitRoomEntity> unitRooms;

  const RoomDetailsPage({
    super.key,
    required this.room,
    required this.apartmentId,
    required this.unitRooms,
  });

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; 

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<RoomDetailsCubit>()..loadRoomDetails(widget.room),
        ),
        BlocProvider(
          create: (context) => sl<AiRoomDesignCubit>()
            ..init(
              apartmentId: widget.apartmentId,
              roomId: widget.room.id,
              roomArea: widget.room.area,
            ),
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
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSpacing.md),
                    
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _buildBody(state, context),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    // RoomDesignBottomBar acts as the AI Design Action Area now.
                    if (state is RoomDetailsLoaded)
                      const RoomDesignBottomBar(),
                    SizedBox(height: AppSpacing.xxl),
                  ],
                ),
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
              SizedBox(height: AppSpacing.md),
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
      return FinishingOptionsSection(
        options: state.roomDetails.finishingOptions,
        unitRooms: widget.unitRooms,
        currentRoom: widget.room,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
