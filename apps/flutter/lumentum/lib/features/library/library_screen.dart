import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/files/pdf_file_picker.dart';
import '../../core/files/picked_pdf_file.dart';
import '../../core/reading/reading_preferences_provider.dart';
import '../../shared/widgets/lumentum_scaffold.dart';
import '../reader/reader_screen.dart';
import 'library_document.dart';
import 'library_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static void openImportSheet(BuildContext context) {
    _LibraryActions.showAddSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final library = context.watch<LibraryProvider>();

    if (!library.ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return LumentumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: LumentumSectionHeader(
                  title: l10n.navLibrary,
                  subtitle: l10n.librarySubtitle,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _LibraryActions.importPdf(context),
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          label: Text(l10n.importPdf),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _LibraryActions.showPasteDialog(context),
                          icon: const Icon(Icons.text_fields_rounded),
                          label: Text(l10n.addDocument),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              if (library.documents.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyLibrary(onAdd: () => openImportSheet(context)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList.separated(
                    itemCount: library.documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doc = library.documents[index];
                      return _DocumentCard(document: doc);
                    },
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: library.documents.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () => openImportSheet(context),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addDocument),
              )
            : null,
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.libraryEmptyTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.libraryEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(l10n.getStartedLibrary),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final LibraryDocument document;

  IconData get _icon => switch (document.source) {
        'pdf' => Icons.picture_as_pdf_rounded,
        'demo' => Icons.science_outlined,
        _ => Icons.article_rounded,
      };

  Color _accent(BuildContext context) => switch (document.source) {
        'pdf' => const Color(0xFFFF8A65),
        'demo' => const Color(0xFF81C784),
        _ => Theme.of(context).colorScheme.primary,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _accent(context);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openReader(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.wordCount(document.wordCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.55),
                          ),
                    ),
                  ],
                ),
              ),
              if (!document.isDemo)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () =>
                      context.read<LibraryProvider>().remove(document.id),
                ),
              Icon(Icons.chevron_right_rounded,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }

  void _openReader(BuildContext context) {
    context.read<ReadingPreferencesProvider>().setLastDocumentId(document.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          initialText: document.text,
          documentId: document.id,
          documentTitle: document.title,
          immersive: true,
        ),
      ),
    );
  }
}

class _LibraryActions {
  static Future<void> showAddSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded),
                title: Text(l10n.importPdf),
                subtitle: Text(l10n.importPdfHint),
                onTap: () {
                  Navigator.pop(ctx);
                  importPdf(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.text_fields_rounded),
                title: Text(l10n.addDocument),
                subtitle: Text(l10n.pasteTextHint),
                onTap: () {
                  Navigator.pop(ctx);
                  showPasteDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showPasteDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final textCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addDocument),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(labelText: l10n.documentTitle),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                decoration: InputDecoration(labelText: l10n.pasteText),
                maxLines: 8,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      final title = titleCtrl.text.trim();
      final text = textCtrl.text.trim();
      if (title.isNotEmpty && text.isNotEmpty) {
        await context.read<LibraryProvider>().addFromText(
              title: title,
              text: text,
            );
      }
    }
    titleCtrl.dispose();
    textCtrl.dispose();
  }

  static Future<void> importPdf(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    PickedPdfFile? picked;
    try {
      picked = await pickPdfFile();
    } catch (e) {
      if (context.mounted) {
        _showError(context, '${l10n.pdfImportFailed}\n$e');
      }
      return;
    }

    if (picked == null || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(l10n.pdfImporting)),
          ],
        ),
      ),
    );

    try {
      final api = context.read<AuthProvider>().api;
      final extracted = await api.extractPdf(
        bytes: picked.bytes,
        filename: picked.name,
      );
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await context.read<LibraryProvider>().addFromText(
            title: extracted.title,
            text: extracted.text,
            source: 'pdf',
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${extracted.title} ${l10n.pdfImportSuccess}')),
        );
      }
    } on LumentumApiException catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showError(context, e.body);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showError(context, '${l10n.pdfImportFailed}\n$e');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
