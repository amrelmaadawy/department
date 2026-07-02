import 'dart:developer' as developer;

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String value);
}

class AppAnalyticsService implements AnalyticsService {
  final List<Map<String, dynamic>> loggedEventsHistory = [];

  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    final eventRecord = {
      'event_name': name,
      'parameters': parameters ?? {},
      'timestamp': DateTime.now().toIso8601String(),
    };
    loggedEventsHistory.add(eventRecord);
    developer.log('Analytics Event Tracked: $name | params: $parameters', name: 'AppAnalyticsService');
  }

  @override
  Future<void> setUserId(String? userId) async {
    developer.log('Analytics User ID Set: $userId', name: 'AppAnalyticsService');
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    developer.log('Analytics User Property Set: $name = $value', name: 'AppAnalyticsService');
  }
}
