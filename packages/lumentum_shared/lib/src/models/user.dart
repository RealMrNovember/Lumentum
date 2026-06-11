class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.locale,
    required this.emailVerified,
    required this.licenseStatus,
    required this.licensePlan,
    this.licenseExpiresAt,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String locale;
  final bool emailVerified;
  final String licenseStatus;
  final String licensePlan;
  final String? licenseExpiresAt;

  String get fullName => '$firstName $lastName';

  bool get hasActiveLicense =>
      licenseStatus == 'active' ||
      licenseStatus == 'trial' ||
      licenseStatus == 'pending';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      locale: json['locale'] as String? ?? 'tr',
      emailVerified: json['email_verified'] as bool? ?? false,
      licenseStatus: json['license_status'] as String? ?? 'pending',
      licensePlan: json['license_plan'] as String? ?? 'trial',
      licenseExpiresAt: json['license_expires_at'] as String?,
    );
  }
}
