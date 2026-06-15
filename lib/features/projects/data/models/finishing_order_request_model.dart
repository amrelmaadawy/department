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
    final map = {
      'apartment_id': apartmentId,
      'type': type,
      'is_draft': isDraft,
      'expected_total_cost': expectedTotalCost,
      'selections': selections.map((selection) {
        return {
          'room_id': selection.roomId,
          'material_ids': selection.materialIds,
        };
      }).toList(),
    };

    if (style.isNotEmpty) {
      map['style'] = style;
    }
    if (notes.isNotEmpty) {
      map['notes'] = notes;
    }

    return map;
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
