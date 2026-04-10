import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/shared/widgets/premium_list_row.dart';

Widget _wrap(Widget widget, ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: SizedBox(width: 360, child: widget)),
  );
}

void main() {
  testWidgets('PremiumListRow title-only — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(const PremiumListRow(title: Text('pve-node-01')), AppTheme.dark),
    );
    await tester.pump();

    await expectLater(
      find.byType(PremiumListRow),
      matchesGoldenFile('goldens/premium_list_row_title_dark.png'),
    );
  });

  testWidgets('PremiumListRow title-only — light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 80));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(const PremiumListRow(title: Text('pve-node-01')), AppTheme.light),
    );
    await tester.pump();

    await expectLater(
      find.byType(PremiumListRow),
      matchesGoldenFile('goldens/premium_list_row_title_light.png'),
    );
  });

  testWidgets('PremiumListRow with subtitle and chevron — dark golden', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const PremiumListRow(
          title: Text('vm-100'),
          subtitle: Text('Running'),
          showChevron: true,
          leading: Icon(Icons.computer),
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(PremiumListRow),
      matchesGoldenFile('goldens/premium_list_row_full_dark.png'),
    );
  });

  testWidgets('PremiumListRow with subtitle and chevron — light golden', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const PremiumListRow(
          title: Text('vm-100'),
          subtitle: Text('Running'),
          showChevron: true,
          leading: Icon(Icons.computer),
        ),
        AppTheme.light,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(PremiumListRow),
      matchesGoldenFile('goldens/premium_list_row_full_light.png'),
    );
  });

  // Behavioral: chevron icon is present when showChevron = true
  testWidgets('PremiumListRow shows chevron icon when showChevron is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const PremiumListRow(title: Text('Item'), showChevron: true),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  // Behavioral: no chevron when showChevron = false (default)
  testWidgets('PremiumListRow does not show chevron icon by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const PremiumListRow(title: Text('Item')), AppTheme.dark),
    );
    await tester.pump();

    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  // Behavioral: divider is absent when showDividerBelow = false
  testWidgets('PremiumListRow omits divider when showDividerBelow is false', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const PremiumListRow(title: Text('Item'), showDividerBelow: false),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.byType(Divider), findsNothing);
  });
}
