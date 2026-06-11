import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Okuma tercihleri — ileride adaptif CPS eğitimi için temel.
class ReadingPreferencesProvider extends ChangeNotifier {
  static const _speedKey = 'lumentum_read_speed';
  static const _lastDocKey = 'lumentum_last_doc_id';
  static const _sessionsKey = 'lumentum_read_sessions';

  double _speedFactor = 1.0;
  String? _lastDocumentId;
  int _completedSessions = 0;
  bool _ready = false;

  double get speedFactor => _speedFactor;
  String? get lastDocumentId => _lastDocumentId;
  int get completedSessions => _completedSessions;
  bool get ready => _ready;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _speedFactor = prefs.getDouble(_speedKey) ?? 1.0;
    _lastDocumentId = prefs.getString(_lastDocKey);
    _completedSessions = prefs.getInt(_sessionsKey) ?? 0;
    _ready = true;
    notifyListeners();
  }

  Future<void> setSpeedFactor(double value) async {
    _speedFactor = value.clamp(0.5, 2.5);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_speedKey, _speedFactor);
  }

  Future<void> setLastDocumentId(String? id) async {
    _lastDocumentId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_lastDocKey);
    } else {
      await prefs.setString(_lastDocKey, id);
    }
  }

  Future<void> recordCompletedSession() async {
    _completedSessions++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionsKey, _completedSessions);
  }
}
