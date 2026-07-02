import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_bone_contract_usecase.dart';
import '../../domain/usecases/create_finishing_contract_usecase.dart';
import '../../domain/usecases/get_apartment_finishing_orders_use_case.dart';
import '../../domain/usecases/sign_contract_usecase.dart';
import '../../domain/usecases/get_contract_signature_status_usecase.dart';
import '../../domain/usecases/mark_contract_as_signed_usecase.dart';
import '../../domain/usecases/get_contract_by_id_usecase.dart';
import '../../domain/usecases/get_contract_statuses_list_usecase.dart';
import '../../domain/usecases/save_finishing_order_ids_usecase.dart';
import '../../domain/usecases/get_finishing_order_ids_usecase.dart';
import '../../domain/entities/contract_signature_status_entity.dart';
import '../../../auth/data/services/session_manager.dart';
import '../../../../core/services/security/biometric_auth_service.dart';
import 'contracts_state.dart';

class ContractsCubit extends Cubit<ContractsState> {
  final CreateBoneContractUseCase createBoneContractUseCase;
  final CreateFinishingContractUseCase createFinishingContractUseCase;
  final GetApartmentFinishingOrdersUseCase getApartmentFinishingOrdersUseCase;
  final SignContractUseCase signContractUseCase;
  final GetContractSignatureStatusUseCase getContractSignatureStatusUseCase;
  final GetContractStatusesListUseCase? getContractStatusesListUseCase;
  final MarkContractAsSignedUseCase markContractAsSignedUseCase;
  final GetContractByIdUseCase getContractByIdUseCase;
  final SaveFinishingOrderIdsUseCase saveFinishingOrderIdsUseCase;
  final GetFinishingOrderIdsUseCase getFinishingOrderIdsUseCase;
  final SessionManager sessionManager;
  final BiometricAuthService? biometricAuthService;

  bool isUnitContractSigned = false;
  bool isFinishingContractSigned = false;
  List<ContractSignatureStatusEntity> contractStatusesList = [];

  /// Finishing order IDs cached independently of the Bloc state.
  /// Survives state changes caused by [loadSignatureStatuses] or other operations,
  /// eliminating the race condition where the user taps "Sign" before
  /// [fetchFinishingOrders] emits [FinishingOrdersLoaded].
  List<int> cachedFinishingOrderIds = [];

  /// True once finishing orders have been fetched from the server at least once.
  bool isFinishingOrdersReady = false;

  /// True while finishing orders are being fetched.
  bool isLoadingFinishingOrders = false;

  ContractsCubit({
    required this.createBoneContractUseCase,
    required this.createFinishingContractUseCase,
    required this.getApartmentFinishingOrdersUseCase,
    required this.signContractUseCase,
    required this.getContractSignatureStatusUseCase,
    this.getContractStatusesListUseCase,
    required this.markContractAsSignedUseCase,
    required this.getContractByIdUseCase,
    required this.saveFinishingOrderIdsUseCase,
    required this.getFinishingOrderIdsUseCase,
    required this.sessionManager,
    this.biometricAuthService,
  }) : super(ContractsInitial());

  Future<void> loadSignatureStatuses(String unitId) async {
    if (getContractStatusesListUseCase != null) {
      final result = await getContractStatusesListUseCase!(unitId);
      result.fold(
        (l) {},
        (statuses) {
          contractStatusesList = statuses;
          for (final s in statuses) {
            if (s.contractType == 'unit') isUnitContractSigned = s.isSigned;
            if (s.contractType == 'finishing') isFinishingContractSigned = s.isSigned;
          }
        },
      );
      if (contractStatusesList.isNotEmpty) {
        emit(ContractStatusesListLoaded(contractStatusesList));
        return;
      }
    }

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

    contractStatusesList = contractStatusesList.map((s) {
      if (s.contractType == contractType) {
        return s.copyWith(isSigned: true);
      }
      return s;
    }).toList();

    if (contractStatusesList.isNotEmpty) {
      emit(ContractStatusesListLoaded(contractStatusesList));
    } else {
      emit(ContractSignatureStatusesLoaded(isUnitContractSigned, isFinishingContractSigned));
    }
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

  /// Reads cached finishing order IDs from local storage (instant, no network).
  /// Called before [fetchFinishingOrders] so the IDs are available immediately
  /// even while the server call is still in progress.
  Future<void> loadCachedFinishingOrderIds(int apartmentId) async {
    if (cachedFinishingOrderIds.isNotEmpty) return; // already loaded
    final result = await getFinishingOrderIdsUseCase(apartmentId);
    result.fold(
      (_) {}, // silent fail — network fetch will cover it
      (ids) {
        if (ids.isNotEmpty) {
          cachedFinishingOrderIds = ids;
          isFinishingOrdersReady = true;
        }
      },
    );
  }

  Future<void> fetchFinishingOrders(int apartmentId) async {
    isLoadingFinishingOrders = true;
    emit(FinishingOrdersLoading());

    final ordersResult = await getApartmentFinishingOrdersUseCase(apartmentId);

    if (isClosed) return;
    isLoadingFinishingOrders = false;

    ordersResult.fold(
      (failure) => emit(ContractsError(failure.message)),
      (rooms) {
        // Cache IDs in memory — survives subsequent state emissions
        cachedFinishingOrderIds = rooms
            .expand((room) => room.orders)
            .map((order) => order.id)
            .toList();
        isFinishingOrdersReady = true;
        // Persist to local storage so they survive app restarts
        saveFinishingOrderIdsUseCase(apartmentId, cachedFinishingOrderIds);
        emit(FinishingOrdersLoaded(rooms));
      },
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
    final isValid = await sessionManager.validateAndRefresh(sensitive: true);
    if (!isValid) {
      emit(SessionExpiredState());
      return;
    }

    if (biometricAuthService != null) {
      final bioResult = await biometricAuthService!.authenticate(
        reason: 'يرجى التحقق من هويتك لتوقيع العقد',
      );
      if (bioResult == BiometricResult.failed || bioResult == BiometricResult.error) {
        emit(const ContractsError('فشل التحقق من الهوية (البصمة/القياسات الحيوية)'));
        return;
      }
    }

    emit(ContractSigningLoading());

    final result = await signContractUseCase(
      contractId: contractId,
      signatureBase64: signatureBase64,
    );

    if (isClosed) return;
    result.fold(
      (failure) {
        if (isUnitContractSigned || contractStatusesList.any((s) => s.isSigned)) {
          emit(const ContractPartialSigningFailure('finishing', 'عقد تنفيذ التشطيب لم يكتمل توقيعه، حاول مرة أخرى'));
        } else {
          emit(ContractsError(failure.message));
        }
      },
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
