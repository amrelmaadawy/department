import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/finishing_material_entity.dart';
import '../../domain/entities/finishing_order_request_entity.dart';
import '../../domain/usecases/get_preset_notes_use_case.dart';
import '../../domain/usecases/submit_finishing_order_use_case.dart';
import '../../data/datasources/local/room_design_cache_service.dart';
import 'ai_room_design_state.dart';

class AiRoomDesignCubit extends Cubit<AiRoomDesignState> {
  final SubmitFinishingOrderUseCase submitFinishingOrderUseCase;
  final GetPresetNotesUseCase getPresetNotesUseCase;
  final RoomDesignCacheService cacheService;

  AiRoomDesignCubit({
    required this.submitFinishingOrderUseCase,
    required this.getPresetNotesUseCase,
    required this.cacheService,
  }) : super(const AiRoomDesignState());

  void init({required int apartmentId, required int roomId, required double roomArea, double baseRoomCost = 0.0}) {
    emit(state.copyWith(
      apartmentId: apartmentId,
      roomId: roomId,
      roomArea: roomArea > 0 ? roomArea : 1.0, // Default to 1 if area is 0 or invalid
      baseRoomCost: baseRoomCost,
      status: AiDesignStatus.initial,
    ));

    // Restore from cache if available
    final cachedData = cacheService.getRoomDesignProgress(roomId);
    if (cachedData != null) {
      final selectedMaterialIds = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
      final selectedMaterialsCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
      final selectedStyle = cachedData['selectedStyle'] as String?;
      final notes = cachedData['notes'] as String? ?? '';
      // isCompleted is saved but we derive it dynamically based on totalSubtypesCount anyway

      emit(state.copyWith(
        selectedMaterialIds: selectedMaterialIds,
        selectedMaterialsCost: selectedMaterialsCost,
        selectedStyle: selectedStyle,
        notes: notes,
      ));
    }

    if (state.presetNotes.isEmpty && state.presetNotesStatus != PresetNotesStatus.success) {
      _loadPresetNotes();
    }
  }

  void reloadFromCache() {
    final cachedData = cacheService.getRoomDesignProgress(state.roomId);
    if (cachedData != null) {
      final selectedMaterialIds = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
      final selectedMaterialsCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
      final selectedStyle = cachedData['selectedStyle'] as String?;
      final notes = cachedData['notes'] as String? ?? '';

      final bool idsChanged = selectedMaterialIds.length != state.selectedMaterialIds.length ||
          !selectedMaterialIds.toSet().containsAll(state.selectedMaterialIds) ||
          !state.selectedMaterialIds.toSet().containsAll(selectedMaterialIds);

      // Only emit if there is a change to prevent unnecessary rebuilds
      if (selectedMaterialsCost != state.selectedMaterialsCost || 
          idsChanged ||
          selectedStyle != state.selectedStyle ||
          notes != state.notes) {
        emit(state.copyWith(
          selectedMaterialIds: selectedMaterialIds,
          selectedMaterialsCost: selectedMaterialsCost,
          selectedStyle: selectedStyle,
          notes: notes,
        ));
      }
    }
  }

