import 'package:apartment/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../home/domain/entities/finishing_category_entity.dart';
import '../../../home/domain/entities/finishing_material_entity.dart';
import '../../../home/domain/entities/finishing_subtype_entity.dart';
import '../../../home/domain/entities/room_details_entity.dart';
import '../../../home/domain/entities/unit_room_entity.dart';
import '../cubit/room_details_cubit.dart';
import '../cubit/room_details_state.dart';
import '../widgets/details/room/finishing_options_section.dart';
import '../widgets/details/room/room_overview_card.dart';

class RoomDetailsScreen extends StatefulWidget {
  final UnitRoomEntity initialRoom;

  const RoomDetailsScreen({super.key, required this.initialRoom});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RoomDetailsCubit>()..loadRoomDetails(widget.initialRoom),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: Text(
            'تفاصيل الغرفة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          backgroundColor: context.colors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: context.colors.textPrimary),
        ),
        body: BlocBuilder<RoomDetailsCubit, RoomDetailsState>(
          builder: (context, state) {
            final room = state is RoomDetailsLoaded
                ? state.roomDetails.room
                : widget.initialRoom;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppSpacing.md),
                  RoomOverviewCard(room: room),
                  SizedBox(height: AppSpacing.xl),
                  
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildBody(state, context),
                  ),
                  
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
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
      return FinishingOptionsSection(options: state.roomDetails.finishingOptions);
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
