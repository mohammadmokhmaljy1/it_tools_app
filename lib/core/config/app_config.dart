abstract final class AppConfig {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://it-tools-e-store-api.vercel.app/api/v1',
  );

  static bool get isDev => appEnv == 'dev';
  static bool get isProd => appEnv == 'prod';
}
