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

/// Emitted when the server `print_url` is ready to be displayed in a WebView.
/// No PDF bytes are downloaded — both URLs carry their own auth signatures.
class ContractPrintWebViewReady extends ContractPrintState {
  final String printUrl;
  final String pdfUrl;
  final String contractTitle;

  const ContractPrintWebViewReady({
    required this.printUrl,
    required this.pdfUrl,
    required this.contractTitle,
  });

  @override
  List<Object?> get props => [printUrl, pdfUrl, contractTitle];
}

class ContractPrintError extends ContractPrintState {
  final String message;

  const ContractPrintError(this.message);

  @override
  List<Object?> get props => [message];
}
