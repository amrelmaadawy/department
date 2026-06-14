import '../../domain/entities/room_details_entity.dart';
import 'finishing_category_model.dart';
import 'unit_room_model.dart';

class RoomDetailsModel extends RoomDetailsEntity {
  const RoomDetailsModel({
    required super.room,
    required super.finishingOptions,
  });

  factory RoomDetailsModel.fromJson(Map<String, dynamic> json) {
    List<FinishingCategoryModel> optionsList = [];
    if (json['finishing_options'] != null) {
      optionsList = (json['finishing_options'] as List)
          .map((o) => FinishingCategoryModel.fromJson(o))
          .toList();
    }

    return RoomDetailsModel(
      room: UnitRoomModel.fromJson(json['room'] ?? {}),
      finishingOptions: optionsList,
    );
  }
}
