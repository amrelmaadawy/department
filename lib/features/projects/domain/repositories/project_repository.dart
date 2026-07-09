import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../../../home/domain/entities/room_details_entity.dart';

import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_request_entity.dart';
import 'package:apartment/features/projects/domain/entities/ai_renders_entity.dart';

import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:apartment/features/projects/data/models/save_design_request_model.dart';
import 'package:apartment/features/projects/domain/entities/customer_render_entity.dart';
import 'package:apartment/features/projects/domain/entities/customization_draft_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_progress_stage_entity.dart';
import '../../../../core/network/app_cancel_token.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects({AppCancelToken? cancelToken, bool forceRefresh = false});
  Future<Either<Failure, ProjectEntity>> getProjectDetails(int id, {bool forceRefresh = false});
  Future<Either<Failure, List<ProjectUnitEntity>>> getProjectUnits(int id, {bool forceRefresh = false});
  Future<Either<Failure, ProjectUnitEntity>> getUnitDetails(int id, {bool forceRefresh = false});
  Future<Either<Failure, RoomDetailsEntity>> getRoomDetails(int id, {bool forceRefresh = false});
  Future<Either<Failure, FinishingOrderEntity>> submitFinishingOrder(FinishingOrderRequestEntity request);
  Future<Either<Failure, AiRendersEntity>> getAiRenders(int orderId);
  Future<Either<Failure, SavedDesignEntity>> saveDesign(SaveDesignRequestModel request);
  Future<Either<Failure, List<String>>> getPresetNotes();
  Future<Either<Failure, List<RoomCustomerRendersEntity>>> getCustomerRenders(int apartmentId);
  Future<Either<Failure, bool>> toggleCustomerRenderFavorite(int apartmentId, String imageUrl);
  Future<Either<Failure, CustomizationDraftEntity>> getCustomizationDraft(int apartmentId);
  Future<Either<Failure, CustomizationDraftEntity>> saveCustomizationDraft(int apartmentId, Map<String, dynamic> draftData);
  Future<Either<Failure, List<FinishingProgressStageEntity>>> getFinishingProgress(int apartmentId);
  void clearCache();
}
