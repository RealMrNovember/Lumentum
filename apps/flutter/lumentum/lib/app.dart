import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/auth/auth_provider.dart';
import 'core/i18n/locale_provider.dart';
import 'core/reading/reading_preferences_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/library/library_provider.dart';
import 'features/license/license_gate_screen.dart';
import 'features/shell/app_shell.dart';
import 'features/showcase/showcase_screen.dart';

class LumentumApp extends StatelessWidget {
  const LumentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'Lumentum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('en');
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return const Locale('en');
      },
      home: const _RootGate(),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final locale = context.watch<LocaleProvider>();

    final library = context.watch<LibraryProvider>();
    final readingPrefs = context.watch<ReadingPreferencesProvider>();

    if (auth.loading || !locale.ready || !library.ready || !readingPrefs.ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.isAuthenticated) {
      final user = auth.user!;
      if (!user.hasActiveLicense) return const LicenseGateScreen();
      return const AppShell();
    }
    return const ShowcaseScreen();
  }
}
