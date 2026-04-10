import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync(
      'proxdroid_theme_provider_test',
    );
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>('settings_theme_${tempDir.path.hashCode}');
  });

  tearDown(() async {
    final name = box.name;
    await box.close();
    await Hive.deleteBoxFromDisk(name);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test(
    'AppThemeMode reflects repository and setThemeMode updates both',
    () async {
      final repo = AppSettingsRepository(box: box);
      await repo.setThemeMode(ThemeMode.light);

      final container = ProviderContainer(
        overrides: [appSettingsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      expect(container.read(appThemeModeProvider), ThemeMode.light);

      await container
          .read(appThemeModeProvider.notifier)
          .setThemeMode(ThemeMode.dark);
      expect(container.read(appThemeModeProvider), ThemeMode.dark);
      expect(repo.getThemeMode(), ThemeMode.dark);
    },
  );

  test('VerboseConnectionErrors toggles repository flag', () async {
    final repo = AppSettingsRepository(box: box);
    final container = ProviderContainer(
      overrides: [appSettingsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    expect(container.read(verboseConnectionErrorsProvider), false);
    await container
        .read(verboseConnectionErrorsProvider.notifier)
        .setEnabled(true);
    expect(container.read(verboseConnectionErrorsProvider), true);
    expect(repo.getVerboseConnectionErrors(), true);
  });
}
