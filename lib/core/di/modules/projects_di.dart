import 'package:get_it/get_it.dart';

import 'package:apartment/features/projects/data/datasources/project_remote_data_source.dart';
import 'package:apartment/features/projects/data/repositories/project_repository_impl.dart';
import 'package:apartment/features/projects/domain/repositories/project_repository.dart';
import 'package:apartment/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_project_details_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_project_units_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_unit_details_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_room_details_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/submit_finishing_order_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/get_ai_renders_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/save_design_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/get_preset_notes_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/get_customer_renders_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/toggle_customer_render_favorite_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/calculate_unit_costs_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/check_duplicate_ai_design_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/check_finishing_edit_eligibility_use_case.dart';
import 'package:apartment/features/projects/data/datasources/customization_draft_remote_data_source.dart';
import 'package:apartment/features/projects/domain/usecases/get_customization_draft_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/save_customization_draft_use_case.dart';
import 'package:apartment/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/project_details_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/unit_details_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/room_details_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_room_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/ai_renders_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/comparison_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/save_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/share_design_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/download_image_cubit.dart';
import 'package:apartment/features/home/domain/usecases/share_design_usecase.dart';

Future<void> registerProjectsDi(GetIt sl) async {
  // Data Source
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CustomizationDraftRemoteDataSource>(
    () => CustomizationDraftRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: sl(),
      draftDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectUnitsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnitDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitFinishingOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetAiRendersUseCase(sl()));
  sl.registerLazySingleton(() => SaveDesignUseCase(sl()));
  sl.registerLazySingleton(() => GetPresetNotesUseCase(sl()));
  sl.registerLazySingleton(() => ShareDesignUseCase(shareService: sl()));
  sl.registerLazySingleton(() => GetCustomerRendersUseCase(sl()));
  sl.registerLazySingleton(() => ToggleCustomerRenderFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => CalculateUnitCostsUseCase(sl()));
  sl.registerLazySingleton(() => CheckDuplicateAiDesignUseCase(sl()));
  sl.registerLazySingleton(() => const CheckFinishingEditEligibilityUseCase());
  sl.registerLazySingleton(() => GetCustomizationDraftUseCase(sl()));
  sl.registerLazySingleton(() => SaveCustomizationDraftUseCase(sl()));

  // Cubits
  sl.registerFactory(() => ProjectsCubit(getProjectsUseCase: sl()));
  sl.registerFactory(() => ComparisonCubit());
  sl.registerFactory(
    () => ProjectDetailsCubit(
      getProjectDetailsUseCase: sl(),
      getProjectUnitsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UnitDetailsCubit(
      getUnitDetailsUseCase: sl(),
      getCustomerRendersUseCase: sl(),
      toggleCustomerRenderFavoriteUseCase: sl(),
      calculateUnitCostsUseCase: sl(),
      checkFinishingEditEligibilityUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RoomDetailsCubit(
      getRoomDetailsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AiRoomDesignCubit(
      submitFinishingOrderUseCase: sl(),
      getPresetNotesUseCase: sl(),
      cacheService: sl(),
    ),
  );
  sl.registerFactory(
    () => AiRendersCubit(
      getAiRendersUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => SaveDesignCubit(
      saveDesignUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ShareDesignCubit(
      shareDesignUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DownloadImageCubit(
      downloadService: sl(),
    ),
  );
}
