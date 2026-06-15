import 'package:equatable/equatable.dart';

class AiGalleryEntity extends Equatable {
  final String url;
  final int orderId;
  final String roomName;
  final DateTime? createdAt;

  const AiGalleryEntity({
    required this.url,
    required this.orderId,
    required this.roomName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [url, orderId, roomName, createdAt];
}
