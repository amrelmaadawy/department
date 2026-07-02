import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_bone_contract_print_data_usecase.dart';
import '../../domain/usecases/get_finishing_contract_print_data_usecase.dart';
import '../../domain/usecases/download_contract_pdf_usecase.dart';
import 'contract_print_state.dart';

class ContractPrintCubit extends Cubit<ContractPrintState> {
  final GetBoneContractPrintDataUseCase getBoneContractPrintDataUseCase;
  final GetFinishingContractPrintDataUseCase getFinishingContractPrintDataUseCase;
  final DownloadContractPdfUseCase downloadContractPdfUseCase;

  ContractPrintCubit({
    required this.getBoneContractPrintDataUseCase,
    required this.getFinishingContractPrintDataUseCase,
    required this.downloadContractPdfUseCase,
  }) : super(const ContractPrintInitial());

  Future<void> fetchAndPrepareBoneContract(int apartmentId) async {
    emit(const ContractPrintLoading());

    final printDataResult = await getBoneContractPrintDataUseCase(apartmentId);
    if (isClosed) return;

    await printDataResult.fold(
      (failure) async => emit(ContractPrintError(failure.message)),
      (printData) async {
        final pdfResult = await downloadContractPdfUseCase(printData.pdfUrl);
        if (isClosed) return;
        pdfResult.fold(
          (failure) => emit(ContractPrintError(failure.message)),
          (bytes) => emit(ContractPrintReady(
            pdfBytes: bytes,
            contractTitle: 'عقد العظم',
          )),
        );
      },
    );
  }

  Future<void> fetchAndPrepareFinishingContract(int apartmentId) async {
    emit(const ContractPrintLoading());

    final printDataResult = await getFinishingContractPrintDataUseCase(apartmentId);
    if (isClosed) return;

    await printDataResult.fold(
      (failure) async => emit(ContractPrintError(failure.message)),
      (printData) async {
        final pdfResult = await downloadContractPdfUseCase(printData.pdfUrl);
        if (isClosed) return;
        pdfResult.fold(
          (failure) => emit(ContractPrintError(failure.message)),
          (bytes) => emit(ContractPrintReady(
            pdfBytes: bytes,
            contractTitle: 'عقد التشطيب',
          )),
        );
      },
    );
  }
}
