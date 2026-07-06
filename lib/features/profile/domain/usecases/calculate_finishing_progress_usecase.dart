import 'package:apartment/features/profile/domain/entities/profile_entity.dart';
import 'package:apartment/features/profile/domain/entities/unit_finishing_progress_entity.dart';

class CalculateFinishingProgressUseCase {
  List<UnitFinishingProgressEntity> call(ProfileEntity profile) {
    final List<UnitFinishingProgressEntity> progressList = [];

    for (final unit in profile.apartments) {
      // Find active finishing orders for this unit based on unitName or other heuristics
      // Since finishing orders might not have a direct unit_id in the entity, we match by unitName
      final unitOrders = profile.recentOrders
          .where((order) => order.unitName == unit.title || order.unitName.contains(unit.title))
          .toList();

      if (unitOrders.isEmpty) {
        // No orders yet
        progressList.add(
          UnitFinishingProgressEntity(
            unit: unit,
            activeOrder: null,
            progressPercentage: 0.0,
            currentStage: 'لم يبدأ',
            totalCost: 0.0,
            paidAmount: 0.0,
            remainingAmount: 0.0,
          ),
        );
        continue;
      }

      // Sort to get the most recent or active order
      unitOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final activeOrder = unitOrders.first;

      // Use real data from API if available, otherwise default safely
      double progress = 0.0;
      if (activeOrder.progressPercentage != null) {
        progress = activeOrder.progressPercentage! / 100.0;
      }
      
      String currentStage = activeOrder.statusLabel;
      final totalCost = activeOrder.totalCost;
      final paidAmount = activeOrder.paidAmount ?? 0.0;
      final remainingAmount = activeOrder.remainingAmount ?? totalCost;

      progressList.add(
        UnitFinishingProgressEntity(
          unit: unit,
          activeOrder: activeOrder,
          progressPercentage: progress,
          currentStage: currentStage,
          totalCost: totalCost,
          paidAmount: paidAmount,
          remainingAmount: remainingAmount,
        ),
      );
    }

    return progressList;
  }
}
