import 'package:lumentum_shared/lumentum_shared.dart';

enum AuthFailureKind {
  invalidCredentials,
  validation,
  license,
  network,
  server,
  unknown,
}

/// Yapılandırılmış auth hatası — UI ve loglama için.
class AuthFailure {
  const AuthFailure({
    required this.kind,
    required this.message,
    this.statusCode,
    this.debugDetail,
  });

  final AuthFailureKind kind;
  final String message;
  final int? statusCode;
  final String? debugDetail;

  factory AuthFailure.fromApi(LumentumApiException e) {
    final kind = switch (e.statusCode) {
      401 => AuthFailureKind.invalidCredentials,
      403 => AuthFailureKind.license,
      422 => AuthFailureKind.validation,
      >= 500 => AuthFailureKind.server,
      _ => AuthFailureKind.server,
    };
    return AuthFailure(
      kind: kind,
      message: e.body,
      statusCode: e.statusCode,
      debugDetail: 'HTTP ${e.statusCode}',
    );
  }

  factory AuthFailure.network(String message, {String? detail}) {
    return AuthFailure(
      kind: AuthFailureKind.network,
      message: message,
      debugDetail: detail,
    );
  }

  factory AuthFailure.unknown(Object error, [String? stack]) {
    return AuthFailure(
      kind: AuthFailureKind.unknown,
      message: error.toString(),
      debugDetail: stack,
    );
  }
}
