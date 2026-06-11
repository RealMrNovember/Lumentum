import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Desteklenen diller (Arapça hariç).
const supportedLanguageCodes = ['tr', 'en', 'de', 'fr', 'es'];

class LocaleProvider extends ChangeNotifier {
  static const _prefKey = 'lumentum_locale';

  Locale? _locale;
  bool _ready = false;

  Locale? get locale => _locale;
  bool get ready => _ready;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved != null && supportedLanguageCodes.contains(saved)) {
      _locale = Locale(saved);
    } else {
      _locale = _resolveSystemLocale();
    }
    _ready = true;
    notifyListeners();
  }

  Locale _resolveSystemLocale() {
    final sys = WidgetsBinding.instance.platformDispatcher.locale;
    final code = sys.languageCode.toLowerCase();
    if (supportedLanguageCodes.contains(code)) {
      return Locale(code);
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLanguageCodes.contains(locale.languageCode)) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
    notifyListeners();
  }
}
