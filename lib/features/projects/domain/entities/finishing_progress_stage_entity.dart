import 'package:equatable/equatable.dart';

class FinishingProgressStageEntity extends Equatable {
  final int id;
  final String name;
  final int progressPercent;
  final String status;
  final String statusLabel;
  final String? notes;
  final List<String> rooms;
  final List<String> images;

  const FinishingProgressStageEntity({
    required this.id,
    required this.name,
    required this.progressPercent,
    required this.status,
    required this.statusLabel,
    this.notes,
    required this.rooms,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        progressPercent,
        status,
        statusLabel,
        notes,
        rooms,
        images,
      ];
}
