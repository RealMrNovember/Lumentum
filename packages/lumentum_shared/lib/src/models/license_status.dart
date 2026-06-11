class LicenseStatus {
  const LicenseStatus({
    required this.email,
    required this.status,
    required this.planTier,
    this.expiresAt,
  });

  final String email;
  final String status;
  final String planTier;
  final String? expiresAt;

  bool get isActive => status == 'active';

  factory LicenseStatus.fromJson(Map<String, dynamic> json) {
    return LicenseStatus(
      email: json['email'] as String,
      status: json['status'] as String,
      planTier: json['plan_tier'] as String,
      expiresAt: json['expires_at'] as String?,
    );
  }
}
