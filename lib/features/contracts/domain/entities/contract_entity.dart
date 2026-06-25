import 'package:equatable/equatable.dart';

class ContractListItemEntity extends Equatable {
  final String type;
  final String content;

  const ContractListItemEntity({
    required this.type,
    required this.content,
  });

  @override
  List<Object?> get props => [type, content];
}

class ContractTableFooterEntity extends Equatable {
  final String content;
  final int colspan;

  const ContractTableFooterEntity({
    required this.content,
    required this.colspan,
  });

  @override
  List<Object?> get props => [content, colspan];
}

class ContractTableDataEntity extends Equatable {
  final List<String> headers;
  final List<List<String>> rows;
  final List<ContractTableFooterEntity> footer;

  const ContractTableDataEntity({
    required this.headers,
    required this.rows,
    required this.footer,
  });

  @override
  List<Object?> get props => [headers, rows, footer];
}

class ContractBodyItemEntity extends Equatable {
  final String type;
  final String? content;
  final String? html;
  final List<ContractListItemEntity>? items;
  final ContractTableDataEntity? data;

  const ContractBodyItemEntity({
    required this.type,
    this.content,
    this.html,
    this.items,
    this.data,
  });

  @override
  List<Object?> get props => [type, content, html, items, data];
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
