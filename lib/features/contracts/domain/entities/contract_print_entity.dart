import 'package:equatable/equatable.dart';

class ContractPrintEntity extends Equatable {
  final String printUrl;
  final String pdfUrl;

  const ContractPrintEntity({
    required this.printUrl,
    required this.pdfUrl,
  });

  @override
  List<Object?> get props => [printUrl, pdfUrl];
}
