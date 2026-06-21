import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/details/unit/unit_bottom_actions.dart';
import '../widgets/details/unit/unit_floor_plan_viewer.dart';
import '../widgets/details/unit/unit_overview_card.dart';
import '../widgets/details/unit/unit_specs_chips.dart';
import '../widgets/details/unit/unit_rooms_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/unit_details_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';

import '../widgets/details/room/room_details_page.dart';

class UnitDetailsScreen extends StatefulWidget {
  final ProjectUnitEntity unit;
  final String heroTag;

  const UnitDetailsScreen({
    super.key,
    required this.unit,
    required this.heroTag,
  });

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UnitDetailsCubit>()
        ..loadUnitDetails(int.parse(widget.unit.id), initialUnit: widget.unit),
      child: _UnitDetailsScreenContent(
        heroTag: widget.heroTag,
        initialUnit: widget.unit,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.colors.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _UnitDetailsScreenContent extends StatefulWidget {
  final ProjectUnitEntity initialUnit;
  final String heroTag;

  const _UnitDetailsScreenContent({
    required this.initialUnit,
    required this.heroTag,
  });

  @override
  State<_UnitDetailsScreenContent> createState() => _UnitDetailsScreenContentState();
}

class _UnitDetailsScreenContentState extends State<_UnitDetailsScreenContent> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
      builder: (context, state) {
        final currentUnit = state.unit ?? widget.initialUnit;

        return DefaultTabController(
          length: currentUnit.rooms.isNotEmpty ? currentUnit.rooms.length : 1,
          child: Builder(
            builder: (context) {
              return Scaffold(
          backgroundColor: context.colors.background,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(
                    l10n.unitDetailsTitle,
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
                  pinned: true,
                  floating: true,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UnitFloorPlanViewer(
                        unit: currentUnit,
                        heroTag: widget.heroTag,
                      ),
                      UnitSpecsChips(unit: currentUnit),
                      UnitOverviewCard(unit: currentUnit),
                      
                      // Rooms Progress Bar
                      if (currentUnit.rooms.isNotEmpty)
                        UnitRoomsProgressBar(
                          rooms: currentUnit.rooms,
                          completedRoomIds: state.completedRoomIds,
                          onRoomSelected: (index) {
                            DefaultTabController.of(context).animateTo(index);
                          },
                        ),
                      SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
                if (currentUnit.rooms.isNotEmpty)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: context.colors.primary,
                        labelColor: context.colors.primary,
                        unselectedLabelColor: context.colors.textSecondary,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFonts.bodyMedium,
                        ),
                        tabs: currentUnit.rooms.map((room) {
                          return Tab(text: room.name);
                        }).toList(),
                      ),
                    ),
                  ),
              ];
            },
            body: currentUnit.rooms.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: currentUnit.rooms.map((room) {
                      return RoomDetailsPage(
                        room: room,
                        apartmentId: int.parse(currentUnit.id),
                        unitRooms: currentUnit.rooms,
                      );
                    }).toList(),
                  ),
          ),
          bottomNavigationBar: UnitBottomActions(
            unit: currentUnit,
            finishingCost: state.totalFinishingCost,
          ),
        );
        },
        ),
        );
      },
    );
  }
}
