import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated gradient mesh background for the showcase landing.
class ShowcaseBackground extends StatefulWidget {
  const ShowcaseBackground({super.key, required this.child});

  final Widget child;

  @override
  State<ShowcaseBackground> createState() => _ShowcaseBackgroundState();
}

class _ShowcaseBackgroundState extends State<ShowcaseBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value * 2 * math.pi;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(math.cos(t) * 0.3, -1),
              end: Alignment(math.sin(t) * 0.3, 1),
              colors: const [
                Color(0xFF070A12),
                Color(0xFF0F1528),
                Color(0xFF12182E),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -80 + math.sin(t) * 30,
                right: -60,
                child: _orb(const Color(0x336C9EFF), 280),
              ),
              Positioned(
                bottom: 120 + math.cos(t) * 40,
                left: -100,
                child: _orb(const Color(0x33FF6B6B), 220),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.35,
                left: MediaQuery.sizeOf(context).width * 0.5 - 100,
                child: _orb(const Color(0x228B5CF6), 160),
              ),
              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  Widget _orb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 80, spreadRadius: 20),
        ],
      ),
    );
  }
}
