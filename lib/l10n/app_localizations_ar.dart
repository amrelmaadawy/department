// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeTitle => 'شطبها بكيفك';

  @override
  String get welcomeSubtitle => 'ابنِ مساحتك الخاصة.. من العظم إلى الفخامة';

  @override
  String get startNow => 'ابدأ الآن';

  @override
  String get exploreAsHost => 'استكشف كمضيف';

  @override
  String get login => 'تسجيل دخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get next => 'التالي';

  @override
  String get orVia => 'أو عبر';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get registerAgreement => 'بالتسجيل، أنت توافق على';

  @override
  String get and => 'و';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navProjects => 'المشاريع';

  @override
  String get navDesign => 'صمم شقتك';

  @override
  String get navProposals => 'المقترح';

  @override
  String get navAccount => 'حسابي';

  @override
  String helloUser(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get riyadh => 'الرياض';

  @override
  String get promoTitle => 'ابنِ مساحتك..\nعلى ذوقك';

  @override
  String get exploreProjects => 'استكشف المشاريع';

  @override
  String get featuredProjects => 'المشاريع المميزة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get startsFrom => 'يبدأ من';

  @override
  String get sar => 'ر.س';
}
