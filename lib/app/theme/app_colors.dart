import 'package:flutter/material.dart';

/// Design tokens for ProxDroid (Material 3, Stitch “Obsidian Command Center”).
///
/// **Dark canvas:** Default scaffold uses [scaffoldObsidian] (`#0c0e17`) per
/// `docs/UI_Refactor_Stitch_Plan.md` §1 — layered surfaces sit above this base.
/// [scaffoldPureBlack] (`#000000`) remains available for an OLED “true black”
/// variant if contrast or branding prefers it (see `AppTheme` library doc).
///
/// **Contrast:** Ratios use WCAG 2.x relative luminance. Body copy should prefer
/// [darkOnSurfaceVariant] over pure white on dark (`DESIGN.md`).
abstract final class AppColors {
  // --- Semantic aliases ---

  /// OLED option: true black. Not the default canvas after Phase A; see
  /// [scaffoldObsidian].
  static const Color scaffoldPureBlack = Color(0xFF000000);

  /// Default dark scaffold / canvas (Stitch §1).
  static const Color scaffoldObsidian = Color(0xFF0c0e17);

  /// Muted gold for premium chrome (drawer ring, etc.). Intentionally **not**
  /// mapped to [ColorScheme.secondary] — charts use Stitch periwinkle instead.
  static const Color premiumAccent = Color(0xFFC9A962);

  /// Wayfinding / CTA accent — aligned with Stitch [darkPrimary] (cyan).
  static const Color navigationAccent = Color(0xFF81ecff);

  // --- Dark (Stitch §1) ---

  static const Color darkPrimary = navigationAccent;
  static const Color darkOnPrimary = Color(0xFF005762);
  static const Color darkPrimaryContainer = Color(0xFF00e3fd);
  static const Color darkOnPrimaryContainer = Color(0xFF004d57);

  static const Color darkSecondary = Color(0xFF7e98ff);
  static const Color darkOnSecondary = Color(0xFF050814);
  static const Color darkSecondaryContainer = Color(0xFF2a3048);
  static const Color darkOnSecondaryContainer = Color(0xFFd6deff);

  static const Color darkTertiary = Color(0xFFfab0ff);
  static const Color darkOnTertiary = Color(0xFF2d0a32);
  static const Color darkTertiaryContainer = Color(0xFF5a3860);
  static const Color darkOnTertiaryContainer = Color(0xFFffd6ff);

  /// Base [ColorScheme.surface] — same as canvas per §1.
  static const Color darkSurface = scaffoldObsidian;

  static const Color darkSurfaceContainerLow = Color(0xFF11131d);
  static const Color darkSurfaceContainer = Color(0xFF171924);
  static const Color darkSurfaceContainerHigh = Color(0xFF1c1f2b);
  static const Color darkSurfaceContainerHighest = Color(0xFF222532);

  /// Elevated / hover tier (`DESIGN.md` “surface_bright”).
  static const Color darkSurfaceBright = Color(0xFF282b3a);

  static const Color darkOnSurface = Color(0xFFf0f0fd);
  static const Color darkOnSurfaceVariant = Color(0xFFaaaab7);

  static const Color darkOutline = Color(0xFF5a5d6a);
  static const Color darkOutlineVariant = Color(0xFF464752);

  static const Color darkError = Color(0xFFff716c);
  static const Color darkOnError = Color(0xFF1a0504);
  static const Color darkErrorContainer = Color(0xFF8c3030);
  static const Color darkOnErrorContainer = Color(0xFFffdad6);

  /// Running / healthy / “online” — cyan primary story (not gold).
  static const Color darkStatusSuccessBackground = Color(0xFF103545);
  static const Color darkStatusSuccessForeground = Color(0xFF81ecff);

  /// Warning / paused — tertiary magenta (`DESIGN.md`), not amber.
  static const Color darkStatusWarningBackground = Color(0xFF3d2448);
  static const Color darkStatusWarningForeground = Color(0xFFfab0ff);

  /// In-progress / active task — same cyan family as primary.
  static const Color darkStatusRunningBackground = Color(0xFF103545);
  static const Color darkStatusRunningForeground = Color(0xFF81ecff);
  static const Color lightStatusRunningBackground = Color(0xFFDBEEFE);
  static const Color lightStatusRunningForeground = Color(0xFF004A9B);

  /// Stopped / neutral.
  static const Color darkStatusStoppedBackground = Color(0xFF171924);
  static const Color darkStatusStoppedForeground = Color(0xFFaaaab7);
  static const Color lightStatusStoppedBackground = Color(0xFFF0F0F5);
  static const Color lightStatusStoppedForeground = Color(0xFF5A5A66);

  /// Destructive actions — aligned with [darkError] coral.
  static const Color destructiveRed = darkError;

  // --- Light (minimum contrast pass; full Stitch light deferred) ---

  /// iOS-style grouped list background.
  static const Color lightGroupedScaffold = Color(0xFFF2F2F7);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFE8E8ED);
  static const Color lightSurfaceContainer = Color(0xFFE1E1E6);
  static const Color lightSurfaceContainerHigh = Color(0xFFD5D5DA);
  static const Color lightSurfaceContainerHighest = Color(0xFFFFFFFF);

  static const Color lightPrimary = Color(0xFF0061C8);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFD4E4FF);
  static const Color lightOnPrimaryContainer = Color(0xFF001D36);

  static const Color lightSecondary = Color(0xFF6B5720);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFF2E3BB);
  static const Color lightOnSecondaryContainer = Color(0xFF231C05);

  static const Color lightTertiary = Color(0xFF6B3A72);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFFFE6FA);
  static const Color lightOnTertiaryContainer = Color(0xFF57145E);

  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOnSurfaceVariant = Color(0xFF45464F);

  static const Color lightOutline = Color(0xFF767680);
  static const Color lightOutlineVariant = Color(0xFFC5C5CC);

  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF410002);

  static const Color lightStatusSuccessBackground = Color(0xFFE8F5E9);
  static const Color lightStatusSuccessForeground = Color(0xFF1B4332);
  static const Color lightStatusWarningBackground = Color(0xFFFFF0FC);
  static const Color lightStatusWarningForeground = Color(0xFF6B1D6E);

  // --- Chart series colors (§9) ---
  //
  // CPU: colorScheme.primary — from theme.
  // Memory: colorScheme.secondary — Stitch periwinkle `#7e98ff`, not gold.

  /// Network out: muted line distinct from [darkSecondary] fill intensity.
  static const Color chartNetworkOut = Color(0xFF9B8FA4);

  /// Disk read: warm accent (unchanged hue family for legibility).
  static const Color chartDiskRead = Color(0xFFFFB74D);

  /// Disk write: blue-grey.
  static const Color chartDiskWrite = Color(0xFF78909C);
}
