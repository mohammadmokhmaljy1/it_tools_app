abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://it-tools-e-store-api.vercel.app/api/v1',
  );
}
