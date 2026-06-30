import 'package:equatable/equatable.dart';
import 'package_item_entity.dart';

class FinishingPackageEntity extends Equatable {
  final int id;
  final String name;
  final List<String> badges;
  final String description;
  final double calculatedPrice;
  final List<PackageItemEntity> items;

  const FinishingPackageEntity({
    required this.id,
    required this.name,
    this.badges = const [],
    required this.description,
    required this.calculatedPrice,
    required this.items,
  });

  /// Backward compatibility getter for single badge
  String? get badge => badges.isNotEmpty ? badges.first : null;

  /// Returns unique room types present in this package
  List<String> get roomTypes => items.map((e) => e.roomType).toSet().toList();

  List<PackageItemEntity> itemsForRoom(String roomType) =>
      items.where((e) => e.roomType.trim().toLowerCase() == roomType.trim().toLowerCase()).toList();

  @override
  List<Object?> get props => [id, name, badges, description, calculatedPrice, items];
}

