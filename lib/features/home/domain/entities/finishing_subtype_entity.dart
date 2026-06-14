import 'package:equatable/equatable.dart';
import 'finishing_material_entity.dart';

class FinishingSubtypeEntity extends Equatable {
  final int subtypeId;
  final String subtypeName;
  final List<FinishingMaterialEntity> materials;

  const FinishingSubtypeEntity({
    required this.subtypeId,
    required this.subtypeName,
    required this.materials,
  });

  @override
  List<Object?> get props => [
        subtypeId,
        subtypeName,
        materials,
      ];
}
