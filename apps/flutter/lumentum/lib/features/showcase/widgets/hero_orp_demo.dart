import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumentum_shared/lumentum_shared.dart';

import '../../../core/theme/app_theme.dart';

/// Cycling ORP demo for the showcase hero — mirrors the real reader focus UX.
class HeroOrpDemo extends StatefulWidget {
  const HeroOrpDemo({super.key});

  @override
  State<HeroOrpDemo> createState() => _HeroOrpDemoState();
}

class _HeroOrpDemoState extends State<HeroOrpDemo> {
  static const _samples = [
    TokenData(token: 'Lumentum', focusIndex: 2, paceMs: 380),
    TokenData(token: 'bilişsel', focusIndex: 2, paceMs: 420),
    TokenData(token: 'nöroplastisite', focusIndex: 4, paceMs: 520),
    TokenData(token: 'özümser', focusIndex: 2, paceMs: 360),
    TokenData(token: 'çünkü', focusIndex: 1, paceMs: 180),
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: _samples[_index].paceMs),
      () {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % _samples.length);
        _schedule();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = _samples[_index];
    final word = token.token;
    final idx = token.focusIndex.clamp(0, word.length > 0 ? word.length - 1 : 0);
    final before = word.substring(0, idx);
    final focus = idx < word.length ? word[idx] : '';
    final after = idx + 1 < word.length ? word.substring(idx + 1) : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        color: Colors.white.withValues(alpha: 0.04),
        boxShadow: [
          BoxShadow(
            color: AppTheme.focusColor.withValues(alpha: 0.08),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
          children: [
            TextSpan(
              text: before,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
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
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            ),
          ],
        ),
      ),
    );
  }
}
