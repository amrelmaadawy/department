import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/project_repository.dart';

class ToggleCustomerRenderFavoriteUseCase {
  final ProjectRepository repository;

  ToggleCustomerRenderFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(int apartmentId, String imageUrl) async {
    return await repository.toggleCustomerRenderFavorite(apartmentId, imageUrl);
  }
}
