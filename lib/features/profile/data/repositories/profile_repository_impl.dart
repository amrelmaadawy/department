import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/update_profile_params.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(UpdateProfileParams params) async {
    try {
      final map = params.toMap();
      if (params.avatarPath != null) {
        // Need to import dio for MultipartFile
        final file = await MultipartFile.fromFile(params.avatarPath!);
        map['avatar_url'] = file;
      }
      final formData = FormData.fromMap(map);
      
      final profile = await remoteDataSource.updateProfile(formData as dynamic); // Passing FormData directly
      return Right(profile);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteDesign(int orderId, String imageUrl) async {
    try {
      final result = await remoteDataSource.toggleFavoriteDesign(orderId, imageUrl);
      return Right(result);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }
}
