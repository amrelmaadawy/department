import '../../domain/entities/saved_design_entity.dart';

class SavedDesignModel extends SavedDesignEntity {
  const SavedDesignModel({
    required super.id,
    required super.customerId,
    required super.apartmentId,
    required super.name,
    required super.style,
    required super.totalCost,
    required super.imageUrls,
    super.projectName,
    super.unitName,
    super.roomName,
    super.createdAt,
    super.finishingOrderId,
  });

  factory SavedDesignModel.fromJson(Map<String, dynamic> json) {
    // Helper to extract order_id from image URL as a last resort
    int parseOrderIdFromUrl(String url) {
      try {
        final match = RegExp(r'order_(\d+)').firstMatch(url);
        if (match != null) {
          return int.tryParse(match.group(1) ?? '') ?? 0;
        }
      } catch (e) {
        // ignore
      }
      return 0;
    }

    final images = json['images'] != null
        ? (json['images'] as List).map((image) {
            if (image is String) return image;
            if (image is Map) return image['url']?.toString() ?? '';
            return '';
          }).where((url) => url.isNotEmpty).toList()
        : <String>[];
        
    final firstImageUrl = images.isNotEmpty ? images.first : '';
    return SavedDesignModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      customerId: json['customer_id'] is int ? json['customer_id'] : int.tryParse(json['customer_id'].toString()) ?? 0,
      apartmentId: json['apartment_id'] is int ? json['apartment_id'] : int.tryParse(json['apartment_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      style: json['style'] ?? '',
      totalCost: json['total_cost'] is num
          ? (json['total_cost'] as num).toDouble()
          : double.tryParse(json['total_cost']?.toString() ?? '') ?? 0.0,
      imageUrls: images,
      projectName: json['project_name'] ?? (json['apartment'] != null ? (json['apartment']['project_name'] ?? '') : ''),
      unitName: json['unit_name'] ?? (json['apartment'] != null ? (json['apartment']['name'] ?? '') : ''),
      roomName: json['room_name'] ?? (json['selections'] != null && (json['selections'] as List).isNotEmpty ? 'غرفة #${json['selections'][0]['room_id']}' : ''),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      finishingOrderId: json['finishing_order_id'] != null
          ? (json['finishing_order_id'] is int ? json['finishing_order_id'] : int.tryParse(json['finishing_order_id'].toString()) ?? 0)
          : (json['order_id'] != null 
              ? (json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id'].toString()) ?? 0)
              : parseOrderIdFromUrl(firstImageUrl)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'apartment_id': apartmentId,
      'name': name,
      'style': style,
      'total_cost': totalCost,
      'images': imageUrls.map((e) => {'url': e}).toList(),
      'project_name': projectName,
      'unit_name': unitName,
      'room_name': roomName,
      'created_at': createdAt?.toIso8601String(),
      'finishing_order_id': finishingOrderId,
    };
  }
}
