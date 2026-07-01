import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/active_journey_entity.dart';
import '../repositories/customer_journey_repository.dart';

class GetActiveJourneysUseCase {
  final CustomerJourneyRepository repository;

  GetActiveJourneysUseCase(this.repository);

  Future<Either<Failure, List<ActiveJourneyEntity>>> call() {
    return repository.getActiveJourneys();
  }
}
