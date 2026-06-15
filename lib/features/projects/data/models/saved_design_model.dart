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
  });

  factory SavedDesignModel.fromJson(Map<String, dynamic> json) {
    return SavedDesignModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      customerId: json['customer_id'] is int ? json['customer_id'] : int.tryParse(json['customer_id'].toString()) ?? 0,
      apartmentId: json['apartment_id'] is int ? json['apartment_id'] : int.tryParse(json['apartment_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      style: json['style'] ?? '',
      totalCost: json['total_cost'] is num
          ? (json['total_cost'] as num).toDouble()
          : double.tryParse(json['total_cost']?.toString() ?? '') ?? 0.0,
      imageUrls: json['images'] != null
          ? (json['images'] as List).map((image) => image['url']?.toString() ?? '').where((url) => url.isNotEmpty).toList()
          : [],
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
    };
  }
}
