import 'package:equatable/equatable.dart';
import 'package_material_entity.dart';

class PackageItemEntity extends Equatable {
  final String roomType;
  final PackageMaterialEntity material;

  const PackageItemEntity({
    required this.roomType,
    required this.material,
  });

  @override
  List<Object?> get props => [roomType, material];
}
