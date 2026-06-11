class AuthorBrief {
  const AuthorBrief({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String firstName;
  final String lastName;

  String get displayName => '$firstName $lastName'.trim();

  factory AuthorBrief.fromJson(Map<String, dynamic> json) {
    return AuthorBrief(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}
