import 'package:equatable/equatable.dart';

class AiRendersEntity extends Equatable {
  final int orderId;
  final String aiStatus;
  final String aiStatusLabel;
  final List<String> aiRenders;

  const AiRendersEntity({
    required this.orderId,
    required this.aiStatus,
    required this.aiStatusLabel,
    required this.aiRenders,
  });

  @override
  List<Object?> get props => [
        orderId,
        aiStatus,
        aiStatusLabel,
        aiRenders,
      ];
}
