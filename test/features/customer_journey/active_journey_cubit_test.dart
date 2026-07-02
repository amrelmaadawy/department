import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/features/customer_journey/domain/entities/active_journey_entity.dart';
import 'package:apartment/features/customer_journey/domain/repositories/customer_journey_repository.dart';
import 'package:apartment/features/customer_journey/domain/usecases/get_active_journeys_usecase.dart';
import 'package:apartment/features/customer_journey/presentation/cubit/active_journey_cubit.dart';
import 'package:apartment/features/customer_journey/presentation/cubit/active_journey_state.dart';

class FakeGetActiveJourneysUseCase implements GetActiveJourneysUseCase {
  Either<Failure, List<ActiveJourneyEntity>> result = const Right([]);

  @override
  CustomerJourneyRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, List<ActiveJourneyEntity>>> call() async => result;
}

void main() {
  group('Phase 2 - ActiveJourneyCubit Sorting Tests', () {
    late FakeGetActiveJourneysUseCase useCase;
    late ActiveJourneyCubit cubit;

    setUp(() {
      useCase = FakeGetActiveJourneysUseCase();
      cubit = ActiveJourneyCubit(getActiveJourneysUseCase: useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('should emit loaded state with sorted journeys by nearest reservationExpiresAt first', () async {
      final j1 = ActiveJourneyEntity(
        apartmentId: 1,
        projectName: 'P1',
        unitNumber: '101',
        currentStep: 'step1',
        reservationExpiresAt: DateTime(2026, 7, 20),
        resumeRoute: '/guide',
        resumeArgs: const {},
      );

      final j2 = ActiveJourneyEntity(
        apartmentId: 2,
        projectName: 'P2',
        unitNumber: '102',
        currentStep: 'step2',
        reservationExpiresAt: DateTime(2026, 7, 10), // Earlier expiration
        resumeRoute: '/guide',
        resumeArgs: const {},
      );

      const j3 = ActiveJourneyEntity(
        apartmentId: 3,
        projectName: 'P3',
        unitNumber: '103',
        currentStep: 'step3',
        reservationExpiresAt: null, // No expiration
        resumeRoute: '/guide',
        resumeArgs: {},
      );

      useCase.result = Right([j1, j3, j2]);

      await cubit.loadActiveJourneys();

      final state = cubit.state as ActiveJourneyLoaded;
      expect(state.journeys[0].apartmentId, 2); // 2026-07-10
      expect(state.journeys[1].apartmentId, 1); // 2026-07-20
      expect(state.journeys[2].apartmentId, 3); // null
    });

    test('should sort by lastUpdatedAt descending when reservationExpiresAt is null or equal', () async {
      final j1 = ActiveJourneyEntity(
        apartmentId: 1,
        projectName: 'P1',
        unitNumber: '101',
        currentStep: 'step1',
        reservationExpiresAt: null,
        lastUpdatedAt: DateTime(2026, 7, 1),
        resumeRoute: '/guide',
        resumeArgs: const {},
      );

      final j2 = ActiveJourneyEntity(
        apartmentId: 2,
        projectName: 'P2',
        unitNumber: '102',
        currentStep: 'step2',
        reservationExpiresAt: null,
        lastUpdatedAt: DateTime(2026, 7, 5), // More recent
        resumeRoute: '/guide',
        resumeArgs: const {},
      );

      useCase.result = Right([j1, j2]);

      await cubit.loadActiveJourneys();

      final state = cubit.state as ActiveJourneyLoaded;
      expect(state.journeys[0].apartmentId, 2); // 2026-07-05
      expect(state.journeys[1].apartmentId, 1); // 2026-07-01
    });
  });
}
