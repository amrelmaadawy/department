import 'package:equatable/equatable.dart';

class ContractSignatureStatusEntity extends Equatable {
  final String contractType;
  final String title;
  final int sequenceOrder;
  final bool isSigned;
  final int? contractId;
  final String? lastFailureMessage;

  const ContractSignatureStatusEntity({
    required this.contractType,
    required this.title,
    required this.sequenceOrder,
    required this.isSigned,
    this.contractId,
    this.lastFailureMessage,
  });

  ContractSignatureStatusEntity copyWith({
    String? contractType,
    String? title,
    int? sequenceOrder,
    bool? isSigned,
    int? contractId,
    String? lastFailureMessage,
  }) {
    return ContractSignatureStatusEntity(
      contractType: contractType ?? this.contractType,
      title: title ?? this.title,
      sequenceOrder: sequenceOrder ?? this.sequenceOrder,
      isSigned: isSigned ?? this.isSigned,
      contractId: contractId ?? this.contractId,
      lastFailureMessage: lastFailureMessage ?? this.lastFailureMessage,
    );
  }

  @override
  List<Object?> get props => [
        contractType,
        title,
        sequenceOrder,
        isSigned,
        contractId,
        lastFailureMessage,
      ];
}
