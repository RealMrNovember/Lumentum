import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'web_plugin_registrant.dart' as web_plugins;
import 'core/auth/auth_provider.dart';
import 'core/i18n/locale_provider.dart';
import 'core/reading/reading_preferences_provider.dart';
import 'features/library/library_provider.dart';

LumentumConfig get _apiConfig {
  if (kReleaseMode) return LumentumConfig.production;
  return LumentumConfig.local;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    web_plugins.registerPlugins();
  }

  final api = LumentumApiClient(config: _apiConfig);
  final localeProvider = LocaleProvider()..bootstrap();
  final authProvider = AuthProvider(api: api)..bootstrap();
  final libraryProvider = LibraryProvider()..bootstrap();
  final readingPrefs = ReadingPreferencesProvider()..bootstrap();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: libraryProvider),
        ChangeNotifierProvider.value(value: readingPrefs),
      ],
      child: const LumentumApp(),
    ),
  );
}
