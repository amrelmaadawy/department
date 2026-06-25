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

  Future<void> createFinishingContract({required int apartmentId}) async {
    emit(FinishingContractLoading());

    // 1. Get finishing orders for the apartment
    final ordersResult = await getApartmentFinishingOrdersUseCase(apartmentId);
    
    ordersResult.fold(
      (failure) => emit(ContractsError(failure.message)),
      (rooms) async {
         // Extract order IDs
         final List<int> orderIds = [];
         for (var room in rooms) {
           for (var order in room.orders) {
             orderIds.add(order.id);
           }
         }

         if (orderIds.isEmpty) {
           emit(const ContractsError('لا توجد طلبات تشطيب لهذه الشقة'));
           return;
         }

         // 2. Create finishing contract
         final result = await createFinishingContractUseCase(orderIds);
         result.fold(
           (failure) => emit(ContractsError(failure.message)),
           (contract) => emit(FinishingContractCreated(contract)),
         );
      }
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
