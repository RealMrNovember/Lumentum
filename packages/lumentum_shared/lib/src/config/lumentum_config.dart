/// Merkezi API yapılandırması — platformlar yalnızca base URL değiştirir.
class LumentumConfig {
  const LumentumConfig({
    this.baseUrl = 'https://lumentum.cicibyte.com',
    this.apiPrefix = '/api',
    this.connectTimeout = const Duration(seconds: 15),
  });

  final String baseUrl;
  final String apiPrefix;
  final Duration connectTimeout;

  String get apiBase => '$baseUrl$apiPrefix';

  /// Yerel geliştirme
  static const local = LumentumConfig(baseUrl: 'http://localhost:8000');

  /// Production
  static const production = LumentumConfig();
}
