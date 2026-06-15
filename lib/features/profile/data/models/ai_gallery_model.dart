import '../../domain/entities/ai_gallery_entity.dart';

class AiGalleryModel extends AiGalleryEntity {
  const AiGalleryModel({
    required super.url,
    required super.orderId,
    required super.roomName,
    super.createdAt,
    super.projectName,
    super.unitName,
  });

  factory AiGalleryModel.fromJson(Map<String, dynamic> json) {
    return AiGalleryModel(
      url: json['url'] ?? '',
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      roomName: json['room_name'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      projectName: json['project_name'] ?? '',
      unitName: json['unit_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'order_id': orderId,
      'room_name': roomName,
      'created_at': createdAt?.toIso8601String(),
      'project_name': projectName,
      'unit_name': unitName,
    };
  }
}
