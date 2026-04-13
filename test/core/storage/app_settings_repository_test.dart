import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
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

  test('verbose connection errors default false', () {
    final repo = AppSettingsRepository(box: box);
    expect(repo.getVerboseConnectionErrors(), false);
  });

  test('setVerboseConnectionErrors roundtrips', () async {
    final repo = AppSettingsRepository(box: box);
    await repo.setVerboseConnectionErrors(true);
    expect(repo.getVerboseConnectionErrors(), true);
    await repo.setVerboseConnectionErrors(false);
    expect(repo.getVerboseConnectionErrors(), false);
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

  test('getDefaultChartTimeframe defaults to hour when box empty', () {
    final repo = AppSettingsRepository(box: box);
    expect(repo.getDefaultChartTimeframe(), ChartTimeframe.hour);
  });

  test('setDefaultChartTimeframe roundtrips via Hive', () async {
    final repo = AppSettingsRepository(box: box);
    await repo.setDefaultChartTimeframe(ChartTimeframe.week);
    expect(repo.getDefaultChartTimeframe(), ChartTimeframe.week);

    final repo2 = AppSettingsRepository(box: box);
    expect(repo2.getDefaultChartTimeframe(), ChartTimeframe.week);
  });

  test('chartTimeframeFromStorage maps stored api values', () {
    expect(
      AppSettingsRepository.chartTimeframeFromStorage('day'),
      ChartTimeframe.day,
    );
    expect(
      AppSettingsRepository.chartTimeframeFromStorage('bogus'),
      ChartTimeframe.hour,
    );
    expect(
      AppSettingsRepository.chartTimeframeFromStorage(null),
      ChartTimeframe.hour,
    );
  });

  test('getLocalePreference defaults to system when box empty', () {
    final repo = AppSettingsRepository(box: box);
    expect(repo.getLocalePreference(), LocalePreference.system);
  });

  test('setLocalePreference roundtrips via Hive', () async {
    final repo = AppSettingsRepository(box: box);
    await repo.setLocalePreference(LocalePreference.german);
    expect(repo.getLocalePreference(), LocalePreference.german);

    final repo2 = AppSettingsRepository(box: box);
    expect(repo2.getLocalePreference(), LocalePreference.german);
  });

  test('localePreferenceFromStorage maps stored strings', () {
    expect(
      AppSettingsRepository.localePreferenceFromStorage('en'),
      LocalePreference.english,
    );
    expect(
      AppSettingsRepository.localePreferenceFromStorage('de'),
      LocalePreference.german,
    );
    expect(
      AppSettingsRepository.localePreferenceFromStorage('system'),
      LocalePreference.system,
    );
    expect(
      AppSettingsRepository.localePreferenceFromStorage(null),
      LocalePreference.system,
    );
  });

  test('materialLocaleForPreference maps to Material locales', () {
    expect(materialLocaleForPreference(LocalePreference.system), isNull);
    expect(
      materialLocaleForPreference(LocalePreference.english),
      const Locale('en'),
    );
    expect(
      materialLocaleForPreference(LocalePreference.german),
      const Locale('de'),
    );
  });
}
