import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/storage/app_settings_repository.dart';

part 'settings_providers.g.dart';

/// Cached [PackageInfo] for Settings / About.
@Riverpod(keepAlive: true)
Future<PackageInfo> packageInfo(Ref ref) => PackageInfo.fromPlatform();

/// Active [ThemeMode] for [MaterialApp.router]; persisted in hive_ce
/// ([ProxDroid_Roadmap.md] §6.3).
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() => ref.watch(appSettingsRepositoryProvider).getThemeMode();

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(appSettingsRepositoryProvider).setThemeMode(mode);
    state = mode;
  }
}

/// When true, a failed server "Test connection" shows a technical [AlertDialog].
@Riverpod(keepAlive: true)
class VerboseConnectionErrors extends _$VerboseConnectionErrors {
  @override
  bool build() =>
      ref.watch(appSettingsRepositoryProvider).getVerboseConnectionErrors();

  Future<void> setEnabled(bool value) async {
    await ref
        .read(appSettingsRepositoryProvider)
        .setVerboseConnectionErrors(value);
    state = value;
  }
}

/// Default [ChartTimeframe] for RRD charts; persisted in hive_ce.
@Riverpod(keepAlive: true)
class DefaultChartTimeframe extends _$DefaultChartTimeframe {
  @override
  ChartTimeframe build() =>
      ref.watch(appSettingsRepositoryProvider).getDefaultChartTimeframe();

  Future<void> setTimeframe(ChartTimeframe tf) async {
    await ref.read(appSettingsRepositoryProvider).setDefaultChartTimeframe(tf);
    state = tf;
  }
}

/// Active [LocalePreference] for [MaterialApp.router]; persisted in hive_ce.
@Riverpod(keepAlive: true)
class AppLocalePreference extends _$AppLocalePreference {
  @override
  LocalePreference build() =>
      ref.watch(appSettingsRepositoryProvider).getLocalePreference();

  Future<void> setLocalePreference(LocalePreference value) async {
    await ref.read(appSettingsRepositoryProvider).setLocalePreference(value);
    state = value;
  }
}
