import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../reader/reader_screen.dart';
import 'content_types.dart';
import 'widgets/publication_cover.dart';

class PublicationDetailScreen extends StatefulWidget {
  const PublicationDetailScreen({super.key, required this.publicationId});

  final String publicationId;

  @override
  State<PublicationDetailScreen> createState() =>
      _PublicationDetailScreenState();
}

class _PublicationDetailScreenState extends State<PublicationDetailScreen> {
  PublicationDetail? _pub;
  List<PublicationComment> _comments = [];
  final _commentCtrl = TextEditingController();
  bool _loading = true;
  bool _submittingComment = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = context.read<AuthProvider>().api;
      final pub = await api.getPublication(widget.publicationId);
      final comments = await api.publicationComments(widget.publicationId);
      if (!mounted) return;
      setState(() {
        _pub = pub;
        _comments = comments;
        _loading = false;
      });
    } on LumentumApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.body;
        _loading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    final pub = _pub;
    if (pub == null) return;
    try {
      final result =
          await context.read<AuthProvider>().api.togglePublicationLike(pub.id);
      if (!mounted) return;
      setState(() {
        _pub = PublicationDetail(
          id: pub.id,
          title: pub.title,
          summary: pub.summary,
          body: pub.body,
          contentType: pub.contentType,
          coverUrl: pub.coverUrl,
          status: pub.status,
          tags: pub.tags,
          likeCount: result.likeCount,
          commentCount: pub.commentCount,
          viewCount: pub.viewCount,
          likedByMe: result.liked,
          author: pub.author,
          createdAt: pub.createdAt,
          updatedAt: pub.updatedAt,
        );
      });
    } on LumentumApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.body)),
      );
    }
  }

  Future<void> _postComment() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty || _pub == null) return;
    setState(() => _submittingComment = true);
    try {
      final comment = await context.read<AuthProvider>().api.addPublicationComment(
            publicationId: _pub!.id,
            body: text,
          );
      if (!mounted) return;
      setState(() {
        _comments = [..._comments, comment];
        _pub = PublicationDetail(
          id: _pub!.id,
          title: _pub!.title,
          summary: _pub!.summary,
          body: _pub!.body,
          contentType: _pub!.contentType,
          coverUrl: _pub!.coverUrl,
          status: _pub!.status,
          tags: _pub!.tags,
          likeCount: _pub!.likeCount,
          commentCount: _pub!.commentCount + 1,
          viewCount: _pub!.viewCount,
          likedByMe: _pub!.likedByMe,
          author: _pub!.author,
          createdAt: _pub!.createdAt,
          updatedAt: _pub!.updatedAt,
        );
        _commentCtrl.clear();
        _submittingComment = false;
      });
    } on LumentumApiException catch (e) {
      if (!mounted) return;
      setState(() => _submittingComment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.body)),
      );
    }
  }

  void _readWithLumentum() {
    final pub = _pub;
    if (pub == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          initialText: pub.body,
          documentTitle: pub.title,
          immersive: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final api = context.read<AuthProvider>().api;

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildContent(context, l10n, api),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    LumentumApiClient api,
  ) {
    final pub = _pub!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              pub.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            background: PublicationCover(
              api: api,
              coverUrl: pub.coverUrl,
              contentType: pub.contentType,
              height: 280,
              borderRadius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(pub.author.firstName.isNotEmpty
                          ? pub.author.firstName[0].toUpperCase()
                          : '?'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pub.author.displayName,
                              style: Theme.of(context).textTheme.titleSmall),
                          Text(
                            contentTypeLabel(l10n, pub.contentType),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (pub.summary != null && pub.summary!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(pub.summary!, style: Theme.of(context).textTheme.bodyLarge),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _toggleLike,
                      icon: Icon(
                        pub.likedByMe
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: pub.likedByMe ? Colors.pinkAccent : null,
                      ),
                    ),
                    Text('${pub.likeCount}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    const SizedBox(width: 6),
                    Text('${pub.commentCount}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.visibility_outlined, size: 20),
                    const SizedBox(width: 6),
                    Text('${pub.viewCount}'),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _readWithLumentum,
                      icon: const Icon(Icons.bolt_rounded),
                      label: Text(l10n.readWithLumentum),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.publicationBody,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SelectableText(
                  pub.body,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.commentsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentCtrl,
                        decoration: InputDecoration(
                          hintText: l10n.addCommentHint,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _submittingComment ? null : _postComment,
                      child: _submittingComment
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ..._comments.map(
                  (c) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(c.author.displayName),
                      subtitle: Text(c.body),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
