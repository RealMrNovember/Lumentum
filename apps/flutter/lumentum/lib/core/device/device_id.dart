import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Tarayıcı/cihaz bazlı HWID — license.cicibyte.com trial/check için.
class DeviceId {
  static const _key = 'lumentum_hwid';
  static const _uuid = Uuid();

  static Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null && existing.length >= 8) return existing;
    final id = _uuid.v4();
    await prefs.setString(_key, id);
    return id;
  }
}
