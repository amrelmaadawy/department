import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/features/contracts/domain/entities/contract_entity.dart';
import 'package:apartment/features/contracts/domain/entities/apartment_finishing_order_entity.dart';
import 'package:apartment/features/contracts/domain/entities/contract_signature_status_entity.dart';
import 'package:apartment/features/contracts/domain/repositories/contract_repository.dart';
import 'package:apartment/features/contracts/domain/usecases/get_contract_statuses_list_usecase.dart';

class FakeContractRepository implements ContractRepository {
  List<ContractSignatureStatusEntity> returnedStatuses = [];

  @override
  Future<Either<Failure, List<ContractSignatureStatusEntity>>> getContractStatusesList(String unitId) async {
    return Right(returnedStatuses);
  }

  @override
  Future<Either<Failure, ContractEntity>> createBoneContract(int apartmentId) => throw UnimplementedError();

  @override
  Future<Either<Failure, ContractEntity>> createFinishingContract(List<int> finishingOrderIds) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> getApartmentFinishingOrders(int apartmentId) => throw UnimplementedError();

  @override
  Future<Either<Failure, ContractEntity>> getContractById(int id) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<ContractEntity>>> getContracts() => throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> isContractSigned(String unitId, String contractType) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markContractAsSigned(String unitId, String contractType, bool status) => throw UnimplementedError();

  @override
  Future<Either<Failure, ContractEntity>> signContract(int contractId, String signatureBase64) => throw UnimplementedError();
}

void main() {
  late GetContractStatusesListUseCase useCase;
  late FakeContractRepository repository;

  setUp(() {
    repository = FakeContractRepository();
    useCase = GetContractStatusesListUseCase(repository);
  });

  const tUnitId = '101';

  test('should return contract statuses sorted ascending by sequenceOrder from the repository', () async {
    // arrange
    repository.returnedStatuses = [
      const ContractSignatureStatusEntity(
        contractType: 'finishing',
        title: 'عقد التشطيب الحصري',
        sequenceOrder: 2,
        isSigned: false,
      ),
      const ContractSignatureStatusEntity(
        contractType: 'unit',
        title: 'عقد بيع وتخصيص الوحدة',
        sequenceOrder: 1,
        isSigned: true,
      ),
    ];

    // act
    final result = await useCase(tUnitId);

    // assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should not return failure'),
      (statuses) {
        expect(statuses.length, 2);
        expect(statuses[0].sequenceOrder, 1);
        expect(statuses[0].contractType, 'unit');
        expect(statuses[1].sequenceOrder, 2);
        expect(statuses[1].contractType, 'finishing');
      },
    );
  });
}
