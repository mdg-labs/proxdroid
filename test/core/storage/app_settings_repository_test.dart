import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';

void main() {
  late Directory tempDir;
  late Box<String> box;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('proxdroid_settings_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<String>('settings_test_${tempDir.path.hashCode}');
  });

  tearDown(() async {
    final name = box.name;
    await box.close();
    await Hive.deleteBoxFromDisk(name);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('getThemeMode defaults to dark when box empty', () {
    final repo = AppSettingsRepository(box: box);
    expect(repo.getThemeMode(), ThemeMode.dark);
  });

  test('setThemeMode roundtrips via Hive', () async {
    final repo = AppSettingsRepository(box: box);
    await repo.setThemeMode(ThemeMode.system);
    expect(repo.getThemeMode(), ThemeMode.system);

    final repo2 = AppSettingsRepository(box: box);
    expect(repo2.getThemeMode(), ThemeMode.system);
  });

  test('themeModeFromStorage maps stored strings', () {
    expect(
      AppSettingsRepository.themeModeFromStorage('light'),
      ThemeMode.light,
    );
    expect(
      AppSettingsRepository.themeModeFromStorage('system'),
      ThemeMode.system,
    );
    expect(AppSettingsRepository.themeModeFromStorage('dark'), ThemeMode.dark);
    expect(AppSettingsRepository.themeModeFromStorage(null), ThemeMode.dark);
  });
}
