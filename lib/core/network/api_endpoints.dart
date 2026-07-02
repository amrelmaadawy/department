import 'package:apartment/core/config/app_config.dart';

class ApiEndpoints {
  // Base URLs
  static String get baseUrl => AppConfig.baseUrl;
  static const String imageBaseUrl = 'https://moqlate.coderaeg.com/storage/'; 

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  // Projects
  static const String projects = '/projects';
  static const String apartments = '/apartments';
  static const String rooms = '/rooms';
  static const String finishingOrders = '/finishing-orders';
  static String getAiRenders(int orderId) => '/finishing-orders/$orderId/ai-renders';
  static String customerRenders(int apartmentId) => '/apartments/$apartmentId/customer-renders';
  static String customizationDraft(int apartmentId) => '/apartments/$apartmentId/customization-draft';
  static String contractStatuses(String unitId) => '/apartments/$unitId/contract-statuses';

  // Future endpoints can be added here
  static const String savedDesigns = '/saved-designs';
  static const String packages = '/packages';

  // Customer Journey
  static const String activeJourneys = '/customer/active-journeys';

  // Settings
  static const String presetNotes = '/settings/preset-notes';
  // ── Settings ───────────────────────────────────────────────────────────────
  static const String generalSettings = '/settings/general';
}
