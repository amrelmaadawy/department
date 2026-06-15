import '../../domain/entities/finishing_order_entity.dart';

class FinishingOrderModel extends FinishingOrderEntity {
  const FinishingOrderModel({
    required super.id,
    required super.status,
    required super.statusLabel,
    required super.orderType,
    required super.orderTypeLabel,
    required super.style,
    required super.totalCost,
    required super.notes,
    required super.aiStatus,
    required super.aiStatusLabel,
    required super.aiRenders,
    required super.images,
  });

  factory FinishingOrderModel.fromJson(Map<String, dynamic> json) {
    return FinishingOrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      status: json['status'] ?? '',
      statusLabel: json['status_label'] ?? '',
      orderType: json['order_type'] ?? '',
      orderTypeLabel: json['order_type_label'] ?? '',
      style: json['style'] ?? '',
      totalCost: json['total_cost'] is num 
          ? (json['total_cost'] as num).toDouble() 
          : double.tryParse(json['total_cost']?.toString() ?? '') ?? 0.0,
      notes: json['notes'] ?? '',
      aiStatus: json['ai_status'] ?? '',
      aiStatusLabel: json['ai_status_label'] ?? '',
      aiRenders: json['ai_renders'] != null ? List<String>.from(json['ai_renders']) : [],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}
