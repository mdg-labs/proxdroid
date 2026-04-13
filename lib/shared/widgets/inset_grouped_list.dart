import 'package:flutter/material.dart';

/// Card-like grouped surface with §2.3 large corner radius (16) and horizontal
/// inset (§2.4).
class InsetGroupedList extends StatelessWidget {
  const InsetGroupedList({
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.radius = 16,
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: margin,
      child: Material(
        color: scheme.surfaceContainer,
        surfaceTintColor: scheme.surfaceTint,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
