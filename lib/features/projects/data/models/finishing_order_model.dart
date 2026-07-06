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
    super.paidAmount,
    super.remainingAmount,
    super.progressPercentage,
    super.materials,
    super.rooms,
    super.rawJson,
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
      paidAmount: json['paid_amount'] is num 
          ? (json['paid_amount'] as num).toDouble() 
          : double.tryParse(json['paid_amount']?.toString() ?? ''),
      remainingAmount: json['remaining_amount'] is num 
          ? (json['remaining_amount'] as num).toDouble() 
          : double.tryParse(json['remaining_amount']?.toString() ?? ''),
      progressPercentage: json['progress_percentage'] is num 
          ? (json['progress_percentage'] as num).toInt() 
          : int.tryParse(json['progress_percentage']?.toString() ?? ''),
      materials: [], // We won't use flat materials anymore
      rooms: _parseRoomsData(json),
      rawJson: json,
    );
  }

  static List<dynamic> _parseRoomsData(Map<String, dynamic> json) {
    final cb = json['cost_breakdown'];
    if (cb == null) {
       // fallback if rooms array exists directly
       if (json['rooms'] != null && json['rooms'] is List) return List<dynamic>.from(json['rooms']);
       return [];
    }
    
    List<dynamic> parsedRooms = [];

    void processRoom(String roomName, dynamic roomData) {
      List<dynamic> roomMaterials = [];
      List<String> roomImages = [];
      String roomTotal = '';

      void extract(dynamic data) {
        if (data is List) {
          for (var item in data) extract(item);
        } else if (data is Map) {
          bool isMaterial = false;
          // If it's a material
          if (data.containsKey('company_name') || data.containsKey('material_name') || data.containsKey('name') || data.containsKey('price') || data.containsKey('final_price') || data.containsKey('total_price')) {
            if (!data.containsKey('room_total') || data.containsKey('name') || data.containsKey('company_name')) {
              isMaterial = true;
              roomMaterials.add(Map<String, dynamic>.from(data));
            }
          }
          if (data.containsKey('room_total')) roomTotal = data['room_total'].toString();
          
          if (!isMaterial) {
            // Try to find room design images
            if (data.containsKey('image') && data['image'] != null) roomImages.add(data['image'].toString());
            if (data.containsKey('image_url') && data['image_url'] != null) roomImages.add(data['image_url'].toString());
            if (data.containsKey('url') && data['url'] != null) roomImages.add(data['url'].toString());
            if (data.containsKey('images') && data['images'] is List) {
              roomImages.addAll(List<String>.from(data['images'].map((e) => e.toString())));
            }
          }

          data.forEach((k, v) {
            if (v is List || v is Map) extract(v);
          });
        }
      }

      extract(roomData);
      
      parsedRooms.add({
        'room_name': roomName,
        'room_total': roomTotal,
        'materials': roomMaterials,
        'images': roomImages.toSet().toList(), // unique images
      });
    }

    if (cb is Map) {
      cb.forEach((k, v) {
        processRoom(k, v);
      });
    } else if (cb is List) {
      for (int i = 0; i < cb.length; i++) {
        var item = cb[i];
        if (item is Map) {
           String rName = item['name']?.toString() ?? item['room_name']?.toString() ?? item['title']?.toString() ?? 'غرفة ${i + 1}';
           processRoom(rName, item);
        }
      }
    }
    
    return parsedRooms;
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
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (remainingAmount != null) 'remaining_amount': remainingAmount,
      if (progressPercentage != null) 'progress_percentage': progressPercentage,
      'materials': materials,
    };
  }
}
