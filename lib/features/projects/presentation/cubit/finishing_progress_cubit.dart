import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_finishing_progress_usecase.dart';
import 'finishing_progress_state.dart';

class FinishingProgressCubit extends Cubit<FinishingProgressState> {
  final GetFinishingProgressUseCase getFinishingProgressUseCase;

  FinishingProgressCubit({
    required this.getFinishingProgressUseCase,
  }) : super(FinishingProgressInitial());

  Future<void> loadFinishingProgress(int apartmentId) async {
    emit(FinishingProgressLoading());
    final result = await getFinishingProgressUseCase(apartmentId);
    
    result.fold(
      (failure) => emit(FinishingProgressError(failure.message)),
      (stages) {
        if (stages.isEmpty) {
          emit(const FinishingProgressLoaded(stages: [], totalProgress: 0, activeStageName: ''));
          return;
        }

        // Calculate total progress (average of all stages)
        int totalSum = 0;
        String activeStage = stages.first.name; // default to first
        bool foundActive = false;

        for (final stage in stages) {
          totalSum += stage.progressPercent;
          
          if (!foundActive && stage.status == 'in_progress') {
            activeStage = stage.name;
            foundActive = true;
          }
        }
        
        // If none is in_progress, maybe all are completed, or all are pending.
        if (!foundActive) {
          final pendingStage = stages.where((s) => s.status == 'pending').firstOrNull;
          if (pendingStage != null) {
            activeStage = pendingStage.name;
          } else {
            // all completed
            activeStage = 'مكتمل';
          }
        }

        final totalProgress = (totalSum / stages.length).round();

        emit(FinishingProgressLoaded(
          stages: stages,
          totalProgress: totalProgress,
          activeStageName: activeStage,
        ));
      },
    );
  }
}
