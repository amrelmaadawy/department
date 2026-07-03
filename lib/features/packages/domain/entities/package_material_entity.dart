import 'package:equatable/equatable.dart';

class PackageMaterialEntity extends Equatable {
  final int id;
  final String name;
  final String unit;
  final double priceMaterial;
  final double priceLabor;
  final double finalUnitPrice;
  final int? companyId;
  final String? companyName;
  final List<String> images;

  const PackageMaterialEntity({
    required this.id,
    required this.name,
    required this.unit,
    required this.priceMaterial,
    required this.priceLabor,
    required this.finalUnitPrice,
    this.companyId,
    this.companyName,
    required this.images,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    unit,
    priceMaterial,
    priceLabor,
    finalUnitPrice,
    companyId,
    companyName,
    images,
  ];
}
