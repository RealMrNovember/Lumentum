import 'package:flutter/material.dart';
import 'package:lumentum_shared/lumentum_shared.dart';

import '../../../core/theme/app_theme.dart';

class RsvpCanvas extends StatelessWidget {
  const RsvpCanvas({
    super.key,
    required this.token,
    this.focusIndex = 0,
  });

  final TokenData? token;
  final int focusIndex;

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return const SizedBox(height: 80);
    }

    final word = token!.token;
    final idx = token!.focusIndex.clamp(0, word.isEmpty ? 0 : word.length - 1);
    final before = word.substring(0, idx);
    final focus = idx < word.length ? word[idx] : '';
    final after = idx + 1 < word.length ? word.substring(idx + 1) : '';

    final baseStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    return SizedBox(
      height: 100,
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(
                text: before,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.55),
                ),
              ),
              TextSpan(
                text: focus,
                style: TextStyle(
                  color: AppTheme.focusColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: after,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
