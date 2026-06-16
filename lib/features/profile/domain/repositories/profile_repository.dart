import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../usecases/update_profile_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, bool>> toggleFavoriteDesign(int orderId, String imageUrl);
}
