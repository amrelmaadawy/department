import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/apartment_finishing_order_entity.dart';
import '../repositories/contract_repository.dart';

class GetApartmentFinishingOrdersUseCase {
  final ContractRepository repository;

  GetApartmentFinishingOrdersUseCase(this.repository);

  Future<Either<Failure, List<ApartmentFinishingOrderRoomEntity>>> call(int apartmentId) async {
    return await repository.getApartmentFinishingOrders(apartmentId);
  }
}
