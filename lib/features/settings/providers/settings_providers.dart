import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Active [ThemeMode] for [MaterialApp.router].
///
/// Phase 6 adds a settings toggle and persistence in hive_ce
/// ([ProxDroid_Roadmap.md] §6.3).
@riverpod
ThemeMode appThemeMode(Ref ref) => ThemeMode.dark;
