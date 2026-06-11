import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/lumentum_config.dart';
import '../models/auth_response.dart';
import '../models/health_response.dart';
import '../models/license_status.dart';
import '../models/pdf_extract_result.dart';
import '../models/process_reading_response.dart';
import '../models/publication.dart';
import '../models/user.dart';

/// Merkezi Lumentum API istemcisi — tüm platformlar aynı beyne bağlanır.
class LumentumApiClient {
  LumentumApiClient({
    LumentumConfig config = LumentumConfig.production,
    http.Client? httpClient,
  })  : _config = config,
        _http = httpClient ?? http.Client();

  final LumentumConfig _config;
  final http.Client _http;
  String? _accessToken;

  void setAccessToken(String? token) => _accessToken = token;

  Map<String, String> _headers({bool json = true}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  Future<HealthResponse> health() async {
    final uri = Uri.parse('${_config.apiBase}/health');
    final response = await _http.get(uri).timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return HealthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String hwid,
    String locale = 'tr',
    String platform = 'web',
  }) async {
    final uri = Uri.parse('${_config.apiBase}/auth/register');
    final response = await _http
        .post(
          uri,
          headers: _headers(),
          body: jsonEncode({
            'email': email,
            'password': password,
            'first_name': firstName,
            'last_name': lastName,
            'locale': locale,
            'hwid': hwid,
            'platform': platform,
          }),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    final auth = AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    _accessToken = auth.accessToken;
    return auth;
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
    required String hwid,
    String platform = 'web',
  }) async {
    final uri = Uri.parse('${_config.apiBase}/auth/login');
    final response = await _http
        .post(
          uri,
          headers: _headers(),
          body: jsonEncode({
            'email': email,
            'password': password,
            'hwid': hwid,
            'platform': platform,
          }),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    final auth = AuthResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    _accessToken = auth.accessToken;
    return auth;
  }

  Future<User> me() async {
    final uri = Uri.parse('${_config.apiBase}/auth/me');
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<LicenseStatus> licenseStatus() async {
    final uri = Uri.parse('${_config.apiBase}/license/status');
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return LicenseStatus.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<LicenseStatus> activateLicense({
    required String licenseKey,
    required String hwid,
    String platform = 'web',
  }) async {
    final uri = Uri.parse('${_config.apiBase}/license/activate');
    final response = await _http
        .post(
          uri,
          headers: _headers(),
          body: jsonEncode({
            'license_key': licenseKey,
            'hwid': hwid,
            'platform': platform,
          }),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    final status = LicenseStatus.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    return status;
  }

  Future<PdfExtractResult> extractPdf({
    required List<int> bytes,
    required String filename,
  }) async {
    final uri = Uri.parse('${_config.apiBase}/reading/extract-pdf');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers(json: false))
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename.endsWith('.pdf') ? filename : '$filename.pdf',
        ),
      );

    final streamed = await request.send().timeout(_config.connectTimeout);
    final response = await http.Response.fromStream(streamed);
    _ensureSuccess(response);
    return PdfExtractResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  String resolveAssetUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '${_config.baseUrl}$path';
  }

  Future<PublicationFeed> studioFeed({
    String? contentType,
    String? search,
    int limit = 24,
    int offset = 0,
  }) async {
    final query = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (contentType != null) 'content_type': contentType,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final uri = Uri.parse('${_config.apiBase}/studio/feed')
        .replace(queryParameters: query);
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return PublicationFeed.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<PublicationFeed> myPublications() async {
    final uri = Uri.parse('${_config.apiBase}/studio/mine');
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return PublicationFeed.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<PublicationDetail> createPublication({
    required String title,
    String? summary,
    required String body,
    required String contentType,
    String status = 'published',
    List<String> tags = const [],
  }) async {
    final uri = Uri.parse('${_config.apiBase}/studio/publications');
    final response = await _http
        .post(
          uri,
          headers: _headers(),
          body: jsonEncode({
            'title': title,
            'summary': summary,
            'body': body,
            'content_type': contentType,
            'status': status,
            'tags': tags,
          }),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return PublicationDetail.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<PublicationDetail> getPublication(String id) async {
    final uri = Uri.parse('${_config.apiBase}/studio/publications/$id');
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return PublicationDetail.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<PublicationDetail> uploadPublicationCover({
    required String publicationId,
    required List<int> bytes,
    required String filename,
    required String mimeType,
  }) async {
    final uri =
        Uri.parse('${_config.apiBase}/studio/publications/$publicationId/cover');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers(json: false))
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: filename),
      );
    final streamed = await request.send().timeout(_config.connectTimeout);
    final response = await http.Response.fromStream(streamed);
    _ensureSuccess(response);
    return PublicationDetail.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<LikeResult> togglePublicationLike(String publicationId) async {
    final uri = Uri.parse(
      '${_config.apiBase}/studio/publications/$publicationId/like',
    );
    final response = await _http
        .post(uri, headers: _headers())
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return LikeResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<PublicationComment>> publicationComments(
    String publicationId,
  ) async {
    final uri = Uri.parse(
      '${_config.apiBase}/studio/publications/$publicationId/comments',
    );
    final response = await _http
        .get(uri, headers: _headers(json: false))
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PublicationComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PublicationComment> addPublicationComment({
    required String publicationId,
    required String body,
  }) async {
    final uri = Uri.parse(
      '${_config.apiBase}/studio/publications/$publicationId/comments',
    );
    final response = await _http
        .post(
          uri,
          headers: _headers(),
          body: jsonEncode({'body': body}),
        )
        .timeout(_config.connectTimeout);
    _ensureSuccess(response);
    return PublicationComment.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<ProcessReadingResponse> processReading(String text) async {
    final uri = Uri.parse('${_config.apiBase}/reading/process');
    final response = await _http
        .post(
          uri,
          headers: _headers(),
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
      throw LumentumApiException(
        response.statusCode,
        _formatErrorBody(response.body),
      );
    }
  }

  String _formatErrorBody(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return _formatErrorDetail(decoded['detail']) ?? raw;
      }
    } catch (_) {}
    return raw;
  }

  String? _formatErrorDetail(dynamic detail) {
    if (detail == null) return null;
    if (detail is String) return detail;
    if (detail is List) {
      final messages = detail
          .map((item) {
            if (item is Map && item['msg'] != null) {
              return item['msg'].toString();
            }
            return item.toString();
          })
          .where((m) => m.isNotEmpty)
          .toList();
      if (messages.isNotEmpty) return messages.join(' ');
    }
    return detail.toString();
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
