import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Shell layout: [Scaffold] with [NavigationDrawer] for primary sections.
class AppShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = _selectedIndexForLocation(currentPath);

    return Scaffold(
      body: child,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
