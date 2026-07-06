import 'package:equatable/equatable.dart';

class FinishingOrderEntity extends Equatable {
  final int id;
  final String status;
  final String statusLabel;
  final String orderType;
  final String orderTypeLabel;
  final String style;
  final double totalCost;
  final String notes;
  final String aiStatus;
  final String aiStatusLabel;
  final List<String> aiRenders;
  final List<String> images;
  final String projectName;
  final String unitName;
  final String createdAt;
  final String imageUrl;
 
  final double? paidAmount;
  final double? remainingAmount;
  final int? progressPercentage;

  final List<dynamic> materials;
  final List<dynamic> rooms;
  final Map<String, dynamic> rawJson;

  const FinishingOrderEntity({
    required this.id,
    required this.status,
    required this.statusLabel,
    required this.orderType,
    required this.orderTypeLabel,
    required this.style,
    required this.totalCost,
    required this.notes,
    required this.aiStatus,
    required this.aiStatusLabel,
    required this.aiRenders,
    required this.images,
    this.projectName = '',
    this.unitName = '',
    this.createdAt = '',
    this.imageUrl = '',
    this.paidAmount,
    this.remainingAmount,
    this.progressPercentage,
    this.materials = const [],
    this.rooms = const [],
    this.rawJson = const {},
  });

  @override
  List<Object?> get props => [
        id,
        status,
        statusLabel,
        orderType,
        orderTypeLabel,
        style,
        totalCost,
        notes,
        aiStatus,
        aiStatusLabel,
        aiRenders,
        images,
        projectName,
        unitName,
        createdAt,
        imageUrl,
        paidAmount,
        remainingAmount,
        progressPercentage,
        materials,
        rooms,
        rawJson,
      ];
}
