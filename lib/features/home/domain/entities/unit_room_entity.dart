import 'package:equatable/equatable.dart';

class UnitRoomEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String typeLabel;
  final double area;
  final double? length;
  final double? width;

  const UnitRoomEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.typeLabel,
    required this.area,
    this.length,
    this.width,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        typeLabel,
        area,
        length,
        width,
      ];
}
