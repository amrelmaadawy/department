import 'package:equatable/equatable.dart';

import '../../domain/entities/finishing_order_entity.dart';

enum AiDesignStatus { initial, loading, success, failure }
enum PresetNotesStatus { initial, loading, success, failure }

class AiRoomDesignState extends Equatable {
  final int apartmentId;
  final int roomId;
  final double roomArea;
  final List<int> selectedMaterialIds;
  final double baseRoomCost;
  final double selectedMaterialsCost;
  final String? selectedStyle;
  final String notes;
  final AiDesignStatus status;
  final String? errorMessage;
  final FinishingOrderEntity? resultOrder;
  final List<String> presetNotes;
  final PresetNotesStatus presetNotesStatus;
  final int totalSubtypesCount;
  final int updateKey;

  const AiRoomDesignState({
    this.apartmentId = 0,
    this.roomId = 0,
    this.roomArea = 1.0,
    this.selectedMaterialIds = const [],
    this.baseRoomCost = 0.0,
    this.selectedMaterialsCost = 0.0,
    this.selectedStyle,
    this.notes = '',
    this.status = AiDesignStatus.initial,
    this.errorMessage,
    this.resultOrder,
    this.presetNotes = const [],
    this.presetNotesStatus = PresetNotesStatus.initial,
    this.totalSubtypesCount = 0,
    this.updateKey = 0,
  });

  double get expectedTotalCost => (baseRoomCost + selectedMaterialsCost) * roomArea;

  AiRoomDesignState copyWith({
    int? apartmentId,
    int? roomId,
    double? roomArea,
    List<int>? selectedMaterialIds,
    double? baseRoomCost,
    double? selectedMaterialsCost,
    String? selectedStyle,
    String? notes,
    AiDesignStatus? status,
    String? errorMessage,
    FinishingOrderEntity? resultOrder,
    List<String>? presetNotes,
    PresetNotesStatus? presetNotesStatus,
    int? totalSubtypesCount,
    int? updateKey,
  }) {
    return AiRoomDesignState(
      apartmentId: apartmentId ?? this.apartmentId,
      roomId: roomId ?? this.roomId,
      roomArea: roomArea ?? this.roomArea,
      selectedMaterialIds: selectedMaterialIds ?? this.selectedMaterialIds,
      baseRoomCost: baseRoomCost ?? this.baseRoomCost,
      selectedMaterialsCost: selectedMaterialsCost ?? this.selectedMaterialsCost,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resultOrder: resultOrder ?? this.resultOrder,
      presetNotes: presetNotes ?? this.presetNotes,
      presetNotesStatus: presetNotesStatus ?? this.presetNotesStatus,
      totalSubtypesCount: totalSubtypesCount ?? this.totalSubtypesCount,
      updateKey: updateKey ?? this.updateKey,
    );
  }

  @override
  List<Object?> get props => [
        apartmentId,
        roomId,
        roomArea,
        selectedMaterialIds,
        baseRoomCost,
        selectedMaterialsCost,
        selectedStyle,
        notes,
        status,
        errorMessage,
        resultOrder,
        presetNotes,
        presetNotesStatus,
        totalSubtypesCount,
        updateKey,
      ];
}
