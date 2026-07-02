import '../../domain/entities/contract_signature_status_entity.dart';

class ContractSignatureStatusModel extends ContractSignatureStatusEntity {
  const ContractSignatureStatusModel({
    required super.contractType,
    required super.title,
    required super.sequenceOrder,
    required super.isSigned,
    super.contractId,
    super.lastFailureMessage,
  });

  factory ContractSignatureStatusModel.fromJson(Map<String, dynamic> json) {
    return ContractSignatureStatusModel(
      contractType: json['contract_type']?.toString() ?? json['type']?.toString() ?? 'unit',
      title: json['title']?.toString() ?? (json['contract_type'] == 'finishing' ? 'عقد التشطيب الحصري' : 'عقد بيع وتخصيص الوحدة'),
      sequenceOrder: int.tryParse(json['sequence_order']?.toString() ?? '1') ?? 1,
      isSigned: json['is_signed'] == true || json['status']?.toString().toLowerCase() == 'signed',
      contractId: int.tryParse(json['contract_id']?.toString() ?? json['id']?.toString() ?? ''),
      lastFailureMessage: json['last_failure_message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contract_type': contractType,
      'title': title,
      'sequence_order': sequenceOrder,
      'is_signed': isSigned,
      if (contractId != null) 'contract_id': contractId,
      if (lastFailureMessage != null) 'last_failure_message': lastFailureMessage,
    };
  }
}
