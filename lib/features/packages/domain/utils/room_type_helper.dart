import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class RoomTypeHelper {
  static String translate(String type) {
    final clean = type.trim().toLowerCase();
    const translations = {
      'kitchen': 'المطبخ',
      'salon': 'الصالون',
      'bedroom': 'غرفة النوم',
      'bathroom': 'الحمام',
      'balcony': 'البلكونة',
      'living_room': 'غرفة المعيشة',
      'men_majlis': 'مجلس رجال',
      'women_majlis': 'مجلس نساء',
      'majlis': 'المجلس',
      'master_bedroom': 'غرفة نوم رئيسية',
      'guest_bedroom': 'غرفة نوم ضيوف',
      'kids_bedroom': 'غرفة أطفال',
      'kids_room': 'غرفة أطفال',
      'guest_bathroom': 'حمام ضيوف',
      'master_bathroom': 'حمام رئيسي',
      'terrace': 'التراس',
      'dining_room': 'غرفة الطعام',
      'office': 'المكتب',
      'corridor': 'الممر',
      'laundry': 'غرفة الغسيل',
      'dressing_room': 'غرفة الملابس',
      'gym': 'الصالة الرياضية',
      'cinema': 'السينما',
      'garden': 'الحديقة',
      'storage': 'المخزن',
    };

    if (translations.containsKey(clean)) {
      return translations[clean]!;
    }

    // Dynamic formatting fallback for new dashboard types: remove underscores and capitalize cleanly
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(type)) {
      return type;
    }

    return type
        .replaceAll(RegExp(r'[\-_]+'), ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  static IconData getIcon(String type) {
    final clean = type.toLowerCase();
    if (clean.contains('kitchen') || clean.contains('مطبخ')) {
      return FluentIcons.food_24_regular;
    }
    if (clean.contains('salon') ||
        clean.contains('living') ||
        clean.contains('majlis') ||
        clean.contains('مجلس') ||
        clean.contains('معيش') ||
        clean.contains('ريسبشن')) {
      return FluentIcons.tv_24_regular;
    }
    if (clean.contains('bed') || clean.contains('نوم')) {
      return FluentIcons.bed_24_regular;
    }
    if (clean.contains('bath') ||
        clean.contains('toilet') ||
        clean.contains('حمام')) {
      return FluentIcons.drop_24_regular;
    }
    if (clean.contains('garden') ||
        clean.contains('balcony') ||
        clean.contains('terrace') ||
        clean.contains('حديق') ||
        clean.contains('تراس')) {
      return FluentIcons.leaf_one_24_regular;
    }
    return FluentIcons.home_24_regular;
  }
}
