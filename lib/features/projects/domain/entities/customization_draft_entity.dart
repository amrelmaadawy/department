import 'package:equatable/equatable.dart';

class CustomizationDraftEntity extends Equatable {
  final int apartmentId;
  final int customerId;
  final Map<String, dynamic> draftData;
  final DateTime? updatedAt;

  const CustomizationDraftEntity({
    required this.apartmentId,
    required this.customerId,
    required this.draftData,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [apartmentId, customerId, draftData, updatedAt];
}
