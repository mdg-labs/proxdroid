import 'package:flutter/material.dart';

/// Themed [SegmentedButton] with §2.3 stadium shape from [SegmentedButtonThemeData].
///
/// Track and selected fills use global [ThemeData.segmentedButtonTheme] (Phase C
/// Stitch: `surfaceContainerHigh` track, `primaryContainer` selection).
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

    /// When true, segments share width across the parent (via [SegmentedButton.expandedInsets]).
    this.expandToWidth = false,
    super.key,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T> selected) onSelectionChanged;
  final EdgeInsetsGeometry padding;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final bool expandToWidth;

  @override
  Widget build(BuildContext context) {
    final button = SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      expandedInsets: expandToWidth ? EdgeInsets.zero : null,
    );
    return Padding(
      padding: padding,
      child:
          expandToWidth
              ? SizedBox(width: double.infinity, child: button)
              : button,
    );
  }
}
