import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/utils/package_helper.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/unit_details_cubit.dart';
import '../widgets/details/room/room_details_page.dart';
import '../widgets/details/unit/unit_customization_banners.dart';
import '../widgets/details/unit/unit_customization_shimmer.dart';
import '../widgets/details/unit/wizard_progress_header.dart';

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
    sl<ProfileCubit>().loadProfileIfNeeded();
    if (widget.selectedPackage != null && widget.unit.rooms.isNotEmpty) {
      PackageHelper.applyPackageToRooms(widget.unit, widget.selectedPackage!);
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
              return const UnitCustomizationShimmer();
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
            return const UnitCustomizationShimmer();
          }

          if (selectedPackage != null) {
            PackageHelper.applyPackageToRooms(currentUnit, selectedPackage);
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
                          buildWhen: (prev, curr) =>
                              prev.completedRoomIds != curr.completedRoomIds ||
                              prev.roomCosts != curr.roomCosts ||
                              prev.unit != curr.unit,
                          builder: (context, headerState) {
                            return WizardProgressHeader(
                              currentUnit: headerState.unit ?? currentUnit,
                              completedRoomIds: headerState.completedRoomIds,
                              currentRoomIndex: tabController.index,
                              roomCosts: headerState.roomCosts,
                              onRoomSelected: (idx) => tabController.animateTo(idx),
                              onBack: () => Navigator.pop(context),
                            );
                          },
                        );
                      },
                    ),
                    if (selectedPackage != null)
                      PackageModeBanner(packageName: selectedPackage.name),
                    const AiCreditsBanner(),
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
}
