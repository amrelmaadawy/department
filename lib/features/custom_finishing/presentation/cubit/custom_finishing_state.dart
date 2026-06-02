import 'package:equatable/equatable.dart';
import '../../domain/entities/material_category.dart';
import '../../domain/entities/material_entity.dart';

class CustomFinishingState extends Equatable {
  final MaterialCategory currentCategory;
  final Map<MaterialCategory, List<MaterialEntity>> availableMaterials;
  final Map<MaterialCategory, MaterialEntity> selectedMaterials;
  final double totalEstimatedCost;
  final bool isLoading;

  const CustomFinishingState({
    this.currentCategory = MaterialCategory.floors,
    this.availableMaterials = const {},
    this.selectedMaterials = const {},
    this.totalEstimatedCost = 144000.0, // Base starting cost mock
    this.isLoading = true,
  });

  CustomFinishingState copyWith({
    MaterialCategory? currentCategory,
    Map<MaterialCategory, List<MaterialEntity>>? availableMaterials,
    Map<MaterialCategory, MaterialEntity>? selectedMaterials,
    double? totalEstimatedCost,
    bool? isLoading,
  }) {
    return CustomFinishingState(
      currentCategory: currentCategory ?? this.currentCategory,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      selectedMaterials: selectedMaterials ?? this.selectedMaterials,
      totalEstimatedCost: totalEstimatedCost ?? this.totalEstimatedCost,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    currentCategory,
    availableMaterials,
    selectedMaterials,
    totalEstimatedCost,
    isLoading,
  ];
}
