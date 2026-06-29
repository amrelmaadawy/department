import 'package:dartz/dartz.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/network/app_cancel_token.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetGeneralSettingsUseCase {
  final SettingsRepository repository;

  GetGeneralSettingsUseCase({required this.repository});

  Future<Either<Failure, SettingsEntity>> call({
    AppCancelToken? cancelToken,
  }) {
    return repository.getGeneralSettings(cancelToken: cancelToken);
  }
}
