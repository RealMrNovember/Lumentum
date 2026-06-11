import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../shared/widgets/lumentum_scaffold.dart';
import 'content_types.dart';
import 'publication_detail_screen.dart';
import 'widgets/publication_cover.dart';
import 'write_publication_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchCtrl = TextEditingController();
  List<PublicationListItem> _items = [];
  bool _loading = true;
  String? _error;
  String? _filterType;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = context.read<AuthProvider>().api;
      final feed = await api.studioFeed(
        contentType: _filterType,
        search: _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _items = feed.items;
        _loading = false;
      });
    } on LumentumApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.body;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final api = context.read<AuthProvider>().api;
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 1100 ? 4 : (width >= 700 ? 3 : 2);

    return LumentumBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final created = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const WritePublicationScreen()),
            );
            if (created == true) _load();
          },
          icon: const Icon(Icons.edit_rounded),
          label: Text(l10n.writeContent),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _load,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: LumentumSectionHeader(
                    title: l10n.navExplore,
                    subtitle: l10n.exploreSubtitle,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText: l10n.searchPublications,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: IconButton(
                          onPressed: _load,
                          icon: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ),
                      onSubmitted: (_) => _load(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _FilterChip(
                          label: l10n.filterAll,
                          selected: _filterType == null,
                          onTap: () {
                            setState(() => _filterType = null);
                            _load();
                          },
                        ),
                        ...contentTypeOptions.map(
                          (o) => _FilterChip(
                            label: contentTypeLabel(l10n, o.id),
                            selected: _filterType == o.id,
                            onTap: () {
                              setState(() => _filterType = o.id);
                              _load();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_error != null)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _load,
                              child: Text(l10n.refresh),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (_items.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_stories_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 16),
                            Text(
                              l10n.exploreEmpty,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const WritePublicationScreen(),
                                ),
                              ),
                              icon: const Icon(Icons.edit_rounded),
                              label: Text(l10n.writeFirstStory),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _items[index];
                          return _PublicationGridCard(
                            item: item,
                            api: api,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PublicationDetailScreen(
                                    publicationId: item.id,
                                  ),
                                ),
                              );
                              _load();
                            },
                          );
                        },
                        childCount: _items.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _PublicationGridCard extends StatelessWidget {
  const _PublicationGridCard({
    required this.item,
    required this.api,
    required this.onTap,
  });

  final PublicationListItem item;
  final LumentumApiClient api;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PublicationCover(
                api: api,
                coverUrl: item.coverUrl,
                contentType: item.contentType,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.author.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.favorite_rounded,
                          size: 16,
                          color: item.likedByMe
                              ? Colors.pinkAccent
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Text('${item.likeCount}',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(width: 12),
                      const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                      const SizedBox(width: 4),
                      Text('${item.commentCount}',
                          style: Theme.of(context).textTheme.labelSmall),
                      const Spacer(),
                      Chip(
                        label: Text(
                          contentTypeLabel(l10n, item.contentType),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
