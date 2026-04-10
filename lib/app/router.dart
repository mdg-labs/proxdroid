import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/app_shell.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/features/backups/ui/backup_list_screen.dart';
import 'package:proxdroid/features/containers/ui/container_detail_screen.dart';
import 'package:proxdroid/features/containers/ui/container_list_screen.dart';
import 'package:proxdroid/features/dashboard/ui/dashboard_screen.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/servers/ui/add_server_screen.dart';
import 'package:proxdroid/features/servers/ui/edit_server_screen.dart';
import 'package:proxdroid/features/servers/ui/server_list_screen.dart';
import 'package:proxdroid/features/settings/ui/settings_screen.dart';
import 'package:proxdroid/features/storage/ui/storage_detail_screen.dart';
import 'package:proxdroid/features/storage/ui/storage_list_screen.dart';
import 'package:proxdroid/features/tasks/ui/task_detail_screen.dart';
import 'package:proxdroid/features/tasks/ui/task_list_screen.dart';
import 'package:proxdroid/features/vms/ui/vm_detail_screen.dart';
import 'package:proxdroid/features/vms/ui/vm_list_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

CustomTransitionPage<void> _fadeShellPage(GoRouterState state, Widget screen) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: screen,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

/// Notifies [GoRouter] when server list or selection changes so [GoRouter.redirect] re-runs.
final class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    _listSub = ref.listen(
      serverListNotifierProvider,
      (_, _) => notifyListeners(),
    );
    _selectedSub = ref.listen(
      selectedServerProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription<AsyncValue<List<Server>>> _listSub;
  late final ProviderSubscription<Server?> _selectedSub;

  @override
  void dispose() {
    _listSub.close();
    _selectedSub.close();
    super.dispose();
  }
}

String? _redirectForServer(Ref ref, GoRouterState state) {
  final selected = ref.read(selectedServerProvider);
  final path = state.uri.path;

  if (path == '/') {
    return selected != null ? '/dashboard' : '/servers';
  }

  if (selected == null) {
    const apiPrefixes = <String>[
      '/dashboard',
      '/vms',
      '/containers',
      '/storage',
      '/backups',
      '/tasks',
    ];
    for (final prefix in apiPrefixes) {
      if (path == prefix || path.startsWith('$prefix/')) {
        return '/servers';
      }
    }
  }

  return null;
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = GoRouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  final goRouter = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect:
        (BuildContext context, GoRouterState state) =>
            _redirectForServer(ref, state),
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShell(
            currentPath: state.uri.path,
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          // Branch 0 — Dashboard (bottom nav tab 0)
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/dashboard',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const DashboardScreen()),
              ),
            ],
          ),

          // Branch 1 — VMs (bottom nav tab 1)
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/vms',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const VmListScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':node/:vmid',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final node = Uri.decodeComponent(
                        state.pathParameters['node']!,
                      );
                      final vmid = Uri.decodeComponent(
                        state.pathParameters['vmid']!,
                      );
                      return _fadeShellPage(
                        state,
                        VmDetailScreen(node: node, vmid: vmid),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 2 — Containers (bottom nav tab 2)
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/containers',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const ContainerListScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':node/:ctid',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final node = Uri.decodeComponent(
                        state.pathParameters['node']!,
                      );
                      final ctid = Uri.decodeComponent(
                        state.pathParameters['ctid']!,
                      );
                      return _fadeShellPage(
                        state,
                        ContainerDetailScreen(node: node, ctid: ctid),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 3 — Tasks (bottom nav tab 3)
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/tasks',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const TaskListScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':node/:upid',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final node = Uri.decodeComponent(
                        state.pathParameters['node']!,
                      );
                      // UPID contains colons (e.g. UPID:node:...) — callers must
                      // percent-encode via Uri.encodeComponent before pushing this
                      // route. Decoded here to restore the canonical UPID string.
                      // T8.8: encoding verified present — see go_router.mdc rule.
                      final upidParam = state.pathParameters['upid']!;
                      final upid = Uri.decodeComponent(upidParam);
                      return _fadeShellPage(
                        state,
                        TaskDetailScreen(node: node, upid: upid),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 4 — More / overflow (bottom nav tab 4 opens drawer)
          // Holds /servers, /storage, /backups, /settings so the router can
          // resolve all 14 paths. Tapping "More" in the nav bar opens the
          // NavigationDrawer rather than navigating.
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/servers',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const ServerListScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'add',
                    pageBuilder:
                        (BuildContext context, GoRouterState state) =>
                            _fadeShellPage(state, const AddServerScreen()),
                  ),
                  GoRoute(
                    path: 'edit/:serverId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final serverId = state.pathParameters['serverId']!;
                      return _fadeShellPage(
                        state,
                        EditServerScreen(serverId: serverId),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/storage',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const StorageListScreen()),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':node/:storage',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final node = Uri.decodeComponent(
                        state.pathParameters['node']!,
                      );
                      final storage = Uri.decodeComponent(
                        state.pathParameters['storage']!,
                      );
                      return _fadeShellPage(
                        state,
                        StorageDetailScreen(node: node, storage: storage),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/backups',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const BackupListScreen()),
              ),
              GoRoute(
                path: '/settings',
                pageBuilder:
                    (BuildContext context, GoRouterState state) =>
                        _fadeShellPage(state, const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(goRouter.dispose);
  return goRouter;
}
