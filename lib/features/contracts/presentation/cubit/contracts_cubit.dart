import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_bone_contract_usecase.dart';
import '../../domain/usecases/create_finishing_contract_usecase.dart';
import '../../domain/usecases/get_apartment_finishing_orders_use_case.dart';
import '../../domain/usecases/sign_contract_usecase.dart';
import '../../domain/usecases/get_contract_signature_status_usecase.dart';
import '../../domain/usecases/mark_contract_as_signed_usecase.dart';
import '../../domain/usecases/get_contract_by_id_usecase.dart';
import 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final CreateBoneContractUseCase createBoneContractUseCase;
  final CreateFinishingContractUseCase createFinishingContractUseCase;
  final GetApartmentFinishingOrdersUseCase getApartmentFinishingOrdersUseCase;
  final SignContractUseCase signContractUseCase;
  final GetContractSignatureStatusUseCase getContractSignatureStatusUseCase;
  final MarkContractAsSignedUseCase markContractAsSignedUseCase;
  final GetContractByIdUseCase getContractByIdUseCase;

  bool isUnitContractSigned = false;
  bool isFinishingContractSigned = false;

  ContractsCubit({
    required this.createBoneContractUseCase,
    required this.createFinishingContractUseCase,
    required this.getApartmentFinishingOrdersUseCase,
    required this.signContractUseCase,
    required this.getContractSignatureStatusUseCase,
    required this.markContractAsSignedUseCase,
    required this.getContractByIdUseCase,
  }) : super(ContractsInitial());

  Future<void> loadSignatureStatuses(String unitId) async {
    final unitResult = await getContractSignatureStatusUseCase(unitId, 'unit');
    final finishingResult = await getContractSignatureStatusUseCase(unitId, 'finishing');
    
    isUnitContractSigned = unitResult.fold((l) => false, (r) => r);
    isFinishingContractSigned = finishingResult.fold((l) => false, (r) => r);
    
    emit(ContractSignatureStatusesLoaded(isUnitContractSigned, isFinishingContractSigned));
  }

  Future<void> markContractAsSigned(String unitId, String contractType) async {
    await markContractAsSignedUseCase(unitId, contractType, true);
    if (contractType == 'unit') isUnitContractSigned = true;
    if (contractType == 'finishing') isFinishingContractSigned = true;
    emit(ContractSignatureStatusesLoaded(isUnitContractSigned, isFinishingContractSigned));
  }

  Future<void> createBoneContract({required int apartmentId}) async {
    emit(BoneContractLoading());

    final result = await createBoneContractUseCase(
      apartmentId: apartmentId,
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

    if (isClosed) return;
    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(ContractSignedSuccess(contract)),
    );
  }

  Future<void> loadContractDetails(int contractId) async {
    emit(ContractDetailsLoading());

    final result = await getContractByIdUseCase(contractId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(ContractsError(failure.message)),
      (contract) => emit(ContractDetailsLoaded(contract)),
    );
  }
}
