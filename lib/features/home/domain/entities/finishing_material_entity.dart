import 'package:equatable/equatable.dart';

class FinishingMaterialEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String unit;
  final double finalPrice;
  final String? imageUrl;
  final int? companyId;
  final String? companyName;

  const FinishingMaterialEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.finalPrice,
    this.imageUrl,
    this.companyId,
    this.companyName,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        unit,
        finalPrice,
        imageUrl,
        companyId,
        companyName,
      ];
}
