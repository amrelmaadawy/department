import 'package:equatable/equatable.dart';

class ContractBodyItemEntity extends Equatable {
  final String type;
  final String? content;
  final String? html;

  const ContractBodyItemEntity({
    required this.type,
    this.content,
    this.html,
  });

  @override
  List<Object?> get props => [type, content, html];
}

class ContractEntity extends Equatable {
  final int id;
  final String contractNumber;
  final String type;
  final String typeLabel;
  final double totalAmount;
  final int executionDuration;
  final String status;
  final String statusLabel;
  final String? signedAt;
  final List<ContractBodyItemEntity> contractBody;
  final int apartmentId;
  final int customerId;
  final int? finishingOrderId;
  final String createdAt;
  final String signUrl;
  final bool hasCustomerSignature;

  const ContractEntity({
    required this.id,
    required this.contractNumber,
    required this.type,
    required this.typeLabel,
    required this.totalAmount,
    required this.executionDuration,
    required this.status,
    required this.statusLabel,
    this.signedAt,
    required this.contractBody,
    required this.apartmentId,
    required this.customerId,
    this.finishingOrderId,
    required this.createdAt,
    required this.signUrl,
    required this.hasCustomerSignature,
  });

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        type,
        typeLabel,
        totalAmount,
        executionDuration,
        status,
        statusLabel,
        signedAt,
        contractBody,
        apartmentId,
        customerId,
        finishingOrderId,
        createdAt,
        signUrl,
        hasCustomerSignature,
      ];
}
