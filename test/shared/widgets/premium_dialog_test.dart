import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';

Widget _dialogScene(ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          height: 600,
          child: Stack(
            children: [
              PremiumDialog(
                title: const Text('Stop Virtual Machine'),
                content: const Text(
                  'Are you sure you want to stop vm-100? '
                  'All unsaved data will be lost.',
                ),
                actions: [
                  TextButton(onPressed: null, child: const Text('Cancel')),
                  FilledButton(onPressed: null, child: const Text('Stop')),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('PremiumDialog snapshot — dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_dialogScene(AppTheme.dark));
    await tester.pump();

    await expectLater(
      find.byType(PremiumDialog),
      matchesGoldenFile('goldens/premium_dialog_dark.png'),
    );
  });

  testWidgets('PremiumDialog snapshot — light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_dialogScene(AppTheme.light));
    await tester.pump();

    await expectLater(
      find.byType(PremiumDialog),
      matchesGoldenFile('goldens/premium_dialog_light.png'),
    );
  });

  // Behavioral: title and content text are rendered
  testWidgets('PremiumDialog renders title and content text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: PremiumDialog(
            title: const Text('Confirm Action'),
            content: const Text('This is the body.'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Confirm Action'), findsOneWidget);
    expect(find.text('This is the body.'), findsOneWidget);
  });

  // Behavioral: PremiumDialog wraps an AlertDialog
  testWidgets('PremiumDialog builds an AlertDialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: PremiumDialog(
            title: const Text('Title'),
            content: const Text('Content'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  // Behavioral: actions are rendered when provided
  testWidgets('PremiumDialog renders action buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: PremiumDialog(
            title: const Text('Title'),
            content: const Text('Content'),
            actions: [
              TextButton(onPressed: null, child: const Text('Cancel')),
              FilledButton(onPressed: null, child: const Text('Confirm')),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });
}
