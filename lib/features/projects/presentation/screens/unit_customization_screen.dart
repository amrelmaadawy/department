import 'package:flutter/material.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../widgets/details/unit/unit_wizard_bottom_bar.dart';
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
                appBar: AppBar(
                  title: Text(
                    'رحلة التشطيب',
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
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Rooms Progress Bar at the top of the customization screen
                    if (currentUnit.rooms.isNotEmpty)
                      UnitRoomsProgressBar(
                        rooms: currentUnit.rooms,
                        completedRoomIds: state.completedRoomIds,
                        onRoomSelected: (index) {
                          DefaultTabController.of(context).animateTo(index);
                        },
                      ),
                    
                    Expanded(
                      child: currentUnit.rooms.isEmpty
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
                  ],
                ),
                bottomNavigationBar: UnitWizardBottomBar(
                  unit: currentUnit,
                  finishingCost: state.totalFinishingCost,
                  tabController: DefaultTabController.of(context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
