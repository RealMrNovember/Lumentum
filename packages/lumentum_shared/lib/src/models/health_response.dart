class HealthResponse {
  const HealthResponse({
    required this.status,
    required this.hasRust,
    required this.hasCli,
    required this.architecture,
  });

  final String status;
  final bool hasRust;
  final bool hasCli;
  final String architecture;

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      status: json['status'] as String,
      hasRust: json['has_rust'] as bool,
      hasCli: json['has_cli'] as bool,
      architecture: json['architecture'] as String? ?? 'shared',
    );
  }
}
