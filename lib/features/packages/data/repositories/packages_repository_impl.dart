import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/exceptions.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/repositories/packages_repository.dart';
import '../datasources/packages_remote_data_source.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesRemoteDataSource remoteDataSource;

  PackagesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FinishingPackageEntity>>> getPackages() async {
    try {
      final models = await remoteDataSource.getPackages();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع'));
    }
  }
}
