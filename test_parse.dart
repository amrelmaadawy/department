import 'dart:convert';
import 'package:apartment/features/profile/data/models/profile_model.dart';

void main() {
  final jsonStr = '''{
    "success": true,
    "message": "بيانات الحساب",
    "data": {
        "user": {
            "id": 26,
            "name": "Customer Nam",
            "email": "testamr@gmail.com",
            "phone": "01146773221",
            "address": null,
            "bio": null,
            "avatar_url": null,
            "is_active": true,
            "ai_credits": 48,
            "member_since": "2026-06-15T15:54:08+00:00"
        },
        "statistics": {
            "total_orders": 2,
            "completed_orders": 2,
            "pending_orders": 0,
            "draft_orders": 0,
            "total_saved_designs": 2,
            "total_apartments": 0,
            "total_ai_images": 2,
            "total_spent": 48150
        },
        "apartments": [],
        "recent_orders": [
            {
                "id": 33,
                "status": "completed",
                "status_label": "مكتمل",
                "order_type": "manual",
                "order_type_label": "اختيار يدوي",
                "style": "modern",
                "total_cost": 22500,
                "notes": null,
                "ai_status": "completed",
                "ai_status_label": "جاهز",
                "ai_renders": [
                    {
                        "room_id": 135,
                        "room_name": "غرفة نوم رئيسية",
                        "url": "https://moqlate.coderaeg.com/storage/ai_renders/order_33_room_135_1781542776.jpg"
                    }
                ],
                "images": [
                    "https://moqlate.coderaeg.com/storage/ai_renders/order_33_room_135_1781542776.jpg"
                ],
                "created_at": "2026-06-15T16:59:23+00:00",
                "updated_at": "2026-06-15T16:59:36+00:00",
                "apartment": {
                    "id": 73,
                    "number": "101",
                    "name": "نموذج A",
                    "area": 123,
                    "project_name": "لين 1",
                    "project_id": 6,
                    "floor_number": 1
                }
            }
        ],
        "saved_designs": [
            {
                "id": 11,
                "name": "تصميم لشقة نموذج A",
                "style": "japandi",
                "style_label": "جاباندي",
                "total_cost": 25650,
                "selections": [
                    {
                        "room_id": 223,
                        "material_ids": [
                            4,
                            6,
                            7
                        ]
                    }
                ],
                "image_url": "https://moqlate.coderaeg.com/storage/ai_renders/order_4_room_223_1781502461.jpg",
                "images": [
                    "https://moqlate.coderaeg.com/storage/ai_renders/order_4_room_223_1781502461.jpg"
                ],
                "apartment": {
                    "id": 75,
                    "number": "201",
                    "name": "نموذج A",
                    "floor_number": 2,
                    "building_number": 1,
                    "location_type": "front_right",
                    "location_type_label": "أمامي يمين",
                    "area": 123,
                    "status": "available",
                    "status_label": "متاحة",
                    "base_price": 470000,
                    "images": [
                        "https://moqlate.coderaeg.com/storage/projects/1781443851_نموذج_A.JPG"
                    ]
                },
                "created_at": "2026-06-15T17:12:26+00:00",
                "updated_at": "2026-06-15T17:12:26+00:00"
            }
        ],
        "ai_gallery": [
            {
                "url": "https://moqlate.coderaeg.com/storage/ai_renders/order_33_room_135_1781542776.jpg",
                "order_id": 33,
                "room_name": "غرفة نوم رئيسية",
                "created_at": "2026-06-15T16:59:23+00:00"
            }
        ]
    }
}''';
  
  try {
    final Map<String, dynamic> data = json.decode(jsonStr);
    final profile = ProfileModel.fromJson(data['data']);
    print('Parsed successfully: \${profile.user.name}');
    print('Recent order image url: \${profile.recentOrders.first.imageUrl}');
    print('Recent order project: \${profile.recentOrders.first.projectName}');
    print('Saved design room: \${profile.savedDesigns.first.roomName}');
  } catch (e, stacktrace) {
    print('Error: \$e');
    print(stacktrace);
  }
}
