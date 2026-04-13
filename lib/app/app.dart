import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Root application widget: [MaterialApp.router] with theme, localization, and go_router.
class ProxDroidApp extends ConsumerWidget {
  const ProxDroidApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      // Phase B: light status / nav bar icons on Obsidian scaffold (plan §5).
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        final overlayStyle =
            brightness == Brightness.dark
                ? const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: AppColors.scaffoldObsidian,
                  systemNavigationBarIconBrightness: Brightness.light,
                  systemNavigationBarDividerColor: Colors.transparent,
                )
                : SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: Colors.transparent,
                );
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
