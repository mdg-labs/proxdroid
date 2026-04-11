import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/pill_segmented.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

/// User preferences (appearance, chart defaults, etc.).
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);
    final chartTf = ref.watch(defaultChartTimeframeProvider);

    return ShellSectionBody(
      title: Text(l10n.preferencesScreenTitle),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          GroupedSection(
            topSpacing: AppSpacing.lg,
            header: SectionHeader(title: l10n.settingsAppearanceSection),
            child: PillSegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text(l10n.settingsThemeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text(l10n.settingsThemeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text(l10n.settingsThemeSystem),
                  icon: const Icon(Icons.brightness_auto_outlined),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (Set<ThemeMode> selected) {
                final mode = selected.first;
                ref.read(appThemeModeProvider.notifier).setThemeMode(mode);
              },
            ),
          ),
          const Divider(height: 1),
          GroupedSection(
            topSpacing: 0,
            header: SectionHeader(title: l10n.preferencesChartsSection),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.preferencesDefaultChartTimeframeTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.preferencesDefaultChartTimeframeSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ChartTimeframeSelector(
                    selected: chartTf,
                    expandToWidth: true,
                    l10n: l10n,
                    onChanged:
                        (tf) => ref
                            .read(defaultChartTimeframeProvider.notifier)
                            .setTimeframe(tf),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