  Future<void> _loadPresetNotes() async {
    emit(state.copyWith(presetNotesStatus: PresetNotesStatus.loading));
    final result = await getPresetNotesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(presetNotesStatus: PresetNotesStatus.failure)),
      (notes) => emit(state.copyWith(
        presetNotesStatus: PresetNotesStatus.success,
        presetNotes: notes,
      )),
    );
  }

  void _autoSave() {
    final isCompleted = state.totalSubtypesCount > 0 && state.selectedMaterialIds.length >= state.totalSubtypesCount;
    cacheService.saveRoomDesignProgress(
      roomId: state.roomId,
      selectedMaterialIds: state.selectedMaterialIds,
      selectedMaterialsCost: state.selectedMaterialsCost,
      selectedStyle: state.selectedStyle,
      notes: state.notes,
      isCompleted: isCompleted,
    );
  }

  void setTotalSubtypesCount(int count) {
    if (state.totalSubtypesCount != count) {
      emit(state.copyWith(totalSubtypesCount: count));
      _autoSave();
    }
  }

  void toggleMaterial(FinishingMaterialEntity material, List<FinishingMaterialEntity> siblingMaterials) {
    final currentIds = List<int>.from(state.selectedMaterialIds);
    double newCost = state.selectedMaterialsCost;

    // Check if the material is already selected
    final isCurrentlySelected = currentIds.contains(material.id);

    // Remove any previously selected sibling materials from this subtype
    for (final sibling in siblingMaterials) {
      if (currentIds.contains(sibling.id)) {
        currentIds.remove(sibling.id);
        newCost -= sibling.finalPrice;
      }
    }

    // If it wasn't selected before, add it now (this effectively "toggles" or "selects")
    if (!isCurrentlySelected) {
      currentIds.add(material.id);
      newCost += material.finalPrice;
    }

    emit(state.copyWith(
      selectedMaterialIds: currentIds,
      selectedMaterialsCost: newCost,
    ));
    _autoSave();
  }

  void updateStyle(String? style) {
    emit(state.copyWith(selectedStyle: style));
    _autoSave();
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
    _autoSave();
  }

  Future<void> submitOrder() async {
    // Only style is required optionally according to user, but let's submit with whatever is selected
    emit(state.copyWith(status: AiDesignStatus.loading));

    final request = FinishingOrderRequestEntity(
      apartmentId: state.apartmentId,
      type: 'manual',
      isDraft: false,
      style: state.selectedStyle?.toLowerCase() ?? '',
      notes: state.notes,
      expectedTotalCost: state.expectedTotalCost,
      selections: [
        RoomSelectionEntity(
          roomId: state.roomId,
          materialIds: state.selectedMaterialIds,
        ),
      ],
    );

    final result = await submitFinishingOrderUseCase(request);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AiDesignStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (order) {
        cacheService.saveSubmittedAiDesignMaterials(
          state.roomId,
          state.selectedMaterialIds,
        );
        emit(state.copyWith(
          status: AiDesignStatus.success,
          resultOrder: order,
        ));
      },
    );
  }

  void applyMaterialToOtherRooms({
    required FinishingMaterialEntity material,
    required List<FinishingMaterialEntity> siblingMaterials,
    required List<int> targetRoomIds,
    required List<int> allOtherRoomIds,
  }) {
    for (final roomId in allOtherRoomIds) {
      if (roomId == state.roomId) continue;

      final cachedData = cacheService.getRoomDesignProgress(roomId);
      List<int> currentIds = [];
      double currentCost = 0.0;
      String? currentStyle;
      String currentNotes = '';
      bool isCompleted = false;

      if (cachedData != null) {
        currentIds = List<int>.from(cachedData['selectedMaterialIds'] ?? []);
        currentCost = (cachedData['selectedMaterialsCost'] ?? 0.0).toDouble();
        currentStyle = cachedData['selectedStyle'] as String?;
        currentNotes = cachedData['notes'] as String? ?? '';
        isCompleted = cachedData['isCompleted'] == true;
      }

      // Check if the material should be selected in the target room
      final shouldBeSelected = targetRoomIds.contains(roomId);
      final isCurrentlySelected = currentIds.contains(material.id);

      if (shouldBeSelected && !isCurrentlySelected) {
        // Remove any sibling materials first
        for (final sibling in siblingMaterials) {
          if (currentIds.contains(sibling.id)) {
            currentIds.remove(sibling.id);
            currentCost -= sibling.finalPrice; 
          }
        }
        // Add the new material
        currentIds.add(material.id);
        currentCost += material.finalPrice;
      } else if (!shouldBeSelected && isCurrentlySelected) {
        // Remove the material if it was deselected
        currentIds.remove(material.id);
        currentCost -= material.finalPrice;
      }

      cacheService.saveRoomDesignProgress(
        roomId: roomId,
        selectedMaterialIds: currentIds,
        selectedMaterialsCost: currentCost,
        selectedStyle: currentStyle,
        notes: currentNotes, 
        isCompleted: isCompleted,
      );
    }
    
    // Force UI to rebuild so it picks up the cache changes
    emit(state.copyWith(
      updateKey: state.updateKey + 1,
    ));
  }
}
