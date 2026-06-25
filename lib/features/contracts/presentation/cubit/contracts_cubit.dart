import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_bone_contract_usecase.dart';
import '../../domain/usecases/create_finishing_contract_usecase.dart';
import '../../domain/usecases/get_apartment_finishing_orders_use_case.dart';
import '../../domain/usecases/sign_contract_usecase.dart';
import 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final CreateBoneContractUseCase createBoneContractUseCase;
  final CreateFinishingContractUseCase createFinishingContractUseCase;
  final GetApartmentFinishingOrdersUseCase getApartmentFinishingOrdersUseCase;
  final SignContractUseCase signContractUseCase;

  ContractsCubit({
    required this.createBoneContractUseCase,
    required this.createFinishingContractUseCase,
    required this.getApartmentFinishingOrdersUseCase,
    required this.signContractUseCase,
  }) : super(ContractsInitial());

  Future<void> createBoneContract({required int apartmentId, required int customerId}) async {
    emit(BoneContractLoading());

    final result = await createBoneContractUseCase(
      apartmentId: apartmentId,
      customerId: customerId,
    );

    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(BoneContractCreated(contract)),
    );
  }

  Future<void> fetchFinishingOrders(int apartmentId) async {
    emit(FinishingOrdersLoading());

    final ordersResult = await getApartmentFinishingOrdersUseCase(apartmentId);
    
    ordersResult.fold(
      (failure) => emit(ContractsError(failure.message)),
      (rooms) => emit(FinishingOrdersLoaded(rooms)),
    );
  }

  Future<void> createFinishingContract({required List<int> orderIds}) async {
    emit(FinishingContractLoading());

    if (orderIds.isEmpty) {
      emit(const ContractsError('لا توجد طلبات تشطيب محددة لهذه الشقة'));
      return;
    }

    final result = await createFinishingContractUseCase(orderIds);
    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(FinishingContractCreated(contract)),
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
