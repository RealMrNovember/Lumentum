import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show ClientException;
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../device/device_id.dart';
import 'auth_failure.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required LumentumApiClient api}) : _api = api;

  static const _tokenKey = 'lumentum_access_token';

  final LumentumApiClient _api;

  User? _user;
  bool _loading = true;
  AuthFailure? _failure;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;
  AuthFailure? get failure => _failure;
  String? get error => _failure?.message;
  LumentumApiClient get api => _api;

  void _log(String message, [Object? detail]) {
    if (kDebugMode) {
      debugPrint('[Auth] $message${detail != null ? ': $detail' : ''}');
    }
  }

  Future<void> bootstrap() async {
    _loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null) {
        _api.setAccessToken(token);
        _user = await _api.me();
        _log('Session restored', _user?.email);
      }
    } catch (e, st) {
      _log('Bootstrap failed', e);
      if (kDebugMode) debugPrint(st.toString());
      await _clearSession();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _failure = null;
    notifyListeners();
    try {
      _log('Login attempt', email);
      final hwid = await DeviceId.getOrCreate();
      final auth = await _api.login(
        email: email,
        password: password,
        hwid: hwid,
        platform: kIsWeb ? 'web' : 'desktop',
      );
      _user = auth.user;
      await _persistToken(auth.accessToken);
      _log('Login success', '${_user?.email} (${_user?.licenseStatus})');
      notifyListeners();
      return true;
    } on LumentumApiException catch (e, st) {
      _failure = AuthFailure.fromApi(e);
      _log('Login API error', '${e.statusCode} ${e.body}');
      if (kDebugMode) debugPrint(st.toString());
      notifyListeners();
      return false;
    } on TimeoutException catch (e) {
      _failure = AuthFailure.network(
        'Sunucuya bağlanılamadı (zaman aşımı).',
        detail: e.message,
      );
      _log('Login timeout', e);
      notifyListeners();
      return false;
    } on ClientException catch (e) {
      _failure = AuthFailure.network(
        'Ağ hatası: sunucuya ulaşılamadı.',
        detail: e.message,
      );
      _log('Login network error', e);
      notifyListeners();
      return false;
    } catch (e, st) {
      _failure = AuthFailure.unknown(e, kDebugMode ? st.toString() : null);
      _log('Login unexpected error', e);
      if (kDebugMode) debugPrint(st.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String locale = 'en',
  }) async {
    _failure = null;
    notifyListeners();
    try {
      final hwid = await DeviceId.getOrCreate();
      final auth = await _api.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        locale: locale,
        hwid: hwid,
        platform: kIsWeb ? 'web' : 'desktop',
      );
      _user = auth.user;
      await _persistToken(auth.accessToken);
      notifyListeners();
      return true;
    } on LumentumApiException catch (e) {
      _failure = AuthFailure.fromApi(e);
      notifyListeners();
      return false;
    } on TimeoutException catch (e) {
      _failure = AuthFailure.network(
        'Sunucuya bağlanılamadı (zaman aşımı).',
        detail: e.message,
      );
      notifyListeners();
      return false;
    } catch (e, st) {
      _failure = AuthFailure.unknown(e, kDebugMode ? st.toString() : null);
      if (kDebugMode) debugPrint(st.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> activateLicense(String licenseKey) async {
    _failure = null;
    notifyListeners();
    try {
      final hwid = await DeviceId.getOrCreate();
      final status = await _api.activateLicense(
        licenseKey: licenseKey,
        hwid: hwid,
        platform: kIsWeb ? 'web' : 'desktop',
      );
      if (!status.isActive) {
        _failure = const AuthFailure(
          kind: AuthFailureKind.license,
          message: 'Lisans aktif değil.',
        );
        notifyListeners();
        return false;
      }
      await refreshUser();
      return true;
    } on LumentumApiException catch (e) {
      _failure = AuthFailure.fromApi(e);
      notifyListeners();
      return false;
    } catch (e, st) {
      _failure = AuthFailure.unknown(e, kDebugMode ? st.toString() : null);
      if (kDebugMode) debugPrint(st.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshUser() async {
    try {
      _user = await _api.me();
      notifyListeners();
    } on LumentumApiException catch (e) {
      _failure = AuthFailure.fromApi(e);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _clearSession();
    notifyListeners();
  }

  Future<void> _persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearSession() async {
    _user = null;
    _failure = null;
    _api.setAccessToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
