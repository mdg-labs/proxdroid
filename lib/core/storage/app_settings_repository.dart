import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_settings_repository.g.dart';

/// Hive box name for app preferences (theme, diagnostics toggles; no credentials).
const String kSettingsHiveBoxName = 'settings';

/// Hive key for persisted [ThemeMode] string value.
const String kThemeModeStorageKey = 'themeMode';

/// Hive key: `'true'` / `'false'` for connection-test diagnostics dialog.
const String kVerboseConnectionErrorsKey = 'verboseConnectionErrors';

/// Hive key for default RRD chart [ChartTimeframe] (`hour` / `day` / …).
const String kDefaultChartTimeframeKey = 'defaultChartTimeframe';

const String _valueDark = 'dark';
const String _valueLight = 'light';
const String _valueSystem = 'system';

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
}

/// Must be overridden in [main] after the settings Hive box is opened.
@Riverpod(keepAlive: true)
AppSettingsRepository appSettingsRepository(Ref ref) {
  throw UnsupportedError(
    'appSettingsRepositoryProvider must be overridden after Hive is initialized '
    'in main.dart (ProviderScope.overrides).',
  );
}
