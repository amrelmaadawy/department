import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class ContractPrintState extends Equatable {
  const ContractPrintState();

  @override
  List<Object?> get props => [];
}

class ContractPrintInitial extends ContractPrintState {
  const ContractPrintInitial();
}

class ContractPrintLoading extends ContractPrintState {
  const ContractPrintLoading();
}

class ContractPrintReady extends ContractPrintState {
  final Uint8List pdfBytes;
  final String contractTitle;

  const ContractPrintReady({
    required this.pdfBytes,
    required this.contractTitle,
  });

  @override
  List<Object?> get props => [pdfBytes, contractTitle];
}

class ContractPrintError extends ContractPrintState {
  final String message;

  const ContractPrintError(this.message);

  @override
  List<Object?> get props => [message];
}
