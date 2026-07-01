import 'package:flutter_test/flutter_test.dart';
import 'package:apartment/features/customer_journey/data/models/active_journey_model.dart';
import 'package:apartment/core/error/failures.dart';

void main() {
  group('Phase 0 - Active Journey Model & Security Layer Tests', () {
    test('ActiveJourneyModel correctly parses JSON response from GET /customer/active-journeys', () {
      final jsonResponse = {
        'apartment_id': 402,
        'project_name': 'سنيار',
        'unit_number': '402',
        'current_step': 'pending_finishing_contract',
        'reservation_expires_at': '2026-07-15T00:00:00Z',
        'resume_route': 'contracts_review',
        'resume_args': {'unit_id': 402, 'contract_type': 'finishing'}
      };

      final model = ActiveJourneyModel.fromJson(jsonResponse);

      expect(model.apartmentId, 402);
      expect(model.projectName, 'سنيار');
      expect(model.unitNumber, '402');
      expect(model.currentStep, 'pending_finishing_contract');
      expect(model.resumeRoute, 'contracts_review');
      expect(model.resumeArgs['unit_id'], 402);
    });

    test('ForbiddenFailure correctly formats message when server returns 403 Forbidden', () {
      const failure = ForbiddenFailure('عفواً، ليس لديك صلاحية للوصول إلى هذه الوحدة أو إجراء هذه العملية.');
      expect(failure.message, contains('ليس لديك صلاحية'));
    });
  });
}
