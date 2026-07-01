enum AppEnvironment { dev, staging, prod }

class AppConfig {
  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static AppEnvironment get environment {
    switch (_env) {
      case 'prod':
        return AppEnvironment.prod;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.dev;
    }
  }

  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.prod:
        return 'https://moqlate.coderaeg.com/api/v1';
      case AppEnvironment.staging:
        return 'https://staging.moqlate.coderaeg.com/api/v1';
      case AppEnvironment.dev:
        return 'https://moqlate.coderaeg.com/api/v1';
    }
  }

  static bool get isProduction => environment == AppEnvironment.prod;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isDevelopment => environment == AppEnvironment.dev;

  static bool get enableSSLPinning => environment != AppEnvironment.dev;

  static bool get enableLogging => environment == AppEnvironment.dev;
}
