import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/events/app_events.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/base_repository.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../../../home/domain/entities/room_details_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

import 'package:apartment/features/projects/data/models/finishing_order_request_model.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_request_entity.dart';
import 'package:apartment/features/projects/domain/entities/ai_renders_entity.dart';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:apartment/features/projects/data/models/save_design_request_model.dart';
import 'package:apartment/features/projects/domain/entities/customer_render_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_progress_stage_entity.dart';
import '../datasources/customization_draft_remote_data_source.dart';
import 'project_repository_draft_mixin.dart';

import '../../../../core/network/app_cancel_token.dart';

class _CacheEntry<T> {
  final T data;
  final DateTime timestamp;

  _CacheEntry({required this.data, required this.timestamp});

  bool get isValid => DateTime.now().difference(timestamp) < const Duration(minutes: 10);
}

class ProjectRepositoryImpl extends BaseRepository with ProjectRepositoryDraftMixin implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  @override
  final CustomizationDraftRemoteDataSource draftDataSource;

  // Cache Storage
  _CacheEntry<List<ProjectEntity>>? _cachedProjects;
  final Map<int, _CacheEntry<ProjectEntity>> _cachedProjectDetails = {};
  final Map<int, _CacheEntry<List<ProjectUnitEntity>>> _cachedProjectUnits = {};
  final Map<int, _CacheEntry<ProjectUnitEntity>> _cachedUnitDetails = {};
  final Map<int, _CacheEntry<RoomDetailsEntity>> _cachedRoomDetails = {};

  StreamSubscription? _logoutSubscription;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.draftDataSource,
    required super.networkInfo,
  }) {
    _logoutSubscription = AppEvents.onLogout.listen((_) => clearCache());
  }

  @override
  void clearCache() {
    _cachedProjects = null;
    _cachedProjectDetails.clear();
    _cachedProjectUnits.clear();
    _cachedUnitDetails.clear();
    _cachedRoomDetails.clear();
  }

  void dispose() {
    _logoutSubscription?.cancel();
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects({AppCancelToken? cancelToken, bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProjects != null && _cachedProjects!.isValid) {
      return Right(_cachedProjects!.data);
    }

    return executeWithNetwork(
      onlineCall: () async {
        final projects = await remoteDataSource.getProjects(cancelToken: cancelToken);
        _cachedProjects = _CacheEntry(data: projects, timestamp: DateTime.now());
        return projects;
      },
      offlineFallback: () async {
        if (_cachedProjects != null) return _cachedProjects!.data;
        throw Exception('Cache missing');
      },
    );
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectDetails(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProjectDetails.containsKey(id) && _cachedProjectDetails[id]!.isValid) {
      return Right(_cachedProjectDetails[id]!.data);
    }

    return executeWithNetwork(
      onlineCall: () async {
        final project = await remoteDataSource.getProjectDetails(id);
        _cachedProjectDetails[id] = _CacheEntry(data: project, timestamp: DateTime.now());
        return project;
      },
      offlineFallback: () async {
        if (_cachedProjectDetails.containsKey(id)) return _cachedProjectDetails[id]!.data;
        throw Exception('Cache missing');
      },
    );
  }

  @override
  Future<Either<Failure, List<ProjectUnitEntity>>> getProjectUnits(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProjectUnits.containsKey(id) && _cachedProjectUnits[id]!.isValid) {
      return Right(_cachedProjectUnits[id]!.data);
    }

    return executeWithNetwork(
      onlineCall: () async {
        final units = await remoteDataSource.getProjectUnits(id);
        _cachedProjectUnits[id] = _CacheEntry(data: units, timestamp: DateTime.now());
        return units;
      },
      offlineFallback: () async {
        if (_cachedProjectUnits.containsKey(id)) return _cachedProjectUnits[id]!.data;
        throw Exception('Cache missing');
      },
    );
  }

  @override
  Future<Either<Failure, ProjectUnitEntity>> getUnitDetails(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedUnitDetails[id]?.isValid == true) {
      return Right(_cachedUnitDetails[id]!.data);
    }

    return executeWithNetwork(
      onlineCall: () async {
        final unit = await remoteDataSource.getUnitDetails(id);
        _cachedUnitDetails[id] = _CacheEntry(data: unit, timestamp: DateTime.now());
        return unit;
      },
      offlineFallback: () async {
        if (_cachedUnitDetails.containsKey(id)) return _cachedUnitDetails[id]!.data;
        throw Exception('Cache missing');
      },
    );
  }

  @override
  Future<Either<Failure, RoomDetailsEntity>> getRoomDetails(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedRoomDetails[id]?.isValid == true) {
      return Right(_cachedRoomDetails[id]!.data);
    }

    return executeWithNetwork(
      onlineCall: () async {
        final roomDetails = await remoteDataSource.getRoomDetails(id);
        _cachedRoomDetails[id] = _CacheEntry(data: roomDetails, timestamp: DateTime.now());
        return roomDetails;
      },
      offlineFallback: () async {
        if (_cachedRoomDetails.containsKey(id)) return _cachedRoomDetails[id]!.data;
        throw Exception('Cache missing');
      },
    );
  }

  void invalidateUnitCache(int id) {
    _cachedUnitDetails.remove(id);
  }

  void invalidateRoomCache(int id) {
    _cachedRoomDetails.remove(id);
  }

  @override
  Future<Either<Failure, FinishingOrderEntity>> submitFinishingOrder(FinishingOrderRequestEntity request) async {
    return executeWithNetwork(
      isMutation: true,
      onlineCall: () async {
        final requestModel = FinishingOrderRequestModel.fromEntity(request);
        return await remoteDataSource.submitFinishingOrder(requestModel);
      },
    );
  }

  @override
  Future<Either<Failure, AiRendersEntity>> getAiRenders(int orderId) async {
    return executeWithNetwork(
      onlineCall: () => remoteDataSource.getAiRenders(orderId),
    );
  }

  @override
  Future<Either<Failure, SavedDesignEntity>> saveDesign(SaveDesignRequestModel request) async {
    return executeWithNetwork(
      isMutation: true,
      onlineCall: () => remoteDataSource.saveDesign(request),
    );
  }

  @override
  Future<Either<Failure, List<String>>> getPresetNotes() async {
    return executeWithNetwork(
      onlineCall: () => remoteDataSource.getPresetNotes(),
    );
  }

  @override
  Future<Either<Failure, List<RoomCustomerRendersEntity>>> getCustomerRenders(int apartmentId) async {
    return executeWithNetwork(
      onlineCall: () async {
        final renders = await remoteDataSource.getCustomerRenders(apartmentId);
        return renders.cast<RoomCustomerRendersEntity>();
      },
    );
  }

  @override
  Future<Either<Failure, bool>> toggleCustomerRenderFavorite(int apartmentId, String imageUrl) async {
    return executeWithNetwork(
      isMutation: true,
      onlineCall: () => remoteDataSource.toggleCustomerRenderFavorite(apartmentId, imageUrl),
    );
  }

  @override
  Future<Either<Failure, List<FinishingProgressStageEntity>>> getFinishingProgress(int apartmentId) async {
    return executeWithNetwork(
      onlineCall: () async {
        final progress = await remoteDataSource.getFinishingProgress(apartmentId);
        return progress.cast<FinishingProgressStageEntity>();
      },
    );
  }
}
