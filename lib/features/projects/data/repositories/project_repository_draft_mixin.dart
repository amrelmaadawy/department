import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/base_repository.dart';
import '../../domain/entities/customization_draft_entity.dart';
import '../datasources/customization_draft_remote_data_source.dart';

mixin ProjectRepositoryDraftMixin on BaseRepository {
  CustomizationDraftRemoteDataSource get draftDataSource;

  Future<Either<Failure, CustomizationDraftEntity>> getCustomizationDraft(int apartmentId) async {
    return executeWithNetwork(
      onlineCall: () => draftDataSource.getCustomizationDraft(apartmentId),
    );
  }

  Future<Either<Failure, CustomizationDraftEntity>> saveCustomizationDraft(int apartmentId, Map<String, dynamic> draftData) async {
    return executeWithNetwork(
      isMutation: true,
      onlineCall: () => draftDataSource.saveCustomizationDraft(apartmentId, draftData),
    );
  }
}
