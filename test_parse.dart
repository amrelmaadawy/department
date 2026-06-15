import 'dart:convert';
import 'package:apartment/features/projects/data/models/project_model.dart';

void main() {
  final jsonStr = '''{
    "success": true,
    "message": "تفاصيل المشروع",
    "data": {
        "id": 6,
        "name": "لين 1",
        "building_area": 300,
        "description": "مشروع لين 1 هو مشروع ضخم جدا يهدف الي بيع وحدات سكنيه بشكل رائع",
        "features": [
            "تشطيبات فاخرة",
            "كاميرات مراقبة",
            "اسقف عالية وفندقية",
            "مصعد فل اوتوماتيك",
            "مدخل فندقي ومكيف",
            "دش مركزي",
            "دهانات حديثة",
            "مواقف خاصة",
            "خزانات مستقلة",
            "إنارة مانعة للتوهج"
        ],
        "is_featured": true,
        "location": "جدة - حي التيسير - مخطط شمس العرو",
        "status": "available",
        "images": [
            "https://moqlate.coderaeg.com/storage/projects/1781450435_WhatsApp_Image_2026-06-10_at_7.26.20_PM.jpeg",
            "https://moqlate.coderaeg.com/storage/projects/1781450441_WhatsApp_Image_2026-06-10_at_10.16.48_PM.jpeg",
            "https://moqlate.coderaeg.com/storage/projects/1781450441_WhatsApp_Image_2026-06-10_at_10.32.33_PM.jpeg",
            "https://moqlate.coderaeg.com/storage/projects/1781410518_WhatsApp_Image_2026-06-13_at_9.06.08_PM.jpeg"
        ],
        "apartments_count": 8
    }
}''';
  
  try {
    final Map<String, dynamic> data = json.decode(jsonStr);
    final project = ProjectModel.fromJson(data['data']);
    print('Project Images length: \${project.images.length}');
    for (int i = 0; i < project.images.length; i++) {
        print('Image \$i: \${project.images[i]}');
        final uri = Uri.parse(project.images[i]);
        print('  Valid URI: \${uri.isAbsolute}');
    }
  } catch (e, stacktrace) {
    print('Error: \$e');
    print(stacktrace);
  }
}
