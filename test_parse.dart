import 'dart:convert';
import 'package:apartment/features/profile/data/models/profile_model.dart';

void main() {
  final jsonStr = '''{
    "success": true,
    "message": "بيانات الحساب",
    "data": {
        "user": {
            "id": 25,
            "name": "Customer Nam",
            "email": "testamr@gmail.com",
            "phone": "01146773221",
            "address": null,
            "bio": null,
            "avatar_url": null,
            "is_active": true,
            "ai_credits": 48,
            "member_since": "2026-06-15T13:19:24+00:00"
        },
        "statistics": {
            "total_orders": 5,
            "completed_orders": 5,
            "pending_orders": 0,
            "draft_orders": 0,
            "total_saved_designs": 1,
            "total_apartments": 0,
            "total_ai_images": 5,
            "total_spent": 112004.4
        },
        "apartments": [],
        "recent_orders": [
            {
                "id": 23,
                "status": "completed",
                "status_label": "مكتمل",
                "order_type": "manual",
                "order_type_label": "اختيار يدوي",
                "total_cost": "25255.40",
                "style": "classic",
                "created_at": "2026-06-03T18:03:07.000000Z"
            }
        ],
        "saved_designs": [
            {
                "id": 3,
                "customer_id": 25,
                "apartment_id": 75,
                "name": "تصميم لشقة نموذج A",
                "style": "japandi",
                "total_cost": "25650.00",
                "selections": [
                    {
                        "room_id": 223,
                        "material_ids": [4, 6, 7]
                    }
                ],
                "updated_at": "2026-06-15T14:12:32.000000Z",
                "created_at": "2026-06-15T14:12:32.000000Z",
                "image_url": "https://moqlate.coderaeg.com/storage/ai_renders/order_4_room_223_1781502461.jpg"
            }
        ],
        "ai_gallery": []
    }
}''';
  
  try {
    final Map<String, dynamic> data = json.decode(jsonStr);
    final profile = ProfileModel.fromJson(data['data']);
    print('Parsed successfully: \${profile.user.name}');
  } catch (e, stacktrace) {
    print('Error: \$e');
    print(stacktrace);
  }
}
