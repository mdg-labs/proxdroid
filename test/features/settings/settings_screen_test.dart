import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/settings/ui/settings_screen.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/l10n/app_localizations_en.dart';

void main() {
  testWidgets('Settings shows Appearance section', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tempDir = Directory.systemTemp.createTempSync(
      'proxdroid_settings_screen_test',
    );
    Hive.init(tempDir.path);
    final box = await Hive.openBox<String>(
      'settings_screen_${tempDir.path.hashCode}',
    );
    final appSettings = AppSettingsRepository(box: box);
    addTearDown(() async {
      final name = box.name;
      await box.close();
      await Hive.deleteBoxFromDisk(name);
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    final l10n = AppLocalizationsEn();
    final fakeInfo = PackageInfo(
      appName: 'ProxDroid',
      packageName: 'com.mdglabs.proxdroid',
      version: '0.0.0',
      buildNumber: '99',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSettingsRepositoryProvider.overrideWithValue(appSettings),
          packageInfoProvider.overrideWith((ref) async => fakeInfo),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(l10n.settingsAppearanceSection), findsOneWidget);
    expect(find.text(l10n.sectionSettings), findsOneWidget);
  });
}
