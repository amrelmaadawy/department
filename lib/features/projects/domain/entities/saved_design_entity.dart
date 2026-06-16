import 'package:equatable/equatable.dart';

class SavedDesignEntity extends Equatable {
  final int id;
  final int customerId;
  final int apartmentId;
  final String name;
  final String style;
  final double totalCost;
  final List<String> imageUrls;
  final String projectName;
  final String unitName;
  final String roomName;
  final DateTime? createdAt;
  final int finishingOrderId;

  const SavedDesignEntity({
    required this.id,
    required this.customerId,
    required this.apartmentId,
    required this.name,
    required this.style,
    required this.totalCost,
    required this.imageUrls,
    this.projectName = '',
    this.unitName = '',
    this.roomName = '',
    this.createdAt,
    this.finishingOrderId = 0,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        apartmentId,
        name,
        style,
        totalCost,
        imageUrls,
        projectName,
        unitName,
        roomName,
        createdAt,
        finishingOrderId,
      ];
}
