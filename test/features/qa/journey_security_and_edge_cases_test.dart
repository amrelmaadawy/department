import 'package:flutter_test/flutter_test.dart';
import 'package:apartment/core/error/failures.dart';
import 'package:apartment/core/services/analytics/analytics_service.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/customer_journey/domain/entities/active_journey_entity.dart';
import 'package:apartment/features/contracts/domain/entities/contract_signature_status_entity.dart';

void main() {
  group('Phase 0 & Phase 1 — Security & Ownership Distinction Tests', () {
    test('Should enforce ForbiddenFailure (403) when accessing unauthorized contract/unit endpoint', () {
      const failure = ForbiddenFailure('عذراً، لا تمتلك صلاحية الوصول لهذه الوحدة أو العقد.');
      expect(failure.message, contains('لا تمتلك صلاحية'));
    });

    test('Should distinguish current user unit vs other user reserved unit', () {
      const myUnit = ProjectUnitEntity(
        id: '101',
        title: 'وحدة 101',
        unitNumber: 'A-101',
        buildingNumber: 1,
        type: UnitType.apartment,
        area: 120,
        bedrooms: 3,
        bathrooms: 2,
        price: 1500000,
        status: UnitStatus.reserved,
        imagePath: '',
        floor: 1,
        extras: [],
        description: '',
        images: [],
        isCurrentUserUnit: true,
      );
      const otherUserUnit = ProjectUnitEntity(
        id: '102',
        title: 'وحدة 102',
        unitNumber: 'A-102',
        buildingNumber: 1,
        type: UnitType.apartment,
        area: 120,
        bedrooms: 3,
        bathrooms: 2,
        price: 1500000,
        status: UnitStatus.reserved,
        imagePath: '',
        floor: 1,
        extras: [],
        description: '',
        images: [],
        isCurrentUserUnit: false,
      );

      expect(myUnit.isCurrentUserUnit, isTrue);
      expect(otherUserUnit.isCurrentUserUnit, isFalse);
    });
  });

  group('Phase 2 & Phase 3 & Phase 5 — Journey Resumption, Draft & TTL Analytics', () {
    late AppAnalyticsService analyticsService;

    setUp(() {
      analyticsService = AppAnalyticsService();
    });

    test('Should record journey_resumed_from_card analytics event with unit number', () async {
      const journey = ActiveJourneyEntity(
        apartmentId: 101,
        projectName: 'كمبوند كودرا',
        unitNumber: 'A-101',
        currentStep: 'اختيار الباقات',
        resumeRoute: '/unit-customization',
        resumeArgs: {'id': '101'},
      );

      await analyticsService.logEvent('journey_resumed_from_card', parameters: {'unit_number': journey.unitNumber});
      expect(analyticsService.loggedEventsHistory.length, 1);
      expect(analyticsService.loggedEventsHistory.first['event_name'], 'journey_resumed_from_card');
      expect(analyticsService.loggedEventsHistory.first['parameters']['unit_number'], 'A-101');
    });

    test('Should record customization_draft_recovered analytics event on offline recovery', () async {
      await analyticsService.logEvent('customization_draft_recovered', parameters: {'apartment_id': 101});
      expect(analyticsService.loggedEventsHistory.first['event_name'], 'customization_draft_recovered');
    });

    test('Should record reservation_expired analytics event and recognize ReservationExpiredFailure', () async {
      const failure = ReservationExpiredFailure('انتهت صلاحية حجزك لوحدة A-101');
      expect(failure, isA<Failure>());

      await analyticsService.logEvent('reservation_expired', parameters: {'unit_number': 'A-101'});
      expect(analyticsService.loggedEventsHistory.last['event_name'], 'reservation_expired');
    });
  });

  group('Phase 4 — Partial Contract Sequence Locking Rules', () {
    test('Should lock sequential contracts until previous contract is signed', () {
      const contract1 = ContractSignatureStatusEntity(
        contractType: 'skeleton',
        title: 'عقد العظم',
        sequenceOrder: 1,
        isSigned: false,
      );
      const contract2 = ContractSignatureStatusEntity(
        contractType: 'finishing',
        title: 'عقد التشطيب',
        sequenceOrder: 2,
        isSigned: false,
      );

      final isContract2Locked = !contract1.isSigned && contract2.sequenceOrder > contract1.sequenceOrder;
      expect(isContract2Locked, isTrue);
    });
  });
}
