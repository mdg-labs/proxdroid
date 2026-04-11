import 'package:flutter/material.dart';

/// Design tokens for ProxDroid (Material 3, hybrid ProxMate + Absorb).
///
/// **Contrast (T1.7):** Values below are chosen for WCAG-minded contrast on the
/// true-black scaffold ([scaffoldPureBlack]); ratios use the WCAG 2.x relative
/// luminance model (same basis as the WebAIM contrast checker).
/// - [darkOnSurface] `#E2E5EB` on `#000000`: ~15:1 (AAA body).
/// - [darkOnSurfaceVariant] `#B0B3B8` on `#000000`: ~8.5:1 (AA UI / large text).
/// - [premiumAccent] `#C9A962` on `#000000`: ~9:1 (decorative / labels; not
///   a substitute for semantic success green).
abstract final class AppColors {
  // --- Semantic aliases (§2.1, §3) ---

  /// OLED scaffold: true black per plan §2.1. Prefer `#000000`; use `#0A0A0A`
  /// only if banding shows on target panels (then document in `app_theme.dart`).
  static const Color scaffoldPureBlack = Color(0xFF000000);

  /// Muted gold/tan for premium emphasis (Absorb-style), not for semantic success.
  static const Color premiumAccent = Color(0xFFC9A962);

  /// Navigation / wayfinding accent — same hue as [darkPrimary] (blue).
  static const Color navigationAccent = Color(0xFF0A84FF);

  // --- Dark (default) ---

  static const Color darkPrimary = navigationAccent;
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkPrimaryContainer = Color(0xFF003A70);
  static const Color darkOnPrimaryContainer = Color(0xFFD0E4FF);

  static const Color darkSecondary = premiumAccent;
  static const Color darkOnSecondary = Color(0xFF1C1B14);
  static const Color darkSecondaryContainer = Color(0xFF4A4020);
  static const Color darkOnSecondaryContainer = Color(0xFFF2DEB5);

  static const Color darkTertiary = Color(0xFFA8925C);
  static const Color darkOnTertiary = Color(0xFF1C1B14);

  /// Card / sheet surfaces (~`#1C1C1E`–`#2C2C2C` per §2.1).
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkSurfaceContainerLow = Color(0xFF141414);
  static const Color darkSurfaceContainer = Color(0xFF202022);
  static const Color darkSurfaceContainerHigh = Color(0xFF28282C);
  static const Color darkSurfaceContainerHighest = Color(0xFF2C2C2C);

  static const Color darkOnSurface = Color(0xFFE2E5EB);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B3B8);

  static const Color darkOutline = Color(0xFF6B6B70);
  static const Color darkOutlineVariant = Color(0xFF444448);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  /// Success / warning / running / stopped badge helpers (§7.4).
  static const Color darkStatusSuccessBackground = Color(0xFF1B4332);
  static const Color darkStatusSuccessForeground = Color(0xFF95D5B2);
  static const Color darkStatusWarningBackground = Color(0xFF5C4A00);
  static const Color darkStatusWarningForeground = Color(0xFFFFE082);

  /// Running / in-progress (informational blue — active task badges).
  static const Color darkStatusRunningBackground = Color(0xFF0A2A50);
  static const Color darkStatusRunningForeground = Color(0xFF5BC0FF);
  static const Color lightStatusRunningBackground = Color(0xFFDBEEFE);
  static const Color lightStatusRunningForeground = Color(0xFF004A9B);

  /// Stopped (muted neutral — powered-off VMs are not in error state).
  static const Color darkStatusStoppedBackground = Color(0xFF252528);
  static const Color darkStatusStoppedForeground = Color(0xFF909099);
  static const Color lightStatusStoppedBackground = Color(0xFFF0F0F5);
  static const Color lightStatusStoppedForeground = Color(0xFF5A5A66);

  /// Destructive accent for force-stop / delete actions (iOS-style red).
  static const Color destructiveRed = Color(0xFFFF453A);

  // --- Light (§10) ---

  /// iOS-style grouped list background.
  static const Color lightGroupedScaffold = Color(0xFFF2F2F7);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFE8E8ED);
  static const Color lightSurfaceContainer = Color(0xFFE1E1E6);
  static const Color lightSurfaceContainerHigh = Color(0xFFD5D5DA);
  static const Color lightSurfaceContainerHighest = Color(0xFFFFFFFF);

  /// Darker blue for contrast on white (§10).
  static const Color lightPrimary = Color(0xFF0061C8);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD4E4FF);
  static const Color lightOnPrimaryContainer = Color(0xFF001D36);

  /// Darkened gold for WCAG on white (§10).
  static const Color lightSecondary = Color(0xFF6B5720);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFF2E3BB);
  static const Color lightOnSecondaryContainer = Color(0xFF231C05);

  static const Color lightTertiary = Color(0xFF5C5240);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);

  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOnSurfaceVariant = Color(0xFF45464F);

  /// Stronger dividers in light (§10).
  static const Color lightOutline = Color(0xFF767680);
  static const Color lightOutlineVariant = Color(0xFFC5C5CC);

  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF410002);

  static const Color lightStatusSuccessBackground = Color(0xFFE8F5E9);
  static const Color lightStatusSuccessForeground = Color(0xFF1B4332);
  static const Color lightStatusWarningBackground = Color(0xFFFFF8E1);
  static const Color lightStatusWarningForeground = Color(0xFF7A5A00);

  // --- Chart series colors (§9) ---
  //
  // CPU:  colorScheme.primary (blue)   — from theme, not a constant here.
  // Memory: colorScheme.secondary (tan/gold) — from theme, not a constant here.

  /// Network out: muted purple-grey per §9 "blue + muted purple/grey".
  /// Approximated as desaturated mauve — readable on true-black at chart scale.
  static const Color chartNetworkOut = Color(0xFF9B8FA4);

  /// Disk read: amber-300 per §9 "amber + blue-grey".
  static const Color chartDiskRead = Color(0xFFFFB74D);

  /// Disk write: blue-grey-400 per §9 "amber + blue-grey".
  static const Color chartDiskWrite = Color(0xFF78909C);
}
