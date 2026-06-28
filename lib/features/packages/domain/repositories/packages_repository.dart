import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import '../entities/finishing_package_entity.dart';

abstract class PackagesRepository {
  Future<Either<Failure, List<FinishingPackageEntity>>> getPackages();
}
