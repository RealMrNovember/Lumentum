import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/i18n/language_switcher.dart';
import '../../core/reading/reading_preferences_provider.dart';
import '../../shared/widgets/lumentum_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final prefs = context.watch<ReadingPreferencesProvider>();

    return LumentumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              LumentumSectionHeader(title: l10n.navSettings),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: Text(l10n.language),
                      subtitle: const LanguageSwitcher(),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.speed_rounded),
                      title: Text(l10n.speed),
                      subtitle: Text('${prefs.speedFactor.toStringAsFixed(1)}x · ${l10n.sessionsCount(prefs.completedSessions)}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error),
                  title: Text(l10n.logout),
                  onTap: () => auth.logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
