import '../../domain/entities/customization_draft_entity.dart';

class CustomizationDraftModel extends CustomizationDraftEntity {
  const CustomizationDraftModel({
    required super.apartmentId,
    required super.customerId,
    required super.draftData,
    super.updatedAt,
  });

  factory CustomizationDraftModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;

    int parseId(dynamic val) {
      if (val is int) return val;
      if (val != null) return int.tryParse(val.toString()) ?? 0;
      return 0;
    }

    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    return CustomizationDraftModel(
      apartmentId: parseId(data['apartment_id'] ?? data['apartmentId']),
      customerId: parseId(data['customer_id'] ?? data['customerId']),
      draftData: data['draft_data'] is Map<String, dynamic>
          ? data['draft_data']
          : (data['draftData'] is Map<String, dynamic> ? data['draftData'] : {}),
      updatedAt: parseDate(data['updated_at'] ?? data['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apartment_id': apartmentId,
      'customer_id': customerId,
      'draft_data': draftData,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
