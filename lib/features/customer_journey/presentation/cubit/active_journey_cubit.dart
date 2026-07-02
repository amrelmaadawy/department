import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/active_journey_entity.dart';
import '../../domain/usecases/get_active_journeys_usecase.dart';
import 'active_journey_state.dart';

class ActiveJourneyCubit extends Cubit<ActiveJourneyState> {
  final GetActiveJourneysUseCase getActiveJourneysUseCase;

  ActiveJourneyCubit({required this.getActiveJourneysUseCase})
      : super(ActiveJourneyInitial());

  Future<void> loadActiveJourneys() async {
    emit(ActiveJourneyLoading());

    final result = await getActiveJourneysUseCase();

    result.fold(
      (failure) => emit(ActiveJourneyError(failure.message)),
      (journeys) {
        final sortedList = List<ActiveJourneyEntity>.from(journeys);
        _sortJourneys(sortedList);
        emit(ActiveJourneyLoaded(sortedList));
      },
    );
  }

  void _sortJourneys(List<ActiveJourneyEntity> journeys) {
    journeys.sort((a, b) {
      if (a.reservationExpiresAt != null && b.reservationExpiresAt != null) {
        final cmp = a.reservationExpiresAt!.compareTo(b.reservationExpiresAt!);
        if (cmp != 0) return cmp;
      } else if (a.reservationExpiresAt != null && b.reservationExpiresAt == null) {
        return -1;
      } else if (a.reservationExpiresAt == null && b.reservationExpiresAt != null) {
        return 1;
      }

      if (a.lastUpdatedAt != null && b.lastUpdatedAt != null) {
        return b.lastUpdatedAt!.compareTo(a.lastUpdatedAt!);
      } else if (a.lastUpdatedAt != null && b.lastUpdatedAt == null) {
        return -1;
      } else if (a.lastUpdatedAt == null && b.lastUpdatedAt != null) {
        return 1;
      }

      return 0;
    });
  }
}
