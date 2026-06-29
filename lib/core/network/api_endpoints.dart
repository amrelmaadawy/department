class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://moqlate.coderaeg.com/api/v1'; // Assuming api/v1, adjust if needed
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

  // Future endpoints can be added here
  static const String savedDesigns = '/saved-designs';
  static const String packages = '/packages';

  // Settings
  static const String presetNotes = '/settings/preset-notes';
  // ── Settings ───────────────────────────────────────────────────────────────
  static const String generalSettings = '/settings/general';
}
