import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/exceptions.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/network/network_info.dart';

abstract class BaseRepository {
  final NetworkInfo networkInfo;

  BaseRepository({required this.networkInfo});

  Future<Either<Failure, T>> executeWithNetwork<T>({
    required Future<T> Function() onlineCall,
    Future<T> Function()? offlineFallback,
    bool isMutation = false,
  }) async {
    final status = await networkInfo.currentStatus;

    if (status == NetworkStatus.offline || status == NetworkStatus.noInternet) {
      if (isMutation) return const Left(OfflineFailure());
      if (offlineFallback != null) {
        try {
          return Right(await offlineFallback());
        } catch (_) {
          return const Left(OfflineFailure());
        }
      }
      return const Left(OfflineFailure());
    }

    try {
      final result = await onlineCall();
      return Right(result);
    } on FailureException catch (e) {
      final failure = e.failure as Failure;

      if (!isMutation && offlineFallback != null) {
        if (failure is TimeoutFailure || failure is ServerUnreachableFailure) {
          try {
            return Right(await offlineFallback());
          } catch (_) {}
        }
      }

      return Left(failure);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
