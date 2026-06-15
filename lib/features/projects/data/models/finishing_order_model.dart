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
    super.projectName,
    super.unitName,
    super.createdAt,
    super.imageUrl,
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
      aiRenders: json['ai_renders'] != null 
          ? (json['ai_renders'] as List).map((item) {
              if (item is String) return item;
              if (item is Map) return item['url']?.toString() ?? '';
              return '';
            }).where((url) => url.isNotEmpty).toList()
          : [],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      projectName: json['apartment'] != null ? (json['apartment']['project_name'] ?? '') : '',
      unitName: json['apartment'] != null ? (json['apartment']['name'] ?? '') : '',
      createdAt: json['created_at'] ?? '',
      imageUrl: json['image_url'] ?? (json['images'] != null && (json['images'] as List).isNotEmpty ? json['images'][0] : ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'status_label': statusLabel,
      'order_type': orderType,
      'order_type_label': orderTypeLabel,
      'style': style,
      'total_cost': totalCost,
      'notes': notes,
      'ai_status': aiStatus,
      'ai_status_label': aiStatusLabel,
      'ai_renders': aiRenders,
      'images': images,
      'project_name': projectName,
      'unit_name': unitName,
      'created_at': createdAt,
      'image_url': imageUrl,
    };
  }
}
