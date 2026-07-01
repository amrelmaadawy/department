import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/base_repository.dart';
import '../../domain/entities/active_journey_entity.dart';
import '../../domain/repositories/customer_journey_repository.dart';
import '../datasource/customer_journey_remote_data_source.dart';

class CustomerJourneyRepositoryImpl extends BaseRepository implements CustomerJourneyRepository {
  final CustomerJourneyRemoteDataSource remoteDataSource;

  CustomerJourneyRepositoryImpl({
    required this.remoteDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, List<ActiveJourneyEntity>>> getActiveJourneys() async {
    return executeWithNetwork(
      onlineCall: () async {
        return await remoteDataSource.getActiveJourneys();
      },
    );
  }
}
