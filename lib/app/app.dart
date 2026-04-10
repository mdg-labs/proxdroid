import 'package:flutter/material.dart';
import 'package:proxdroid/app/router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Root application widget: [MaterialApp.router] with theme, localization, and go_router.
class ProxDroidApp extends StatelessWidget {
  const ProxDroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
