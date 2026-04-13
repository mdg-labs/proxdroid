import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';

/// Scaffold for IDE / `flutter widget-preview` — keeps previews independent of
/// [MaterialApp], Riverpod, and native plugins (widget preview targets web).
Widget _previewFrame({required ThemeData theme, required Widget child}) {
  return Theme(
    data: theme,
    child: Material(
      color: theme.scaffoldBackgroundColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: child,
          ),
        ),
      ),
    ),
  );
}

@Preview(name: 'SectionHeader — emphasis (dark)', group: 'Shared')
Widget previewSectionHeaderEmphasisDark() {
  return _previewFrame(
    theme: AppTheme.dark,
    child: const SectionHeader(
      title: 'Appearance',
      variant: SectionHeaderVariant.emphasis,
    ),
  );
}

@Preview(name: 'SectionHeader — muted (dark)', group: 'Shared')
Widget previewSectionHeaderMutedDark() {
  return _previewFrame(
    theme: AppTheme.dark,
    child: const SectionHeader(
      title: 'Infrastructure',
      variant: SectionHeaderVariant.muted,
    ),
  );
}

@Preview(name: 'SectionHeader — emphasis (light)', group: 'Shared')
Widget previewSectionHeaderEmphasisLight() {
  return _previewFrame(
    theme: AppTheme.light,
    child: const SectionHeader(
      title: 'Appearance',
      variant: SectionHeaderVariant.emphasis,
    ),
  );
}

@Preview(name: 'ChartCard — full (dark)', group: 'Shared')
Widget previewChartCardDark() {
  final theme = AppTheme.dark;
  return _previewFrame(
    theme: theme,
    child: ChartCard(
      title: 'CPU usage',
      subtitle: 'Last 24 hours',
      child: Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('Chart area', style: theme.textTheme.bodySmall),
      ),
    ),
  );
}
