import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/connectivity_provider.dart';
import 'package:proxdroid/shared/widgets/connectivity_banner.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';

bool _connectivityLooksOffline(List<ConnectivityResult> results) {
  if (results.isEmpty) {
    return true;
  }
  return results.every((r) => r == ConnectivityResult.none);
}

/// Hybrid shell layout (§4.2 / Phase 4 / T4.2): [Scaffold] with a
/// [NavigationBar] for the four primary tabs plus a **More** tab that opens
/// the [NavigationDrawer] as the full destination menu.
///
/// **Bottom nav (T4.2):** Five [NavigationDestination]s — Dashboard, VMs,
/// Containers, Tasks, and More. Tapping the More tab (index 4) opens the
/// [NavigationDrawer] instead of navigating. Tapping tabs 0–3 calls
/// [StatefulNavigationShell.goBranch] with the matching branch index.
/// The selected index is driven by [StatefulNavigationShell.currentIndex]
/// so it always reflects the active go_router branch.
///
/// **Drawer selection (T4.5):** Drawer highlight follows [currentPath] via
/// [_drawerIndexForLocation], independent of the bottom bar index, so both
/// always match the actual active route.
///
/// **Offline banner (T3.7):** [connectivityProvider] emits the plugin's
/// initial [Connectivity.checkConnectivity] result, then
/// [Connectivity.onConnectivityChanged]. The strip appears within **~1 s** of
/// the platform reporting a loss. [AnimatedSize] wraps the banner so height
/// changes animate instead of snapping (§6.1).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    required this.currentPath,
    required this.navigationShell,
    super.key,
  });

  final String currentPath;
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Indices match [kDrawerPaths] order (eight primary destinations).
  static int _drawerIndexForLocation(String location) {
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

  static const List<String> kDrawerPaths = <String>[
    '/servers',
    '/dashboard',
    '/vms',
    '/containers',
    '/storage',
    '/backups',
    '/tasks',
    '/settings',
  ];

  void _onBottomNavTap(int index) {
    if (index == 4) {
      // "More" tab opens the full drawer rather than navigating.
      _scaffoldKey.currentState?.openDrawer();
      return;
    }
    widget.navigationShell.goBranch(
      index,
      // Navigate to the branch's initial location when re-tapping the active tab.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final drawerSelectedIndex = _drawerIndexForLocation(widget.currentPath);
    final bottomSelectedIndex = widget.navigationShell.currentIndex;

    final connectivityAsync = ref.watch(connectivityProvider);
    final showOffline = connectivityAsync.when(
      data: _connectivityLooksOffline,
      loading: () => false,
      error: (_, _) => false,
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            clipBehavior: Clip.hardEdge,
            child:
                showOffline
                    ? SafeArea(bottom: false, child: const ConnectivityBanner())
                    : const SizedBox(width: double.infinity),
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomSelectedIndex,
        onDestinationSelected: _onBottomNavTap,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.computer_outlined),
            selectedIcon: const Icon(Icons.computer),
            label: l10n.navVMs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: l10n.navContainers,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pending_actions_outlined),
            selectedIcon: const Icon(Icons.pending_actions),
            label: l10n.navTasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_outlined),
            selectedIcon: const Icon(Icons.menu),
            label: l10n.navMore,
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: drawerSelectedIndex,
        onDestinationSelected: (index) {
          Navigator.of(context).pop();
          if (index >= 0 && index < kDrawerPaths.length) {
            context.go(kDrawerPaths[index]);
          }
        },
        children: [
          _DrawerBrandingHeader(),
          Divider(height: 1, thickness: 1, color: scheme.outlineVariant),
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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Material(
        color: scheme.surfaceContainerHigh,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.premiumAccent.withValues(alpha: 0.65),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.onPrimaryContainer,
                      child: const Icon(Icons.dns_rounded),
                    ),
                  ),
                  const SizedBox(width: 14),
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
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          size: 18,
                          color: scheme.primary,
                        ),
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
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: scheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
