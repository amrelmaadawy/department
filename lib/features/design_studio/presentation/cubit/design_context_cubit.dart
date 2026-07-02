import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/domain/usecases/get_customization_draft_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/save_customization_draft_use_case.dart';
import 'package:apartment/features/projects/data/datasources/local/room_design_cache_service.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/services/analytics/analytics_service.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/events/app_events.dart';
import 'design_context_state.dart';

class DesignContextCubit extends Cubit<DesignContextState> {
  final GetCustomizationDraftUseCase? getDraftUseCase;
  final SaveCustomizationDraftUseCase? saveDraftUseCase;
  final RoomDesignCacheService? cacheService;
  Timer? _debounceTimer;

  StreamSubscription? _contractSignedSub;

  DesignContextCubit({
    this.getDraftUseCase,
    this.saveDraftUseCase,
    this.cacheService,
  }) : super(const DesignContextState()) {
    _contractSignedSub = AppEvents.onContractSigned.listen((unitId) {
      if (state.selectedUnit != null && state.selectedUnit!.id == unitId) {
        final updatedUnit = state.selectedUnit!.copyWith(
          status: UnitStatus.sold,
          statusLabel: 'مباعة',
        );
        emit(state.copyWith(selectedUnit: updatedUnit));
      }
    });
  }

  void selectUnit(ProjectUnitEntity unit) {
    emit(state.copyWith(selectedUnit: unit, baseArea: unit.area));
  }

  void clearUnitSelection() {
    emit(state.copyWith(clearUnit: true, baseArea: 100.0));
  }

  void updateCustomArea(double area) {
    if (state.selectedUnit == null) emit(state.copyWith(baseArea: area));
  }

  void saveDraftSelection(int apartmentId, Map<String, dynamic> draftData) {
    final now = DateTime.now().toUtc();
    emit(state.copyWith(activeDraftData: draftData, lastUpdatedAt: now, isSyncing: true));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () => _executeRemoteSync(apartmentId, draftData));
  }

  Future<void> _executeRemoteSync(int apartmentId, Map<String, dynamic> draftData) async {
    if (saveDraftUseCase == null) return;
    final res = await saveDraftUseCase!(apartmentId, draftData);
    if (!isClosed) {
      res.fold(
        (failure) => emit(state.copyWith(isSyncing: false, isOffline: failure is NetworkFailure)),
        (draft) => emit(state.copyWith(isSyncing: false, isOffline: false, lastUpdatedAt: draft.updatedAt)),
      );
    }
  }

  Future<void> loadHybridDraft(int apartmentId) async {
    if (getDraftUseCase == null) return;
    emit(state.copyWith(isSyncing: true));
    final res = await getDraftUseCase!(apartmentId);
    if (isClosed) return;
    res.fold(
      (failure) {
        final isOffline = failure is NetworkFailure;
        emit(state.copyWith(
          isSyncing: false,
          isOffline: isOffline,
          syncMessage: isOffline ? 'offlineDraftMessage' : null,
        ));
      },
      (serverDraft) {
        final serverTime = serverDraft.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final localTime = state.lastUpdatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        if (serverTime.isAfter(localTime) || state.activeDraftData.isEmpty) {
          if (cacheService != null && serverDraft.draftData['rooms'] != null) {
            final rooms = serverDraft.draftData['rooms'] as Map<String, dynamic>;
            for (var entry in rooms.entries) {
              final roomId = int.tryParse(entry.key);
              if (roomId != null && entry.value is Map<String, dynamic>) {
                final roomData = entry.value as Map<String, dynamic>;
                cacheService!.saveRoomDesignProgress(
                  roomId: roomId,
                  selectedMaterialIds: List<int>.from(roomData['selectedMaterialIds'] ?? []),
                  selectedMaterialsCost: (roomData['selectedMaterialsCost'] ?? 0.0).toDouble(),
                  selectedStyle: roomData['selectedStyle'] as String?,
                  notes: roomData['notes'] as String? ?? '',
                  isCompleted: roomData['isCompleted'] == true,
                );
              }
            }
          }
          
          if (sl.isRegistered<AnalyticsService>()) {
            sl<AnalyticsService>().logEvent('customization_draft_recovered', parameters: {'apartment_id': apartmentId});
          }
          emit(state.copyWith(
            isSyncing: false,
            isOffline: false,
            draftRestored: true,
            activeDraftData: serverDraft.draftData,
            lastUpdatedAt: serverTime,
            syncMessage: 'draftRestoredMessage',
          ));
        } else {
          emit(state.copyWith(isSyncing: false, isOffline: false));
        }
      },
    );
  }

  Future<void> syncDraftOnExit(int apartmentId) async {
    if (_debounceTimer?.isActive == true) {
      _debounceTimer?.cancel();
      await _executeRemoteSync(apartmentId, state.activeDraftData);
    }
  }

  List<ProjectUnitEntity> getMockOwnedUnits() => [];

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _contractSignedSub?.cancel();
    return super.close();
  }
}
