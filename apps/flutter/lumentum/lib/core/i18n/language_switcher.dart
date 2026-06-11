import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.compact = false});

  final bool compact;

  static const _labels = {
    'tr': 'TR',
    'en': 'EN',
    'de': 'DE',
    'fr': 'FR',
    'es': 'ES',
  };

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final code = locale?.languageCode ?? 'en';
    final l10n = AppLocalizations.of(context);

    if (compact) {
      return PopupMenuButton<String>(
        tooltip: l10n?.language ?? 'Language',
        initialValue: code,
        onSelected: (value) {
          context.read<LocaleProvider>().setLocale(Locale(value));
        },
        itemBuilder: (context) => supportedLanguageCodes
            .map(
              (c) => PopupMenuItem(
                value: c,
                child: Text(_labels[c] ?? c.toUpperCase()),
              ),
            )
            .toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 18),
              const SizedBox(width: 4),
              Text(_labels[code] ?? code.toUpperCase()),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 6,
      children: supportedLanguageCodes.map((c) {
        final selected = c == code;
        return ChoiceChip(
          label: Text(_labels[c] ?? c.toUpperCase()),
          selected: selected,
          onSelected: (_) {
            context.read<LocaleProvider>().setLocale(Locale(c));
          },
        );
      }).toList(),
    );
  }
}
