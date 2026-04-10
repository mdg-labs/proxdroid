import 'package:flutter/material.dart';

/// Themed [SegmentedButton] with §2.3 stadium shape from [SegmentedButtonThemeData].
///
/// Use for settings (theme mode) and chart timeframes (§3 / §9).
class PillSegmentedButton<T extends Object> extends StatelessWidget {
  const PillSegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    super.key,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T> selected) onSelectionChanged;
  final EdgeInsetsGeometry padding;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SegmentedButton<T>(
        segments: segments,
        selected: selected,
        onSelectionChanged: onSelectionChanged,
        multiSelectionEnabled: multiSelectionEnabled,
        emptySelectionAllowed: emptySelectionAllowed,
      ),
    );
  }
}
