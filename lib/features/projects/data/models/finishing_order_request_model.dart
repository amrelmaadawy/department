import '../../domain/entities/finishing_order_request_entity.dart';

class FinishingOrderRequestModel extends FinishingOrderRequestEntity {
  const FinishingOrderRequestModel({
    required super.apartmentId,
    required super.type,
    required super.isDraft,
    required super.style,
    required super.notes,
    required super.expectedTotalCost,
    required super.selections,
  });

  Map<String, dynamic> toJson() {
    return {
      'apartment_id': apartmentId,
      'type': type,
      'is_draft': isDraft,
      'style': style,
      'notes': notes,
      'expected_total_cost': expectedTotalCost,
      'selections': selections.map((selection) {
        return {
          'room_id': selection.roomId,
          'material_ids': selection.materialIds,
        };
      }).toList(),
    };
  }

  factory FinishingOrderRequestModel.fromEntity(FinishingOrderRequestEntity entity) {
    return FinishingOrderRequestModel(
      apartmentId: entity.apartmentId,
      type: entity.type,
      isDraft: entity.isDraft,
      style: entity.style,
      notes: entity.notes,
      expectedTotalCost: entity.expectedTotalCost,
      selections: entity.selections,
    );
  }
}
