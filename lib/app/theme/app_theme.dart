import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'stitch_bottom_input_border.dart';

/// Consistent spacing scale — use these instead of magic numbers in widgets.
///
/// All values are multiples of 4 (4-point grid), matching Material 3 guidance.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

/// Application [ThemeData] for dark (default) and light Material 3 themes.
///
/// **Scaffold (Phase A / Stitch §1):** Dark canvas defaults to
/// [AppColors.scaffoldObsidian] (`#0c0e17`) for tonal layering with
/// `surface_container_*` tiers. [AppColors.scaffoldPureBlack] (`#000000`)
/// remains for an **OLED true-black** variant: deeper blacks save power on OLED
/// panels but remove visible separation from the darkest surface tokens—pick
/// per product preference and document any switch in `AppColors` / here.
///
/// **Typography:** [ThemeData.textTheme] uses bundled **Space Grotesk** +
/// **Inter** (variable TTFs under `assets/fonts/`, declared in `pubspec.yaml`)
/// via per-style [TextStyle.copyWith] — display / headline /
/// [TextTheme.titleLarge] use
/// Space Grotesk; body + labels + smaller titles use Inter, matching
/// `obsidian_flux/DESIGN.md` §3. The `google_fonts` package is listed for
/// optional future runtime/font-subset workflows; the app does not fetch fonts
/// over the network at startup.
///
/// **Deliberate non-defaults (T1.5):**
/// - [ColorScheme.surfaceTint] → transparent on dark (neutral cards, no
///   primary tint wash).
/// - [SnackBarThemeData.behavior] → floating; action text uses primary (§7.5).
/// - Dialog / bottom sheet shapes use 24–28 logical px radius (§2.3).
/// - [SegmentedButtonThemeData] / [ChipThemeData] use stadium radius (§2.3).
///
/// **Contrast:** See [AppColors] for `on_surface` / `on_surface_variant` targets.
abstract final class AppTheme {
  static ThemeData get dark => _buildTheme(
    colorScheme: _darkColorScheme,
    scaffoldBackground: AppColors.scaffoldObsidian,
  );

  static ThemeData get light => _buildTheme(
    colorScheme: _lightColorScheme,
    scaffoldBackground: AppColors.lightGroupedScaffold,
  );

  static ColorScheme get _darkColorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.darkPrimary,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    surfaceContainerLowest: AppColors.scaffoldObsidian,
    surfaceContainerLow: AppColors.darkSurfaceContainerLow,
    surfaceContainer: AppColors.darkSurfaceContainer,
    surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    surfaceTint: Colors.transparent,
  );

  static ColorScheme get _lightColorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.lightPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,
    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.lightSecondaryContainer,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,
    tertiary: AppColors.lightTertiary,
    onTertiary: AppColors.lightOnTertiary,
    tertiaryContainer: AppColors.lightTertiaryContainer,
    onTertiaryContainer: AppColors.lightOnTertiaryContainer,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    surfaceContainerLowest: AppColors.lightGroupedScaffold,
    surfaceContainerLow: AppColors.lightSurfaceContainerLow,
    surfaceContainer: AppColors.lightSurfaceContainer,
    surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    onErrorContainer: AppColors.lightOnErrorContainer,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
  );

  /// Space Grotesk for display / headline / [TextTheme.titleLarge]; Inter
  /// for body + labels (matches Material 3 “display” vs “body” split).
  static TextTheme _mergedTextTheme(Brightness brightness) {
    GoogleFonts.config.allowRuntimeFetching = false;
    final b = ThemeData(brightness: brightness, useMaterial3: true).textTheme;
    TextStyle? sg(TextStyle? s) => s?.copyWith(fontFamily: 'Space Grotesk');
    TextStyle? inter(TextStyle? s) => s?.copyWith(fontFamily: 'Inter');

    return b.copyWith(
      displayLarge: sg(b.displayLarge),
      displayMedium: sg(b.displayMedium),
      displaySmall: sg(b.displaySmall),
      headlineLarge: sg(b.headlineLarge),
      headlineMedium: sg(b.headlineMedium),
      headlineSmall: sg(b.headlineSmall),
      titleLarge: sg(b.titleLarge),
      titleMedium: inter(b.titleMedium),
      titleSmall: inter(b.titleSmall),
      bodyLarge: inter(b.bodyLarge),
      bodyMedium: inter(b.bodyMedium),
      bodySmall: inter(b.bodySmall),
      labelLarge: inter(b.labelLarge),
      labelMedium: inter(b.labelMedium),
      labelSmall: inter(b.labelSmall),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
  }) {
    const radiusLg = 16.0;
    const radiusMd = 12.0;
    const dialogRadius = 24.0;
    const sheetTopRadius = 28.0;
    const snackBarRadius = 14.0;
    const stadium = 999.0;

    final brightness = colorScheme.brightness;
    final textTheme = _mergedTextTheme(brightness);
    final primaryTextTheme = textTheme.apply(
      bodyColor: colorScheme.onPrimary,
      displayColor: colorScheme.onPrimary,
    );

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLg),
    );

    final pillShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(stadium),
    );

    final fieldRadius = BorderRadius.circular(radiusMd);
    StitchBottomInputBorder stitchFieldBorder({
      required Color color,
      required double width,
      bool glow = false,
    }) => StitchBottomInputBorder(
      borderRadius: fieldRadius,
      borderSide: BorderSide(color: color, width: width),
      glow: glow,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      splashFactory: InkRipple.splashFactory,
      splashColor: colorScheme.primary.withValues(alpha: 0.14),
      hoverColor: colorScheme.primary.withValues(alpha: 0.06),
      highlightColor: colorScheme.primary.withValues(alpha: 0.08),
      focusColor: colorScheme.primary.withValues(alpha: 0.10),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        indicatorShape: pillShape,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.10),
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            letterSpacing: 0.1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        elevation: 3,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(sheetTopRadius),
          ),
        ),
        dragHandleColor: colorScheme.onSurfaceVariant,
        dragHandleSize: const Size(40, 4),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(snackBarRadius),
        ),
        backgroundColor: colorScheme.surfaceContainer,
        contentTextStyle: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
        ),
        actionTextColor: colorScheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),
      chipTheme: ChipThemeData(
        shape: pillShape,
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.bodyMedium!.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.secondaryContainer,
        disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
        checkmarkColor: colorScheme.onSecondaryContainer,
        deleteIconColor: colorScheme.onSurfaceVariant,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surfaceContainer,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: stitchFieldBorder(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        enabledBorder: stitchFieldBorder(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
        disabledBorder: stitchFieldBorder(
          color: colorScheme.onSurface.withValues(alpha: 0.12),
          width: 1,
        ),
        focusedBorder: stitchFieldBorder(
          color: colorScheme.primary,
          width: 2.5,
          glow: true,
        ),
        errorBorder: stitchFieldBorder(
          color: colorScheme.error.withValues(alpha: 0.9),
          width: 1,
        ),
        focusedErrorBorder: stitchFieldBorder(
          color: colorScheme.error,
          width: 2.5,
          glow: true,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(pillShape),
          visualDensity: VisualDensity.compact,
          side: const WidgetStatePropertyAll(BorderSide.none),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.primaryContainer.withValues(alpha: 0.72);
            }
            return colorScheme.surfaceContainerHigh;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimaryContainer;
            }
            return colorScheme.onSurfaceVariant;
          }),
        ),
      ),
    );
  }
}
