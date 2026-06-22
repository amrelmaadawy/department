import 'package:equatable/equatable.dart';

class CustomerRenderEntity extends Equatable {
  final String url;
  final bool isSaved;
  final String roomName;

  const CustomerRenderEntity({
    required this.url,
    required this.isSaved,
    required this.roomName,
  });

  @override
  List<Object?> get props => [url, isSaved, roomName];
}

class RoomCustomerRendersEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String typeLabel;
  final double area;
  final List<CustomerRenderEntity> renders;

  const RoomCustomerRendersEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.typeLabel,
    required this.area,
    required this.renders,
  });

  @override
  List<Object?> get props => [id, name, type, typeLabel, area, renders];
}
