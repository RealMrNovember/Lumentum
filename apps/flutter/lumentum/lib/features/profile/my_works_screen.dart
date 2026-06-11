import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../studio/content_types.dart';
import '../studio/publication_detail_screen.dart';
import '../studio/write_publication_screen.dart';

class MyWorksScreen extends StatefulWidget {
  const MyWorksScreen({super.key});

  @override
  State<MyWorksScreen> createState() => _MyWorksScreenState();
}

class _MyWorksScreenState extends State<MyWorksScreen> {
  List<PublicationListItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final feed = await context.read<AuthProvider>().api.myPublications();
      if (!mounted) return;
      setState(() {
        _items = feed.items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myWorks)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const WritePublicationScreen()),
          );
          if (ok == true) _load();
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.writeContent),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text(l10n.myWorksEmpty))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: Text(item.title),
                      subtitle: Text(contentTypeLabel(l10n, item.contentType)),
                      trailing: Text('${item.likeCount} ♥'),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              PublicationDetailScreen(publicationId: item.id),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
