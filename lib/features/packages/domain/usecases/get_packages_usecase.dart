import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import '../entities/finishing_package_entity.dart';
import '../repositories/packages_repository.dart';

class GetPackagesUseCase {
  final PackagesRepository repository;

  GetPackagesUseCase(this.repository);

  Future<Either<Failure, List<FinishingPackageEntity>>> call() {
    return repository.getPackages();
  }
}
