import 'package:apartment/features/home/data/models/project_unit_model.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1 - Ownership Parsing in ProjectUnitModel', () {
    test('should correctly parse is_current_user_unit from JSON response', () {
      final json = {
        'id': '101',
        'name': 'شقة ديلوكس 101',
        'number': '101',
        'building_number': 2,
        'location_type': 'corner',
        'location_type_label': 'ناصية',
        'rooms_count': 3,
        'area': 140.5,
        'base_price': 1500000.0,
        'floor_number': 3,
        'status': 'reserved',
        'status_label': 'محجوزة',
        'is_current_user_unit': true,
        'images': [],
      };

      final model = ProjectUnitModel.fromJson(json);

      expect(model.isCurrentUserUnit, true);
      expect(model.status, UnitStatus.reserved);
      expect(model.id, '101');
    });

    test('should serialize is_current_user_unit properly in toJson', () {
      const model = ProjectUnitModel(
        id: '102',
        title: 'شقة 102',
        isCurrentUserUnit: true,
        unitNumber: '102',
        buildingNumber: 1,
        locationType: '',
        locationTypeLabel: '',
        roomsCount: 2,
        statusLabel: 'محجوزة',
        type: UnitType.apartment,
        area: 120.0,
        bedrooms: 2,
        bathrooms: 2,
        price: 1200000.0,
        status: UnitStatus.reserved,
        imagePath: '',
        floor: 1,
        extras: [],
        description: '',
        images: [],
      );

      final json = model.toJson();
      expect(json['is_current_user_unit'], true);
    });
  });
}
