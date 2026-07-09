import '../../domain/entities/finishing_progress_stage_entity.dart';

class FinishingProgressStageModel extends FinishingProgressStageEntity {
  const FinishingProgressStageModel({
    required super.id,
    required super.name,
    required super.progressPercent,
    required super.status,
    required super.statusLabel,
    super.notes,
    required super.rooms,
    required super.images,
  });

  factory FinishingProgressStageModel.fromJson(Map<String, dynamic> json) {
    // Images can be either a List<String> or a List<Map> with {id, url, full_url}
    // Using Map.from() instead of 'is Map<String, dynamic>' to handle _InternalLinkedHashMap in isolates
    final rawImages = json['images'] as List<dynamic>? ?? [];
    final images = rawImages.map<String>((img) {
      if (img is String) return img;
      if (img is Map) {
        // Covers Map<String, dynamic>, _Map, _InternalLinkedHashMap in isolates
        return (img['full_url'] ?? img['url'] ?? '').toString();
      }
      return '';
    }).where((url) => url.isNotEmpty).toList();

    return FinishingProgressStageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      progressPercent: (json['progress_percent'] ?? 0).toInt(),
      status: json['status'] ?? 'pending',
      statusLabel: json['status_label'] ?? '',
      notes: json['notes'],
      rooms: List<String>.from(json['rooms'] ?? []),
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'progress_percent': progressPercent,
      'status': status,
      'status_label': statusLabel,
      'notes': notes,
      'rooms': rooms,
      'images': images,
    };
  }
}
