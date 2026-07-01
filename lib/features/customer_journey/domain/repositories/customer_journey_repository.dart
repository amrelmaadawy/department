import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/active_journey_entity.dart';

abstract class CustomerJourneyRepository {
  Future<Either<Failure, List<ActiveJourneyEntity>>> getActiveJourneys();
}
