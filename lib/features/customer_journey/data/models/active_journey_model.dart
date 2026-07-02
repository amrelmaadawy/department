import '../../domain/entities/active_journey_entity.dart';

class ActiveJourneyModel extends ActiveJourneyEntity {
  const ActiveJourneyModel({
    required super.apartmentId,
    required super.projectName,
    required super.unitNumber,
    required super.currentStep,
    super.reservationExpiresAt,
    super.lastUpdatedAt,
    required super.resumeRoute,
    required super.resumeArgs,
  });

  factory ActiveJourneyModel.fromJson(Map<String, dynamic> json) {
    return ActiveJourneyModel(
      apartmentId: int.tryParse(json['apartment_id']?.toString() ?? '') ?? 0,
      projectName: json['project_name']?.toString() ?? '',
      unitNumber: json['unit_number']?.toString() ?? '',
      currentStep: json['current_step']?.toString() ?? '',
      reservationExpiresAt: json['reservation_expires_at'] != null
          ? DateTime.tryParse(json['reservation_expires_at'].toString())
          : null,
      lastUpdatedAt: json['last_updated_at'] != null
          ? DateTime.tryParse(json['last_updated_at'].toString())
          : (json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'].toString())
              : null),
      resumeRoute: json['resume_route']?.toString() ?? '',
      resumeArgs: json['resume_args'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['resume_args'])
          : (json['resume_args'] is Map ? Map<String, dynamic>.from(json['resume_args']) : const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apartment_id': apartmentId,
      'project_name': projectName,
      'unit_number': unitNumber,
      'current_step': currentStep,
      'reservation_expires_at': reservationExpiresAt?.toIso8601String(),
      'last_updated_at': lastUpdatedAt?.toIso8601String(),
      'resume_route': resumeRoute,
      'resume_args': resumeArgs,
    };
  }
}

