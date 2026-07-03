import '../../domain/entities/contract_entity.dart';

class ContractListItemModel extends ContractListItemEntity {
  const ContractListItemModel({
    required super.type,
    required super.content,
  });

  factory ContractListItemModel.fromJson(Map<String, dynamic> json) {
    return ContractListItemModel(
      type: json['type'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
    };
  }
}

class ContractTableFooterModel extends ContractTableFooterEntity {
  const ContractTableFooterModel({
    required super.content,
    required super.colspan,
  });

  factory ContractTableFooterModel.fromJson(Map<String, dynamic> json) {
    return ContractTableFooterModel(
      content: json['content'] as String,
      colspan: json['colspan'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'colspan': colspan,
    };
  }
}

class ContractTableDataModel extends ContractTableDataEntity {
  const ContractTableDataModel({
    required super.headers,
    required super.rows,
    required super.footer,
  });

  factory ContractTableDataModel.fromJson(Map<String, dynamic> json) {
    return ContractTableDataModel(
      headers: (json['headers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      rows: (json['rows'] as List<dynamic>?)?.map((row) {
        return (row as List<dynamic>).map((e) => e.toString()).toList();
      }).toList() ?? [],
      footer: (json['footer'] as List<dynamic>?)
              ?.map((e) => ContractTableFooterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'rows': rows,
      'footer': footer.map((e) => (e as ContractTableFooterModel).toJson()).toList(),
    };
  }
}

class ContractBodyItemModel extends ContractBodyItemEntity {
  const ContractBodyItemModel({
    required super.type,
    super.content,
    super.html,
    super.items,
    super.data,
  });

  factory ContractBodyItemModel.fromJson(Map<String, dynamic> json) {
    return ContractBodyItemModel(
      type: json['type'] as String,
      content: json['content'] as String?,
      html: json['html'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ContractListItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: json['data'] != null ? ContractTableDataModel.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'html': html,
      if (items != null) 'items': items?.map((e) => (e as ContractListItemModel).toJson()).toList(),
      if (data != null) 'data': (data as ContractTableDataModel).toJson(),
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
      // apartment_id may be null in finishing contracts (API may omit it or use unit_id).
      // Hard cast `as int` crashes at runtime when the field is missing — use null-safe parse.
      apartmentId: (json['apartment_id'] as int?) ?? (json['unit_id'] as int?) ?? 0,
      customerId: json['customer_id'] as int,
      finishingOrderId: json['finishing_order_id'] as int?,
      createdAt: json['created_at'] as String,
      signUrl: json['sign_url'] as String,
      hasCustomerSignature: json['has_customer_signature'] as bool? ?? false,
    );
  }
}
