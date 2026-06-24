import '../../domain/entities/contract_entity.dart';

class ContractBodyItemModel extends ContractBodyItemEntity {
  const ContractBodyItemModel({
    required super.type,
    super.content,
    super.html,
  });

  factory ContractBodyItemModel.fromJson(Map<String, dynamic> json) {
    return ContractBodyItemModel(
      type: json['type'] as String,
      content: json['content'] as String?,
      html: json['html'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'html': html,
    };
  }
}

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    required super.contractNumber,
    required super.type,
    required super.typeLabel,
    required super.totalAmount,
    required super.executionDuration,
    required super.status,
    required super.statusLabel,
    super.signedAt,
    required super.contractBody,
    required super.apartmentId,
    required super.customerId,
    super.finishingOrderId,
    required super.createdAt,
    required super.signUrl,
    required super.hasCustomerSignature,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as int,
      contractNumber: json['contract_number'] as String,
      type: json['type'] as String,
      typeLabel: json['type_label'] as String,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      executionDuration: json['execution_duration'] as int,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      signedAt: json['signed_at'] as String?,
      contractBody: (json['contract_body'] as List<dynamic>?)
              ?.map((e) => ContractBodyItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      apartmentId: json['apartment_id'] as int,
      customerId: json['customer_id'] as int,
      finishingOrderId: json['finishing_order_id'] as int?,
      createdAt: json['created_at'] as String,
      signUrl: json['sign_url'] as String,
      hasCustomerSignature: json['has_customer_signature'] as bool? ?? false,
    );
  }
}
