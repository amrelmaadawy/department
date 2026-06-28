import 'package:equatable/equatable.dart';
import 'package_item_entity.dart';

class FinishingPackageEntity extends Equatable {
  final int id;
  final String name;
  final String? badge;
  final String description;
  final double calculatedPrice;
  final List<PackageItemEntity> items;

  const FinishingPackageEntity({
    required this.id,
    required this.name,
    this.badge,
    required this.description,
    required this.calculatedPrice,
    required this.items,
  });

  /// Returns unique room types present in this package
  List<String> get roomTypes => items.map((e) => e.roomType).toSet().toList();

  /// Returns all items for a specific room type
  List<PackageItemEntity> itemsForRoom(String roomType) =>
      items.where((e) => e.roomType == roomType).toList();

  @override
  List<Object?> get props => [id, name, badge, description, calculatedPrice, items];
}
