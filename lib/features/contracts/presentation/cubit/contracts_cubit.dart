import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_bone_contract_usecase.dart';
import '../../domain/usecases/sign_contract_usecase.dart';
import 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final CreateBoneContractUseCase createBoneContractUseCase;
  final SignContractUseCase signContractUseCase;

  ContractsCubit({
    required this.createBoneContractUseCase,
    required this.signContractUseCase,
  }) : super(ContractsInitial());

  Future<void> createBoneContract({required int apartmentId, required int customerId}) async {
    emit(ContractsLoading());

    final result = await createBoneContractUseCase(
      apartmentId: apartmentId,
      customerId: customerId,
    );

    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(BoneContractCreated(contract)),
    );
  }

  Future<void> signContract({required int contractId, required String signatureBase64}) async {
    emit(ContractSigningLoading());

    final result = await signContractUseCase(
      contractId: contractId,
      signatureBase64: signatureBase64,
    );

    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(ContractSignedSuccess(contract)),
    );
  }
}
