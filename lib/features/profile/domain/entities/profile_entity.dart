import 'package:equatable/equatable.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';

import 'user_entity.dart';
import 'profile_statistics_entity.dart';
import 'ai_gallery_entity.dart';

class ProfileEntity extends Equatable {
  final UserEntity user;
  final ProfileStatisticsEntity statistics;
  final List<ProjectUnitEntity> apartments;
  final List<FinishingOrderEntity> recentOrders;
  final List<SavedDesignEntity> savedDesigns;
  final List<AiGalleryEntity> aiGallery;

  const ProfileEntity({
    required this.user,
    required this.statistics,
    required this.apartments,
    required this.recentOrders,
    required this.savedDesigns,
    required this.aiGallery,
  });

  @override
  List<Object?> get props => [
        user,
        statistics,
        apartments,
        recentOrders,
        savedDesigns,
        aiGallery,
      ];
}
