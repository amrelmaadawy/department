import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _sessionStartKey = 'session_start';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  Future<void> _saveSessionData(UserEntity user) async {
    if (user.token != null && user.token!.isNotEmpty) {
      await secureStorage.write(key: _tokenKey, value: user.token);
    }
    if (user.id != null) {
      await secureStorage.write(key: _userIdKey, value: user.id.toString());
    }
    await secureStorage.write(
      key: _sessionStartKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      await _saveSessionData(user);
      return Right(user);
    } on FailureException catch (e) {
      return Left(e.failure as Failure);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('فشل الاتصال بالشبكة، يرجى التحقق من اتصال الإنترنت'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await _saveSessionData(user);
      return Right(user);
    } on FailureException catch (e) {
      return Left(e.failure as Failure);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('فشل الاتصال بالشبكة، يرجى التحقق من اتصال الإنترنت'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _userIdKey);
      await secureStorage.delete(key: _sessionStartKey);
      return const Right(null);
    } on FailureException catch (e) {
      return Left(e.failure as Failure);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('فشل الاتصال بالشبكة، يرجى التحقق من اتصال الإنترنت'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('ServerException(message: ', '');
      return Left(ServerFailure(msg));
    }
  }
}
