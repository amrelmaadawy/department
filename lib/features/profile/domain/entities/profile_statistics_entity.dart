import 'package:equatable/equatable.dart';

class ProfileStatisticsEntity extends Equatable {
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int draftOrders;
  final int totalSavedDesigns;
  final int totalApartments;
  final int totalAiImages;
  final double totalSpent;

  const ProfileStatisticsEntity({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.draftOrders,
    required this.totalSavedDesigns,
    required this.totalApartments,
    required this.totalAiImages,
    required this.totalSpent,
  });

  @override
  List<Object> get props => [
        totalOrders,
        completedOrders,
        pendingOrders,
        draftOrders,
        totalSavedDesigns,
        totalApartments,
        totalAiImages,
        totalSpent,
      ];
}
