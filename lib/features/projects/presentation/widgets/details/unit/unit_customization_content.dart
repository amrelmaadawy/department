import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/services/analytics/analytics_service.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/error_state_view.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/utils/package_helper.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/unit_details_cubit.dart';
import '../room/room_details_page.dart';
import 'unit_customization_banners.dart';
import 'unit_customization_shimmer.dart';
import 'wizard_progress_header.dart';
import 'package:apartment/features/customer_journey/presentation/widgets/reservation_expired_bottom_sheet.dart';

class UnitCustomizationContent extends StatefulWidget {
  final ProjectUnitEntity initialUnit;
  final FinishingPackageEntity? selectedPackage;

  const UnitCustomizationContent({
    super.key,
    required this.initialUnit,
    this.selectedPackage,
  });

  @override
  State<UnitCustomizationContent> createState() => _UnitCustomizationContentState();
}

class _UnitCustomizationContentState extends State<UnitCustomizationContent> {
  bool _packageApplied = false;

  @override
  void initState() {
    super.initState();
    final id = int.tryParse(widget.initialUnit.id) ?? 0;
    if (id > 0) {
      sl<DesignContextCubit>().loadHybridDraft(id);
      if (sl.isRegistered<AnalyticsService>()) sl<AnalyticsService>().logEvent('journey_resumed_from_unit_details', parameters: {'unit_id': id});
    }
  }

  @override
  void dispose() {
    final id = int.tryParse(widget.initialUnit.id) ?? 0;
    if (id > 0) {
      sl<DesignContextCubit>().syncDraftOnExit(id);
      if (sl.isRegistered<AnalyticsService>()) sl<AnalyticsService>().logEvent('journey_abandoned_at_step', parameters: {'step': 'customization', 'unit_id': id});
    }
    super.dispose();
  }

  bool _isExpired(String m) => m.contains('انتهت صلاحية') || m.contains('RESERVATION_EXPIRED') || m.contains('expired');

  void _applyPackageOnce(ProjectUnitEntity unit) {
    if (widget.selectedPackage == null || _packageApplied || unit.rooms.isEmpty) return;
    _packageApplied = true;
    PackageHelper.applyPackageToRooms(unit, widget.selectedPackage!);
  }

  void _onSyncStateChange(BuildContext context, DesignContextState state) {
    if (state.syncMessage == null) return;
    final msg = state.syncMessage == 'draftRestoredMessage'
        ? 'تم استرجاع آخر اختيارات قمت بها لهذه الوحدة'
        : (state.syncMessage == 'offlineDraftMessage' ? 'أنت تعمل حالياً دون اتصال، سيتم مزامنة اختياراتك عند عودة الاتصال' : state.syncMessage!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: state.isOffline ? Colors.orange : Colors.green, duration: const Duration(seconds: 4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPackage = widget.selectedPackage;
    return BlocListener<DesignContextCubit, DesignContextState>(
      bloc: sl<DesignContextCubit>(),
      listenWhen: (prev, curr) => prev.syncMessage != curr.syncMessage && curr.syncMessage != null,
      listener: _onSyncStateChange,
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: BlocConsumer<UnitDetailsCubit, UnitDetailsState>(
          listenWhen: (prev, curr) => curr is UnitDetailsError || ((prev.unit == null || prev.unit!.rooms.isEmpty) && (curr.unit != null && curr.unit!.rooms.isNotEmpty)),
          listener: (context, state) {
            if (state is UnitDetailsError && _isExpired(state.message)) {
              ReservationExpiredBottomSheet.show(context, unitNumber: widget.initialUnit.unitNumber);
            } else if (state.unit != null) {
              _applyPackageOnce(state.unit!);
            }
          },
          buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType || prev.unit != curr.unit,
          builder: (context, state) {
            if ((state is UnitDetailsLoading || state is UnitDetailsInitial) && (state.unit == null || state.unit!.rooms.isEmpty)) {
              return const UnitCustomizationShimmer();
            }
            if (state is UnitDetailsError && (state.unit == null || state.unit!.rooms.isEmpty)) {
              return ErrorStateView(message: state.message, onRetry: () => context.read<UnitDetailsCubit>().loadUnitDetails(int.tryParse(widget.initialUnit.id) ?? 0));
            }
            final currentUnit = state.unit ?? widget.initialUnit;
            if (currentUnit.rooms.isEmpty) return const UnitCustomizationShimmer();
            _applyPackageOnce(currentUnit);
            return DefaultTabController(
              length: currentUnit.rooms.length,
              child: Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return Column(
                    children: [
                      AnimatedBuilder(
                        animation: tabController,
                        builder: (context, child) => BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
                          buildWhen: (p, c) => p.completedRoomIds != c.completedRoomIds || p.roomCosts != c.roomCosts || p.unit != c.unit,
                          builder: (context, headerState) => WizardProgressHeader(
                            currentUnit: headerState.unit ?? currentUnit,
                            completedRoomIds: headerState.completedRoomIds,
                            currentRoomIndex: tabController.index,
                            roomCosts: headerState.roomCosts,
                            onRoomSelected: (idx) => tabController.animateTo(idx),
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      if (selectedPackage != null) PackageModeBanner(packageName: selectedPackage.name),
                      const AiCreditsBanner(),
                      Expanded(
                        child: TabBarView(
                          children: currentUnit.rooms.map((room) => RoomDetailsPage(
                            room: room,
                            unit: currentUnit,
                            tabController: tabController,
                            selectedPackage: selectedPackage,
                          )).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
