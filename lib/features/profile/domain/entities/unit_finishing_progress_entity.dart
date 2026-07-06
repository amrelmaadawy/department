import 'package:equatable/equatable.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';

class UnitFinishingProgressEntity extends Equatable {
  final ProjectUnitEntity unit;
  final FinishingOrderEntity? activeOrder;
  final double progressPercentage;
  final String currentStage;
  final double totalCost;
  final double paidAmount;
  final double remainingAmount;

  const UnitFinishingProgressEntity({
    required this.unit,
    this.activeOrder,
    required this.progressPercentage,
    required this.currentStage,
    required this.totalCost,
    required this.paidAmount,
    required this.remainingAmount,
  });

  @override
  List<Object?> get props => [
        unit,
        activeOrder,
        progressPercentage,
        currentStage,
        totalCost,
        paidAmount,
        remainingAmount,
      ];
}
