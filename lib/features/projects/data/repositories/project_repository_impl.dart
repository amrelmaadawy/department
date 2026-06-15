import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
import '../../../home/domain/entities/room_details_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

import 'package:apartment/features/projects/data/models/finishing_order_request_model.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_order_request_entity.dart';
import 'package:apartment/features/projects/domain/entities/ai_renders_entity.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final projects = await remoteDataSource.getProjects();
      return Right(projects);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProjectDetails(int id) async {
    try {
      final project = await remoteDataSource.getProjectDetails(id);
      return Right(project);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProjectUnitEntity>>> getProjectUnits(int id) async {
    try {
      final units = await remoteDataSource.getProjectUnits(id);
      return Right(units);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProjectUnitEntity>> getUnitDetails(int id) async {
    try {
      final unit = await remoteDataSource.getUnitDetails(id);
      return Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, RoomDetailsEntity>> getRoomDetails(int id) async {
    try {
      final roomDetails = await remoteDataSource.getRoomDetails(id);
      return Right(roomDetails);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, FinishingOrderEntity>> submitFinishingOrder(FinishingOrderRequestEntity request) async {
    try {
      final requestModel = FinishingOrderRequestModel.fromEntity(request);
      final response = await remoteDataSource.submitFinishingOrder(requestModel);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AiRendersEntity>> getAiRenders(int orderId) async {
    try {
      final response = await remoteDataSource.getAiRenders(orderId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
