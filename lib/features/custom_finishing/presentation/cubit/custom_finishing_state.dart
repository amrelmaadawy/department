import 'package:equatable/equatable.dart';
import '../../domain/entities/material_category.dart';
import '../../domain/entities/material_entity.dart';

class CustomFinishingState extends Equatable {
  final MaterialCategory currentCategory;
  final Map<MaterialCategory, List<MaterialEntity>> availableMaterials;
  final Map<MaterialCategory, MaterialEntity> selectedMaterials;
  final double materialsCost;
  final double workmanshipCost;
  final double vatAmount;
  final double totalEstimatedCost;
  final bool isLoading;

  const CustomFinishingState({
    this.currentCategory = MaterialCategory.floors,
    this.availableMaterials = const {},
    this.selectedMaterials = const {},
    this.materialsCost = 0.0,
    this.workmanshipCost = 65000.0,
    this.vatAmount = 0.0,
    this.totalEstimatedCost = 0.0,
    this.isLoading = true,
  });

  CustomFinishingState copyWith({
    MaterialCategory? currentCategory,
    Map<MaterialCategory, List<MaterialEntity>>? availableMaterials,
    Map<MaterialCategory, MaterialEntity>? selectedMaterials,
    double? materialsCost,
    double? workmanshipCost,
    double? vatAmount,
    double? totalEstimatedCost,
    bool? isLoading,
  }) {
    return CustomFinishingState(
      currentCategory: currentCategory ?? this.currentCategory,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      selectedMaterials: selectedMaterials ?? this.selectedMaterials,
      materialsCost: materialsCost ?? this.materialsCost,
      workmanshipCost: workmanshipCost ?? this.workmanshipCost,
      vatAmount: vatAmount ?? this.vatAmount,
      totalEstimatedCost: totalEstimatedCost ?? this.totalEstimatedCost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    currentCategory,
    availableMaterials,
    selectedMaterials,
    materialsCost,
    workmanshipCost,
    vatAmount,
    totalEstimatedCost,
    isLoading,
  ];
}
