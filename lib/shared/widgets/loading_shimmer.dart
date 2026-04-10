import 'package:flutter/material.dart';

/// Placeholder list rows while async data loads (Material 3).
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({this.itemCount = 8, super.key});

  final int itemCount;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = (_controller.value + index * 0.08) % 1.0;
              final opacity = 0.35 + 0.35 * (1 - (t - 0.5).abs() * 2);
              return Opacity(opacity: opacity.clamp(0.25, 0.85), child: child);
            },
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
