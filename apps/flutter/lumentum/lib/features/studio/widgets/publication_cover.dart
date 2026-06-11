import 'package:flutter/material.dart';
import 'package:lumentum_shared/lumentum_shared.dart';

import '../content_types.dart';

class PublicationCover extends StatelessWidget {
  const PublicationCover({
    super.key,
    required this.api,
    this.coverUrl,
    required this.contentType,
    this.height = 200,
    this.borderRadius = 12,
  });

  final LumentumApiClient api;
  final String? coverUrl;
  final String contentType;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final option = contentTypeOption(contentType);
    final resolved = coverUrl != null ? api.resolveAssetUrl(coverUrl) : '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: resolved.isNotEmpty
            ? Image.network(
                resolved,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Placeholder(option: option),
              )
            : _Placeholder(option: option),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.option});

  final ContentTypeOption? option;

  @override
  Widget build(BuildContext context) {
    final color = option?.color ?? Theme.of(context).colorScheme.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.25),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          option?.icon ?? Icons.book_rounded,
          size: 48,
          color: Colors.white.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}
