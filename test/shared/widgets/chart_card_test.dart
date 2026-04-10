import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';

Widget _wrap(Widget widget, ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: widget),
    ),
  );
}

/// Static placeholder chart — a simple colored box so the golden is
/// animation-free and deterministic.
const _placeholderChart = SizedBox(
  height: 120,
  child: DecoratedBox(
    decoration: BoxDecoration(color: Color(0xFF2C2C2C)),
    child: Center(child: Text('chart')),
  ),
);

void main() {
  testWidgets('ChartCard placeholder layout — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 280));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const ChartCard(
          title: 'CPU Usage',
          subtitle: '1-hour',
          child: _placeholderChart,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(ChartCard),
      matchesGoldenFile('goldens/chart_card_placeholder_dark.png'),
    );
  });

  testWidgets('ChartCard placeholder layout — light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 280));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const ChartCard(
          title: 'CPU Usage',
          subtitle: '1-hour',
          child: _placeholderChart,
        ),
        AppTheme.light,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(ChartCard),
      matchesGoldenFile('goldens/chart_card_placeholder_light.png'),
    );
  });

  testWidgets('ChartCard compact layout — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 220));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _wrap(
        const ChartCard(
          title: 'Memory',
          compact: true,
          child: _placeholderChart,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(ChartCard),
      matchesGoldenFile('goldens/chart_card_compact_dark.png'),
    );
  });

  // Behavioral: non-compact wraps in Card; compact does not
  testWidgets('ChartCard non-compact wraps content in Card', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ChartCard(title: 'Net I/O', child: _placeholderChart),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('ChartCard compact does not wrap in Card', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ChartCard(
          title: 'Net I/O',
          compact: true,
          child: _placeholderChart,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('ChartCard displays title text', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ChartCard(title: 'Disk I/O', child: _placeholderChart),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.text('Disk I/O'), findsOneWidget);
  });

  testWidgets('ChartCard shows subtitle when provided', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const ChartCard(
          title: 'CPU',
          subtitle: 'Last hour',
          child: _placeholderChart,
        ),
        AppTheme.dark,
      ),
    );
    await tester.pump();

    expect(find.text('Last hour'), findsOneWidget);
  });
}
