import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Smoke test for Settings copy and controls without bootstrapping the full
/// [SettingsScreen] stack (that screen expects the same go_router + Riverpod
/// + Hive wiring as [main.dart]; see [widget_test.dart] for app-level smoke).
///
/// This still verifies the Appearance and Language section titles and labels
/// resolve through [AppLocalizations] like [PreferencesScreen].
void main() {
  testWidgets('preferences appearance, language, and theme labels (l10n)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      l10n.settingsAppearanceSection,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text(l10n.settingsThemeDark),
                          icon: const Icon(Icons.dark_mode_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text(l10n.settingsThemeLight),
                          icon: const Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text(l10n.settingsThemeSystem),
                          icon: const Icon(Icons.brightness_auto_outlined),
                        ),
                      ],
                      selected: {ThemeMode.dark},
                      onSelectionChanged: (_) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      l10n.settingsLanguageSection,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: SegmentedButton<LocalePreference>(
                      segments: [
                        ButtonSegment<LocalePreference>(
                          value: LocalePreference.system,
                          label: Text(l10n.settingsLanguageSystem),
                          icon: const Icon(Icons.language_outlined),
                        ),
                        ButtonSegment<LocalePreference>(
                          value: LocalePreference.english,
                          label: Text(l10n.settingsLanguageEnglish),
                          icon: const Icon(Icons.abc_outlined),
                        ),
                        ButtonSegment<LocalePreference>(
                          value: LocalePreference.german,
                          label: Text(l10n.settingsLanguageGerman),
                          icon: const Icon(Icons.abc_outlined),
                        ),
                      ],
                      selected: {LocalePreference.system},
                      onSelectionChanged: (_) {},
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pump();

    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    expect(find.text(l10n.settingsAppearanceSection), findsOneWidget);
    expect(find.text(l10n.settingsLanguageSection), findsOneWidget);
    expect(find.text(l10n.settingsThemeDark), findsOneWidget);
    expect(find.text(l10n.settingsLanguageSystem), findsOneWidget);
  });
}
