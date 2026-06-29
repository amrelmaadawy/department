import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/network/app_cancel_token.dart';
import 'package:apartment/core/network/base_repository.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl extends BaseRepository implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required super.networkInfo,
  });

  @override
  Future<Either<Failure, SettingsEntity>> getGeneralSettings({
    AppCancelToken? cancelToken,
  }) async {
    return executeWithNetwork(
      onlineCall: () async {
        final remoteSettings = await remoteDataSource.getGeneralSettings(
          cancelToken: cancelToken?.token,
        );
        await localDataSource.cacheGeneralSettings(remoteSettings);
        return remoteSettings;
      },
      offlineFallback: () async {
        final cachedSettings = await localDataSource.getCachedGeneralSettings();
        if (cachedSettings != null) {
          return cachedSettings;
        }
        throw Exception('No cached settings available');
      },
    );
  }
}
