// lib/core/config/environment.dart
enum AppEnvironment { dev, staging, prod }

extension AppEnvironmentExtension on AppEnvironment {
  String get envFile {
    switch (this) {
      case AppEnvironment.prod:
        return '.env.prod';
      case AppEnvironment.staging:
        return '.env.staging';
      default:
        return '.env.dev';
    }
  }
}