import 'dart:convert';
import 'dart:io';

void main() async {
  final fileEn = File('lib/l10n/app_en.arb');
  final fileAr = File('lib/l10n/app_ar.arb');

  final contentEn = await fileEn.readAsString();
  final contentAr = await fileAr.readAsString();

  final Map<String, dynamic> jsonEn = json.decode(contentEn);
  final Map<String, dynamic> jsonAr = json.decode(contentAr);

  final newKeysEn = {
    'orderNumberCopiedSuccessfully': 'Order number copied successfully',
    'reviewAndSignContracts': 'Review & Sign Contracts',
    'finalTotalCost': 'Final Total Cost',
    'contractsRequiredForSignature': 'Contracts Required For Signature',
    'propertySaleContract': 'Property Sale Contract',
    'unitDetailsDefault': 'Unit Details',
    'unitDetailsWithArea': 'Unit {title} with area {area}m²',
    'finishingContract': 'Finishing Contract',
    'customFinishingComprehensive': 'Custom finishing including materials and labor',
    'completeBookingAndPayment': 'Complete Booking & Payment',
    'signNow': 'Sign Now',
    'italianMarble': 'Italian Marble',
    'italianMarbleDesc': 'Provides a luxurious feel and cool touch. Ideal for open spaces.',
    'luxuriousTag': 'Luxurious',
    'spanishPorcelain': 'Spanish Porcelain',
    'spanishPorcelainDesc': 'High durability, variety in designs and colors, easy to clean.',
    'practicalTag': 'Practical',
    'germanParquet': 'German Parquet',
    'germanParquetDesc': 'Adds warmth and natural elegance to the space, suitable for bedrooms.',
    'warmTag': 'Warm',
    'spcFlooring': 'SPC Flooring',
    'spcFlooringDesc': 'Water and moisture resistant, practical and economical choice with a modern touch.',
    'economicalTag': 'Economical',
    'jotunFenomasticPaint': 'Jotun Fenomastic Paint',
    'highQualityWashablePaint': 'High-quality washable paint',
    'frenchWallpaper': 'French Wallpaper',
    'luxuriousClassicDesigns': 'Luxurious classic designs',
    'flatGypsumBoard': 'Flat Gypsum Board',
    'flatCeilingWithHiddenLighting': 'Flat ceiling with hidden lighting',
    'modernTag': 'Modern',
    'beechWoodDoors': 'Beech Wood Doors',
    'durableDoorsClassicDesigns': 'Durable doors with classic designs',
    'classicTag': 'Classic'
  };

  final newKeysAr = {
    'orderNumberCopiedSuccessfully': 'تم نسخ رقم الطلب بنجاح',
    'reviewAndSignContracts': 'مراجعة وتوقيع العقود',
    'finalTotalCost': 'إجمالي التكلفة النهائية',
    'contractsRequiredForSignature': 'العقود المطلوبة للتوقيع',
    'propertySaleContract': 'عقد بيع وحدة عقارية',
    'unitDetailsDefault': 'تفاصيل الوحدة',
    'unitDetailsWithArea': 'وحدة {title} بمساحة {area}م²',
    'finishingContract': 'عقد مقاولة تشطيب',
    'customFinishingComprehensive': 'تشطيب مخصص شامل الخامات والمصنعية',
    'completeBookingAndPayment': 'إتمام الحجز والدفع',
    'signNow': 'توقيع الآن',
    'italianMarble': 'رخام إيطالي',
    'italianMarbleDesc': 'يعطي طابعاً فخماً وملمساً بارداً. مثالي للمساحات المفتوحة.',
    'luxuriousTag': 'فاخر',
    'spanishPorcelain': 'بورسلين إسباني',
    'spanishPorcelainDesc': 'متانة عالية وتنوع في التصاميم والألوان، سهل التنظيف.',
    'practicalTag': 'عملي',
    'germanParquet': 'باركيه ألماني',
    'germanParquetDesc': 'يضفي دفئاً ورونقاً طبيعياً للمكان، مناسب لغرف النوم.',
    'warmTag': 'دافئ',
    'spcFlooring': 'أرضيات SPC',
    'spcFlooringDesc': 'مقاوم للماء والرطوبة، خيار عملي واقتصادي بلمسة عصرية.',
    'economicalTag': 'اقتصادي',
    'jotunFenomasticPaint': 'دهان جوتن فينوماستيك',
    'highQualityWashablePaint': 'دهان عالي الجودة قابل للغسيل',
    'frenchWallpaper': 'ورق حائط فرنسي',
    'luxuriousClassicDesigns': 'تصاميم كلاسيكية فاخرة',
    'flatGypsumBoard': 'جبس بورد فلات',
    'flatCeilingWithHiddenLighting': 'سقف مستوي مع إضاءة مخفية',
    'modernTag': 'عصري',
    'beechWoodDoors': 'أبواب خشب زان',
    'durableDoorsClassicDesigns': 'أبواب متينة بتصاميم كلاسيكية',
    'classicTag': 'كلاسيك'
  };

  jsonEn.addAll(newKeysEn);
  jsonAr.addAll(newKeysAr);
  
  // Metadata for parameter
  jsonEn['@unitDetailsWithArea'] = {
      'placeholders': {
          'title': {'type': 'String'},
          'area': {'type': 'String'}
      }
  };
  jsonAr['@unitDetailsWithArea'] = {
      'placeholders': {
          'title': {'type': 'String'},
          'area': {'type': 'String'}
      }
  };

  const encoder = JsonEncoder.withIndent('  ');
  await fileEn.writeAsString(encoder.convert(jsonEn));
  await fileAr.writeAsString(encoder.convert(jsonAr));
}
