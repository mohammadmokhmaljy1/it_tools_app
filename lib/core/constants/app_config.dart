class AppConfig {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://example.com',
  );

  static bool get isDev => appEnv == 'dev';
  static bool get isProd => appEnv == 'prod';
}
