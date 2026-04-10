import 'package:flutter/material.dart';

/// Vertical section block: optional [header] plus [child], with §2.4 rhythm
/// (8px grid; default 24px top gap before the block).
class GroupedSection extends StatelessWidget {
  const GroupedSection({
    required this.child,
    this.header,
    this.topSpacing = 24,
    this.gapAfterHeader = 0,
    super.key,
  });

  /// Optional label row (e.g. [SectionHeader]).
  final Widget? header;

  /// Primary content for this section.
  final Widget child;

  /// Space above this section (use `0` for the first block in a list).
  final double topSpacing;

  /// Extra space between [header] and [child] when both are non-null.
  final double gapAfterHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!,
          if (header != null && gapAfterHeader > 0)
            SizedBox(height: gapAfterHeader),
          child,
        ],
      ),
    );
  }
}
