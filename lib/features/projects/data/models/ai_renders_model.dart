import 'package:apartment/features/projects/domain/entities/ai_renders_entity.dart';


class AiRendersModel extends AiRendersEntity {
  const AiRendersModel({
    required super.orderId,
    required super.aiStatus,
    required super.aiStatusLabel,
    required super.aiRenders,
  });

  factory AiRendersModel.fromJson(Map<String, dynamic> json) {
    return AiRendersModel(
      orderId: json['order_id'] ?? 0,
      aiStatus: json['ai_status'] ?? '',
      aiStatusLabel: json['ai_status_label'] ?? '',
      aiRenders: json['ai_renders'] != null ? List<String>.from(json['ai_renders']) : [],
    );
  }
}
