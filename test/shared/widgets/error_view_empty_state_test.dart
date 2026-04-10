import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';

Widget _wrapL10n(Widget widget, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? AppTheme.dark,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: widget),
  );
}

void main() {
  group('ErrorView theme-visible behavior', () {
    testWidgets('ErrorView retry button is a FilledButton (Phase 1 change)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapL10n(
          ErrorView(message: 'Connection failed', onRetry: () {}),
        ),
      );
      await tester.pump();

      // Phase 1 migrated the retry button from TextButton to FilledButton.
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets(
      'ErrorView shows no retry button when onRetry is null',
      (tester) async {
        await tester.pumpWidget(
          _wrapL10n(const ErrorView(message: 'Something went wrong')),
        );
        await tester.pump();

        expect(find.byType(FilledButton), findsNothing);
        expect(find.byType(TextButton), findsNothing);
      },
    );

    testWidgets('ErrorView retry button renders in light theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapL10n(
          ErrorView(message: 'Timeout', onRetry: () {}),
          theme: AppTheme.light,
        ),
      );
      await tester.pump();

      expect(find.byType(FilledButton), findsOneWidget);
    });
  });

  group('EmptyState theme-visible behavior', () {
    testWidgets('EmptyState CTA action widget is rendered when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapL10n(
          EmptyState(
            icon: Icons.dns_outlined,
            title: 'No Servers',
            message: 'Add a server to get started.',
            action: FilledButton(
              onPressed: () {},
              child: const Text('Add Server'),
            ),
          ),
        ),
      );
      await tester.pump();

      // The CTA in EmptyState should be a FilledButton (Phase 1 change).
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Add Server'), findsOneWidget);
    });

    testWidgets('EmptyState renders title and optional message', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapL10n(
          const EmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Tasks',
            message: 'Tasks will appear here.',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No Tasks'), findsOneWidget);
      expect(find.text('Tasks will appear here.'), findsOneWidget);
    });

    testWidgets('EmptyState renders in light theme without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapL10n(
          EmptyState(
            icon: Icons.storage_outlined,
            title: 'No Storage',
            action: FilledButton(
              onPressed: () {},
              child: const Text('Refresh'),
            ),
          ),
          theme: AppTheme.light,
        ),
      );
      await tester.pump();

      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}
