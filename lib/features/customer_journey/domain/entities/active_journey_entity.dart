import 'package:equatable/equatable.dart';

class ActiveJourneyEntity extends Equatable {
  final int apartmentId;
  final String projectName;
  final String unitNumber;
  final String currentStep;
  final DateTime? reservationExpiresAt;
  final DateTime? lastUpdatedAt;
  final String resumeRoute;
  final Map<String, dynamic> resumeArgs;

  const ActiveJourneyEntity({
    required this.apartmentId,
    required this.projectName,
    required this.unitNumber,
    required this.currentStep,
    this.reservationExpiresAt,
    this.lastUpdatedAt,
    required this.resumeRoute,
    required this.resumeArgs,
  });

  @override
  List<Object?> get props => [
        apartmentId,
        projectName,
        unitNumber,
        currentStep,
        reservationExpiresAt,
        lastUpdatedAt,
        resumeRoute,
        resumeArgs,
      ];
}

