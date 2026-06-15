import '../../domain/entities/profile_statistics_entity.dart';

class ProfileStatisticsModel extends ProfileStatisticsEntity {
  const ProfileStatisticsModel({
    required super.totalOrders,
    required super.completedOrders,
    required super.pendingOrders,
    required super.draftOrders,
    required super.totalSavedDesigns,
    required super.totalApartments,
    required super.totalAiImages,
    required super.totalSpent,
  });

  factory ProfileStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ProfileStatisticsModel(
      totalOrders: json['total_orders'] is int ? json['total_orders'] : int.tryParse(json['total_orders']?.toString() ?? '0') ?? 0,
      completedOrders: json['completed_orders'] is int ? json['completed_orders'] : int.tryParse(json['completed_orders']?.toString() ?? '0') ?? 0,
      pendingOrders: json['pending_orders'] is int ? json['pending_orders'] : int.tryParse(json['pending_orders']?.toString() ?? '0') ?? 0,
      draftOrders: json['draft_orders'] is int ? json['draft_orders'] : int.tryParse(json['draft_orders']?.toString() ?? '0') ?? 0,
      totalSavedDesigns: json['total_saved_designs'] is int ? json['total_saved_designs'] : int.tryParse(json['total_saved_designs']?.toString() ?? '0') ?? 0,
      totalApartments: json['total_apartments'] is int ? json['total_apartments'] : int.tryParse(json['total_apartments']?.toString() ?? '0') ?? 0,
      totalAiImages: json['total_ai_images'] is int ? json['total_ai_images'] : int.tryParse(json['total_ai_images']?.toString() ?? '0') ?? 0,
      totalSpent: json['total_spent'] is num ? (json['total_spent'] as num).toDouble() : double.tryParse(json['total_spent']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
      'draft_orders': draftOrders,
      'total_saved_designs': totalSavedDesigns,
      'total_apartments': totalApartments,
      'total_ai_images': totalAiImages,
      'total_spent': totalSpent,
    };
  }
}
