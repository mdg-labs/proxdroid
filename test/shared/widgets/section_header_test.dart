import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';

/// Wraps [widget] in a [MaterialApp] with [theme] and a fixed-size [Scaffold]
/// so goldens are deterministic regardless of host display size.
Widget _wrap(Widget widget, ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: SizedBox(width: 360, child: widget),
    ),
  );
}

void main() {
  testWidgets('SectionHeader emphasis — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const SectionHeader(title: 'Virtual Machines'),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(SectionHeader),
      matchesGoldenFile('goldens/section_header_emphasis_dark.png'),
    );
  });

  testWidgets('SectionHeader emphasis — light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const SectionHeader(title: 'Virtual Machines'),
        AppTheme.light,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(SectionHeader),
      matchesGoldenFile('goldens/section_header_emphasis_light.png'),
    );
  });

  testWidgets('SectionHeader muted variant — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 60));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const SectionHeader(
          title: 'Connections',
          variant: SectionHeaderVariant.muted,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(SectionHeader),
      matchesGoldenFile('goldens/section_header_muted_dark.png'),
    );
  });

  testWidgets('SectionHeader muted variant — light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 60));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const SectionHeader(
          title: 'Connections',
          variant: SectionHeaderVariant.muted,
        ),
        AppTheme.light,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(SectionHeader),
      matchesGoldenFile('goldens/section_header_muted_light.png'),
    );
  });

  // Behavioral: emphasis variant uses primary color
  testWidgets('SectionHeader emphasis uses primary color text', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SectionHeader(title: 'Servers'),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    final text = tester.widget<Text>(find.text('Servers'));
    expect(text.style?.color, AppTheme.dark.colorScheme.primary);
  });

  // Behavioral: muted variant uses onSurfaceVariant color
  testWidgets('SectionHeader muted uses onSurfaceVariant color text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SectionHeader(
          title: 'Servers',
          variant: SectionHeaderVariant.muted,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    final text = tester.widget<Text>(find.text('Servers'));
    expect(text.style?.color, AppTheme.dark.colorScheme.onSurfaceVariant);
  });
}
