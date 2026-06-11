import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/lumentum_config.dart';
import '../models/health_response.dart';
import '../models/process_reading_response.dart';

/// Merkezi Lumentum API istemcisi — tüm platformlar aynı beyne bağlanır.
class LumentumApiClient {
  LumentumApiClient({
    LumentumConfig config = LumentumConfig.production,
    http.Client? httpClient,
  })  : _config = config,
        _http = httpClient ?? http.Client();

  final LumentumConfig _config;
  final http.Client _http;

  Future<HealthResponse> health() async {
    final uri = Uri.parse('${_config.apiBase}/health');
    final response = await _http.get(uri).timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return HealthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<ProcessReadingResponse> processReading(String text) async {
    final uri = Uri.parse('${_config.apiBase}/reading/process');
    final response = await _http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'text': text}),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return ProcessReadingResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LumentumApiException(response.statusCode, response.body);
    }
  }

  void close() => _http.close();
}

class LumentumApiException implements Exception {
  LumentumApiException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'LumentumApiException($statusCode): $body';
}
