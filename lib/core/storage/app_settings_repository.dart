import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_repository.g.dart';

/// Hive box name for app preferences (theme, locale, diagnostics toggles; no credentials).
const String kSettingsHiveBoxName = 'settings';

/// Hive key for persisted [ThemeMode] string value.
const String kThemeModeStorageKey = 'themeMode';

/// Hive key: `'true'` / `'false'` for connection-test diagnostics dialog.
const String kVerboseConnectionErrorsKey = 'verboseConnectionErrors';

/// Hive key for default RRD chart [ChartTimeframe] (`hour` / `day` / …).
const String kDefaultChartTimeframeKey = 'defaultChartTimeframe';

/// Hive key for UI language override (`system` / `en` / `de`).
const String kLocalePreferenceKey = 'localePreference';

const String _valueDark = 'dark';
const String _valueLight = 'light';
const String _valueSystem = 'system';

const String _localeSystem = 'system';
const String _localeEn = 'en';
const String _localeDe = 'de';

/// Persisted UI language for [MaterialApp.router].
///
/// [system] follows the device locale when supported, otherwise a supported fallback.
enum LocalePreference { system, english, german }

/// Non-sensitive preferences backed by hive_ce.
class AppSettingsRepository {
  AppSettingsRepository({required Box<String> box}) : _box = box;

  final Box<String> _box;

  ThemeMode getThemeMode() {
    final raw = _box.get(kThemeModeStorageKey);
    return themeModeFromStorage(raw);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(kThemeModeStorageKey, themeModeToStorage(mode));
  }

  /// When true, a failed "Test connection" shows an extra technical dialog.
  bool getVerboseConnectionErrors() =>
      _box.get(kVerboseConnectionErrorsKey) == 'true';

  Future<void> setVerboseConnectionErrors(bool value) async {
    await _box.put(kVerboseConnectionErrorsKey, value ? 'true' : 'false');
  }

  /// Default timeframe for resource charts; unknown or null → [ChartTimeframe.hour].
  ChartTimeframe getDefaultChartTimeframe() {
    final raw = _box.get(kDefaultChartTimeframeKey);
    return chartTimeframeFromStorage(raw);
  }

  Future<void> setDefaultChartTimeframe(ChartTimeframe tf) async {
    await _box.put(kDefaultChartTimeframeKey, chartTimeframeToStorage(tf));
  }

  /// Active UI language; unknown or null → [LocalePreference.system].
  LocalePreference getLocalePreference() {
    final raw = _box.get(kLocalePreferenceKey);
    return localePreferenceFromStorage(raw);
  }

  Future<void> setLocalePreference(LocalePreference value) async {
    await _box.put(kLocalePreferenceKey, localePreferenceToStorage(value));
  }

  /// Parses stored theme string; unknown or null → [ThemeMode.dark].
  static ThemeMode themeModeFromStorage(String? value) {
    switch (value) {
      case _valueLight:
        return ThemeMode.light;
      case _valueSystem:
        return ThemeMode.system;
      case _valueDark:
      default:
        return ThemeMode.dark;
    }
  }

  static String themeModeToStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return _valueLight;
      case ThemeMode.system:
        return _valueSystem;
      case ThemeMode.dark:
        return _valueDark;
    }
  }

  /// Parses stored timeframe string; unknown or null → [ChartTimeframe.hour].
  static ChartTimeframe chartTimeframeFromStorage(String? value) {
    for (final tf in ChartTimeframe.values) {
      if (tf.apiValue == value) return tf;
    }
    return ChartTimeframe.hour;
  }

  static String chartTimeframeToStorage(ChartTimeframe tf) => tf.apiValue;

  static LocalePreference localePreferenceFromStorage(String? value) {
    switch (value) {
      case _localeEn:
        return LocalePreference.english;
      case _localeDe:
        return LocalePreference.german;
      case _localeSystem:
      default:
        return LocalePreference.system;
    }
  }

  static String localePreferenceToStorage(LocalePreference value) {
    switch (value) {
      case LocalePreference.english:
        return _localeEn;
      case LocalePreference.german:
        return _localeDe;
      case LocalePreference.system:
        return _localeSystem;
    }
  }
}

/// [Locale] passed to [MaterialApp.router]; `null` follows the platform.
Locale? materialLocaleForPreference(LocalePreference preference) {
  switch (preference) {
    case LocalePreference.system:
      return null;
    case LocalePreference.english:
      return const Locale('en');
    case LocalePreference.german:
      return const Locale('de');
  }
}

/// Must be overridden in [main] after the settings Hive box is opened.
@Riverpod(keepAlive: true)
AppSettingsRepository appSettingsRepository(Ref ref) {
  throw UnsupportedError(
    'appSettingsRepositoryProvider must be overridden after Hive is initialized '
    'in main.dart (ProviderScope.overrides).',
  );
}
