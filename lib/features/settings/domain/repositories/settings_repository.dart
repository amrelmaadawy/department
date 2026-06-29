import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/network/app_cancel_token.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getGeneralSettings({
    AppCancelToken? cancelToken,
  });
}
