import 'package:flutter/material.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Non-dismissible offline / connectivity strip for the app shell (§4.2, §6.1).
///
/// **Palette (retint vs harsh [ColorScheme.errorContainer]):**
/// - Fill: [ColorScheme.surfaceContainerHigh] — elevated but not “error”.
/// - Accent: [ColorScheme.tertiary] icon + primary-tinted hairline bottom edge
///   (Stitch cyan story) without semantic error styling.
///
/// **Layout:** [AppShell] wraps this with [SafeArea] (`bottom: false`) and
/// [AnimatedSize] so the strip does not cover the app bar and height changes are
/// smoothed (§6.1).
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  static const double bottomRadius = 14;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final iconColor = scheme.tertiary;
    final textColor = scheme.onSurface;

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(bottomRadius),
          ),
          border: Border(
            bottom: BorderSide(
              color: scheme.primary.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.wifi_off_rounded, color: iconColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.offlineBannerMessage,
                  style: textTheme.bodyMedium?.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
