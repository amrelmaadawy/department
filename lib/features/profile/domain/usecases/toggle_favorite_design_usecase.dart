import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

class ToggleFavoriteDesignUseCase {
  final ProfileRepository repository;

  ToggleFavoriteDesignUseCase(this.repository);

  Future<Either<Failure, bool>> call(int orderId, String imageUrl) {
    return repository.toggleFavoriteDesign(orderId, imageUrl);
  }
}
