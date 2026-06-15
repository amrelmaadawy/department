import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/finishing_material_entity.dart';
import '../../domain/entities/finishing_order_request_entity.dart';
import '../../domain/usecases/submit_finishing_order_use_case.dart';
import 'ai_room_design_state.dart';

class AiRoomDesignCubit extends Cubit<AiRoomDesignState> {
  final SubmitFinishingOrderUseCase submitFinishingOrderUseCase;

  AiRoomDesignCubit({
    required this.submitFinishingOrderUseCase,
  }) : super(const AiRoomDesignState());

  void init({required int apartmentId, required int roomId, required double roomArea, double baseRoomCost = 0.0}) {
    emit(state.copyWith(
      apartmentId: apartmentId,
      roomId: roomId,
      roomArea: roomArea > 0 ? roomArea : 1.0, // Default to 1 if area is 0 or invalid
      baseRoomCost: baseRoomCost,
      status: AiDesignStatus.initial,
    ));
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
  }

  void updateStyle(String? style) {
    emit(state.copyWith(selectedStyle: style));
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
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
        emit(state.copyWith(
          status: AiDesignStatus.success,
          resultOrder: order,
        ));
      },
    );
  }
}
