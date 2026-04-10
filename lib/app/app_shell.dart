import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/connectivity_provider.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';

bool _connectivityLooksOffline(List<ConnectivityResult> results) {
  if (results.isEmpty) {
    return true;
  }
  return results.every((r) => r == ConnectivityResult.none);
}

/// Shell layout: [Scaffold] with [NavigationDrawer] for primary sections.
class AppShell extends ConsumerWidget {
  const AppShell({required this.child, required this.currentPath, super.key});

  final Widget child;
  final String currentPath;

  static int _selectedIndexForLocation(String location) {
    if (location.startsWith('/servers')) return 0;
    if (location.startsWith('/dashboard')) return 1;
    if (location.startsWith('/vms')) return 2;
    if (location.startsWith('/containers')) return 3;
    if (location.startsWith('/storage')) return 4;
    if (location.startsWith('/backups')) return 5;
    if (location.startsWith('/tasks')) return 6;
    if (location.startsWith('/settings')) return 7;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedIndex = _selectedIndexForLocation(currentPath);

    final connectivityAsync = ref.watch(connectivityProvider);
    final showOffline = connectivityAsync.when(
      data: _connectivityLooksOffline,
      loading: () => false,
      error: (_, _) => false,
    );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showOffline)
            Material(
              color: scheme.errorContainer,
              elevation: 1,
              shadowColor: scheme.shadow,
              surfaceTintColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: scheme.onErrorContainer,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.offlineBannerMessage,
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: child),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          const paths = <String>[
            '/servers',
            '/dashboard',
            '/vms',
            '/containers',
            '/storage',
            '/backups',
            '/tasks',
            '/settings',
          ];
          if (index >= 0 && index < paths.length) {
            context.go(paths[index]);
          }
        },
        children: [
          _DrawerBrandingHeader(),
          const Divider(height: 1),
          SectionHeader(
            title: l10n.drawerSectionInfrastructure,
            variant: SectionHeaderVariant.muted,
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.dns_outlined),
            selectedIcon: const Icon(Icons.dns),
            label: Text(l10n.sectionServers),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: Text(l10n.sectionDashboard),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.computer_outlined),
            selectedIcon: const Icon(Icons.computer),
            label: Text(l10n.sectionVms),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: Text(l10n.sectionContainers),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.storage_outlined),
            selectedIcon: const Icon(Icons.storage),
            label: Text(l10n.entityStorage),
          ),
          SectionHeader(
            title: l10n.drawerSectionOperations,
            variant: SectionHeaderVariant.muted,
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.backup_outlined),
            selectedIcon: const Icon(Icons.backup),
            label: Text(l10n.sectionBackups),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.pending_actions_outlined),
            selectedIcon: const Icon(Icons.pending_actions),
            label: Text(l10n.sectionTasks),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: Text(l10n.sectionSettings),
          ),
        ],
      ),
    );
  }
}

class _DrawerBrandingHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final server = ref.watch(selectedServerProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: const Icon(Icons.dns_rounded),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.appTitle, style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      l10n.appDrawerSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (server != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                context.go('/servers');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    Icon(Icons.link_rounded, size: 18, color: scheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        server.name,
                        style: textTheme.labelLarge?.copyWith(
                          color: scheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 20, color: scheme.outline),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
