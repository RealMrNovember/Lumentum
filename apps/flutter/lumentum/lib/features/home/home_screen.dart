import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/reading/reading_preferences_provider.dart';
import '../../shared/widgets/lumentum_scaffold.dart';
import '../library/library_document.dart';
import '../library/library_provider.dart';
import '../library/library_screen.dart';
import '../reader/reader_screen.dart';
import '../shell/shell_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AuthProvider>().user!;
    final library = context.watch<LibraryProvider>();
    final prefs = context.watch<ReadingPreferencesProvider>();
    final lastDoc = prefs.lastDocumentId != null
        ? library.findById(prefs.lastDocumentId!)
        : library.lastOpened;

    return LumentumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: LumentumSectionHeader(
                  title: l10n.welcomeUser(user.firstName),
                  subtitle: l10n.homeSubtitle,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 148,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildListDelegate([
                    _QuickCard(
                      icon: Icons.library_books_rounded,
                      color: const Color(0xFF6C9EFF),
                      title: l10n.navLibrary,
                      subtitle: l10n.documentsCount(library.documents.length),
                      onTap: () => context.read<ShellNavigation>().goTo(1),
                    ),
                    _QuickCard(
                      icon: Icons.picture_as_pdf_rounded,
                      color: const Color(0xFFFF8A65),
                      title: l10n.importPdf,
                      subtitle: l10n.addToLibraryHint,
                      onTap: () {
                        context.read<ShellNavigation>().goTo(1);
                        LibraryScreen.openImportSheet(context);
                      },
                    ),
                    _QuickCard(
                      icon: Icons.speed_rounded,
                      color: const Color(0xFF81C784),
                      title: l10n.trainYourSpeed,
                      subtitle: l10n.sessionsCount(prefs.completedSessions),
                      onTap: () => _openReader(context, lastDoc),
                    ),
                    _QuickCard(
                      icon: Icons.explore_rounded,
                      color: const Color(0xFFB39DDB),
                      title: l10n.navExplore,
                      subtitle: l10n.exploreSubtitle,
                      onTap: () => context.read<ShellNavigation>().goTo(2),
                    ),
                  ]),
                ),
              ),
              if (lastDoc != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: _ContinueCard(
                      title: lastDoc.title,
                      words: lastDoc.wordCount,
                      onContinue: () => _openReader(context, lastDoc),
                    ),
                  ),
                ),
              if (user.licenseExpiresAt != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Chip(
                      avatar: const Icon(Icons.schedule, size: 18),
                      label: Text(
                        l10n.trialActiveUntil(
                          user.licenseExpiresAt!.split('T').first,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openReader(BuildContext context, LibraryDocument? doc) {
    if (doc == null || doc.text.isEmpty) {
      context.read<ShellNavigation>().goTo(1);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          initialText: doc.text,
          documentId: doc.id,
          documentTitle: doc.title,
          immersive: true,
        ),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.title,
    required this.words,
    required this.onContinue,
  });

  final String title;
  final int words;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.play_arrow_rounded),
        ),
        title: Text(l10n.continueReading),
        subtitle: Text('$title · ${l10n.wordCount(words)}'),
        trailing: FilledButton(
          onPressed: onContinue,
          child: Text(l10n.continueButton),
        ),
      ),
    );
  }
}
