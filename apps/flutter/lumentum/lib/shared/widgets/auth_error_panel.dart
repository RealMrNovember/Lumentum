import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/auth/auth_failure.dart';

class AuthErrorPanel extends StatefulWidget {
  const AuthErrorPanel({super.key, required this.failure});

  final AuthFailure failure;

  @override
  State<AuthErrorPanel> createState() => _AuthErrorPanelState();
}

class _AuthErrorPanelState extends State<AuthErrorPanel> {
  bool _expanded = false;

  IconData get _icon => switch (widget.failure.kind) {
        AuthFailureKind.invalidCredentials => Icons.lock_outline,
        AuthFailureKind.license => Icons.vpn_key_off_outlined,
        AuthFailureKind.network => Icons.wifi_off_rounded,
        AuthFailureKind.validation => Icons.warning_amber_rounded,
        AuthFailureKind.server => Icons.cloud_off_outlined,
        AuthFailureKind.unknown => Icons.error_outline,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDebug = kDebugMode &&
        (widget.failure.debugDetail != null ||
            widget.failure.statusCode != null);

    return Material(
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_icon, color: theme.colorScheme.error, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.failure.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            if (hasDebug) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? 'Detayları gizle' : 'Teknik detay'),
              ),
              if (_expanded)
                SelectableText(
                  [
                    if (widget.failure.statusCode != null)
                      'HTTP ${widget.failure.statusCode}',
                    if (widget.failure.debugDetail != null)
                      widget.failure.debugDetail!,
                  ].join('\n'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
