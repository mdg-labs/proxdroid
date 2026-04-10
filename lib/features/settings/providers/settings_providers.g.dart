// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageInfoHash() => r'854bbb0e381edfdddbd736229351d6cc918a2ad1';

/// Cached [PackageInfo] for Settings / About.
///
/// Copied from [packageInfo].
@ProviderFor(packageInfo)
final packageInfoProvider = FutureProvider<PackageInfo>.internal(
  packageInfo,
  name: r'packageInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$packageInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PackageInfoRef = FutureProviderRef<PackageInfo>;
String _$appThemeModeHash() => r'a88002df7dfa3337675096faed14cd28502c766f';

/// Active [ThemeMode] for [MaterialApp.router]; persisted in hive_ce
/// ([ProxDroid_Roadmap.md] §6.3).
///
/// Copied from [AppThemeMode].
@ProviderFor(AppThemeMode)
final appThemeModeProvider = NotifierProvider<AppThemeMode, ThemeMode>.internal(
  AppThemeMode.new,
  name: r'appThemeModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppThemeMode = Notifier<ThemeMode>;
String _$verboseConnectionErrorsHash() =>
    r'd521bf5f075cb99202eab64be295285cf970c4db';

/// When true, a failed server "Test connection" shows a technical [AlertDialog].
///
/// Copied from [VerboseConnectionErrors].
@ProviderFor(VerboseConnectionErrors)
final verboseConnectionErrorsProvider =
    NotifierProvider<VerboseConnectionErrors, bool>.internal(
      VerboseConnectionErrors.new,
      name: r'verboseConnectionErrorsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$verboseConnectionErrorsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VerboseConnectionErrors = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
