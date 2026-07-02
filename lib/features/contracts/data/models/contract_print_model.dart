import '../../domain/entities/contract_print_entity.dart';

class ContractPrintModel extends ContractPrintEntity {
  const ContractPrintModel({
    required super.printUrl,
    required super.pdfUrl,
  });

  factory ContractPrintModel.fromJson(Map<String, dynamic> json) {
    return ContractPrintModel(
      printUrl: json['print_url'] as String? ?? '',
      pdfUrl: json['pdf_url'] as String? ?? '',
    );
  }
}
