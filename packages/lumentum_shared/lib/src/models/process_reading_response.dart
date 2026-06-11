import 'token_data.dart';

class ProcessReadingResponse {
  const ProcessReadingResponse({
    required this.result,
    required this.source,
    this.error,
  });

  final List<TokenData> result;
  final String source;
  final String? error;

  factory ProcessReadingResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['result'] as List<dynamic>? ?? [];
    return ProcessReadingResponse(
      result: raw
          .map((e) => TokenData.fromJson(e as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? 'unknown',
      error: json['error'] as String?,
    );
  }
}
