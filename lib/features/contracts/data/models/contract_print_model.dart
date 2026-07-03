import '../../domain/entities/contract_print_entity.dart';

class ContractPrintModel extends ContractPrintEntity {
  const ContractPrintModel({
    required super.printUrl,
    required super.pdfUrl,
  });

  factory ContractPrintModel.fromJson(Map<String, dynamic> json) {
    // Some APIs wrap the payload in a 'data' key, others return it flat.
    // Try nested first, fall back to root-level fields.
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return ContractPrintModel(
      printUrl: payload['print_url'] as String? ?? '',
      pdfUrl: payload['pdf_url'] as String? ?? '',
    );
  }
}
