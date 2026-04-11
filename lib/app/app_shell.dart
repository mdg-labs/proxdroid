import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/connectivity_provider.dart';
import 'package:proxdroid/shared/widgets/connectivity_banner.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';

bool _connectivityLooksOffline(List<ConnectivityResult> results) {
  if (results.isEmpty) return true;
  return results.every((r) => r == ConnectivityResult.none);
}

/// Hybrid shell layout: [Scaffold] with [NavigationBar] (primary tabs) and
/// a [NavigationDrawer] opened via the More tab (index 4).
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
      _scaffoldKey.currentState?.openDrawer();
      return;
    }
    widget.navigationShell.goBranch(
      index,
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
            child: showOffline
                ? SafeArea(bottom: false, child: const ConnectivityBanner())
                : const SizedBox(width: double.infinity),
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.35),
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: bottomSelectedIndex,
          onDestinationSelected: _onBottomNavTap,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: l10n.navDashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.computer_outlined),
              selectedIcon: const Icon(Icons.computer_rounded),
              label: l10n.navVMs,
            ),
            NavigationDestination(
              icon: const Icon(Icons.view_in_ar_outlined),
              selectedIcon: const Icon(Icons.view_in_ar_rounded),
              label: l10n.navContainers,
            ),
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: l10n.navTasks,
            ),
            NavigationDestination(
              icon: const Icon(Icons.apps_outlined),
              selectedIcon: const Icon(Icons.apps_rounded),
              label: l10n.navMore,
            ),
          ],
        ),
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
          const SizedBox(height: AppSpacing.xs),
          SectionHeader(
            title: l10n.drawerSectionInfrastructure,
            variant: SectionHeaderVariant.muted,
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.dns_outlined),
            selectedIcon: const Icon(Icons.dns_rounded),
            label: Text(l10n.sectionServers),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: Text(l10n.sectionDashboard),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.computer_outlined),
            selectedIcon: const Icon(Icons.computer_rounded),
            label: Text(l10n.sectionVms),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.view_in_ar_outlined),
            selectedIcon: const Icon(Icons.view_in_ar_rounded),
            label: Text(l10n.sectionContainers),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.storage_outlined),
            selectedIcon: const Icon(Icons.storage_rounded),
            label: Text(l10n.entityStorage),
          ),
          SectionHeader(
            title: l10n.drawerSectionOperations,
            variant: SectionHeaderVariant.muted,
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.backup_outlined),
            selectedIcon: const Icon(Icons.backup_rounded),
            label: Text(l10n.sectionBackups),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: Text(l10n.sectionTasks),
          ),
          NavigationDrawerDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: Text(l10n.sectionSettings),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Drawer branding header
// ────────────────────────────────────────────────────────────────────────────

class _DrawerBrandingHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final server = ref.watch(selectedServerProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App icon with premium gold ring
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.premiumAccent.withValues(alpha: 0.8),
                        AppColors.premiumAccent.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: const Icon(Icons.dns_rounded, size: 20),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        l10n.appDrawerSubtitle,
                        style: tt.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (server != null) ...[
              const SizedBox(height: AppSpacing.md),
              Material(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/servers');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          size: 15,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            server.name,
                            style: tt.labelMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: scheme.outlineVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
