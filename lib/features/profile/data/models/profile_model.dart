import '../../domain/entities/profile_entity.dart';
import 'user_model.dart';
import 'profile_statistics_model.dart';
import 'ai_gallery_model.dart';
import 'package:apartment/features/home/data/models/project_unit_model.dart';
import 'package:apartment/features/projects/data/models/finishing_order_model.dart';
import 'package:apartment/features/projects/data/models/saved_design_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.user,
    required super.statistics,
    required super.apartments,
    required super.recentOrders,
    required super.savedDesigns,
    required super.aiGallery,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: UserModel.fromJson(json['user'] ?? {}),
      statistics: ProfileStatisticsModel.fromJson(json['statistics'] ?? {}),
      apartments: json['apartments'] != null
          ? (json['apartments'] as List).map((i) => ProjectUnitModel.fromJson(i)).toList()
          : [],
      recentOrders: json['recent_orders'] != null
          ? (json['recent_orders'] as List).map((i) => FinishingOrderModel.fromJson(i)).toList()
          : [],
      savedDesigns: json['saved_designs'] != null
          ? (json['saved_designs'] as List).map((i) => SavedDesignModel.fromJson(i)).toList()
          : [],
      aiGallery: json['ai_gallery'] != null
          ? (json['ai_gallery'] as List).map((i) => AiGalleryModel.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'statistics': (statistics as ProfileStatisticsModel).toJson(),
      'apartments': apartments.map((i) => (i as ProjectUnitModel).toJson()).toList(),
      'recent_orders': recentOrders.map((i) => (i as FinishingOrderModel).toJson()).toList(),
      'saved_designs': savedDesigns.map((i) => (i as SavedDesignModel).toJson()).toList(),
      'ai_gallery': aiGallery.map((i) => (i as AiGalleryModel).toJson()).toList(),
    };
  }
}
