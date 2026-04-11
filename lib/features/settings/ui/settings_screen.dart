import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';
import 'package:url_launcher/url_launcher.dart';

const _githubRepoUrl = 'https://github.com/mdg-labs/proxdroid';
const _kofiUrl = 'https://ko-fi.com/';
const _githubSponsorsUrl = 'https://github.com/sponsors/mdg-labs';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || ok) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.settingsCouldNotOpenLink),
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showPremiumDialog<void>(
      context: context,
      title: Text(l10n.settingsLicenseTitle),
      content: Text(l10n.settingsLicenseSummary),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionClose),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return ShellSectionBody(
      title: Text(l10n.sectionSettings),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/icon/proxdroid_icon_foreground.png',
                  width: 88,
                  height: 88,
                  filterQuality: FilterQuality.medium,
                  semanticLabel: l10n.appTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.25,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          GroupedSection(
            topSpacing: 0,
            child: ListTile(
              leading: Icon(Icons.dns_outlined, color: scheme.onSurfaceVariant),
              title: Text(l10n.sectionServers),
              subtitle: Text(l10n.settingsServersSubtitle),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () => context.go('/servers'),
            ),
          ),
          const Divider(height: 1),
          GroupedSection(
            topSpacing: 0,
            child: ListTile(
              leading: Icon(
                Icons.tune_outlined,
                color: scheme.onSurfaceVariant,
              ),
              title: Text(l10n.settingsPreferencesTitle),
              subtitle: Text(l10n.settingsPreferencesSubtitle),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () => context.push('/settings/preferences'),
            ),
          ),
          const Divider(height: 1),
          GroupedSection(
            topSpacing: 0,
            header: SectionHeader(title: l10n.settingsTroubleshootingSection),
            child: SwitchListTile(
              title: Text(l10n.settingsVerboseConnectionErrors),
              subtitle: Text(l10n.settingsVerboseConnectionErrorsSubtitle),
              value: ref.watch(verboseConnectionErrorsProvider),
              onChanged: (v) {
                ref
                    .read(verboseConnectionErrorsProvider.notifier)
                    .setEnabled(v);
              },
            ),
          ),
          const Divider(height: 1),
          GroupedSection(
            topSpacing: 0,
            header: SectionHeader(title: l10n.settingsAboutSection),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                packageInfoAsync.when(
                  data:
                      (PackageInfo info) => ListTile(
                        title: Text(l10n.settingsVersion),
                        subtitle: Text(
                          l10n.settingsVersionSubtitle(
                            info.version,
                            info.buildNumber,
                          ),
                        ),
                      ),
                  loading:
                      () => ListTile(
                        title: Text(l10n.settingsVersion),
                        subtitle: Text(l10n.settingsLoading),
                      ),
                  error:
                      (Object error, StackTrace stackTrace) => ListTile(
                        title: Text(l10n.settingsVersion),
                        subtitle: Text(l10n.settingsVersionUnavailable),
                      ),
                ),
                ListTile(
                  title: Text(l10n.settingsSourceCode),
                  subtitle: Text(_githubRepoUrl),
                  trailing: Icon(
                    Icons.open_in_new,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _openUrl(context, _githubRepoUrl),
                ),
                ListTile(
                  title: Text(l10n.settingsLicenseTitle),
                  subtitle: Text(l10n.settingsLicenseTileSubtitle),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _showLicenseDialog(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          GroupedSection(
            topSpacing: 0,
            header: SectionHeader(title: l10n.settingsSupportSection),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(l10n.settingsSupportKofi),
                  subtitle: Text(_kofiUrl),
                  trailing: Icon(
                    Icons.open_in_new,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _openUrl(context, _kofiUrl),
                ),
                ListTile(
                  title: Text(l10n.settingsSupportGithubSponsors),
                  subtitle: Text(_githubSponsorsUrl),
                  trailing: Icon(
                    Icons.open_in_new,
                    color: scheme.onSurfaceVariant,
                  ),
                  onTap: () => _openUrl(context, _githubSponsorsUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
