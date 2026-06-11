import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';

class ContentTypeOption {
  const ContentTypeOption({
    required this.id,
    required this.icon,
    required this.color,
  });

  final String id;
  final IconData icon;
  final Color color;
}

const contentTypeOptions = [
  ContentTypeOption(id: 'novel', icon: Icons.auto_stories_rounded, color: Color(0xFF6C9EFF)),
  ContentTypeOption(id: 'book', icon: Icons.menu_book_rounded, color: Color(0xFF81C784)),
  ContentTypeOption(id: 'article', icon: Icons.article_rounded, color: Color(0xFFFFB74D)),
  ContentTypeOption(id: 'poem', icon: Icons.format_quote_rounded, color: Color(0xFFCE93D8)),
  ContentTypeOption(id: 'news', icon: Icons.newspaper_rounded, color: Color(0xFFEF5350)),
  ContentTypeOption(id: 'encyclopedia', icon: Icons.school_rounded, color: Color(0xFF4DD0E1)),
];

String contentTypeLabel(AppLocalizations l10n, String id) {
  return switch (id) {
    'book' => l10n.contentTypeBook,
    'article' => l10n.contentTypeArticle,
    'poem' => l10n.contentTypePoem,
    'news' => l10n.contentTypeNews,
    'novel' => l10n.contentTypeNovel,
    'encyclopedia' => l10n.contentTypeEncyclopedia,
    _ => id,
  };
}

ContentTypeOption? contentTypeOption(String id) {
  for (final o in contentTypeOptions) {
    if (o.id == id) return o;
  }
  return null;
}
