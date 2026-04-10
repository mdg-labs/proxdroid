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
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(currentPath: state.uri.path, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/servers',
            builder: (BuildContext context, GoRouterState state) {
              return const ServerListScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'add',
                builder: (BuildContext context, GoRouterState state) {
                  return const AddServerScreen();
                },
              ),
              GoRoute(
                path: 'edit/:serverId',
                builder: (BuildContext context, GoRouterState state) {
                  final serverId = state.pathParameters['serverId']!;
                  return EditServerScreen(serverId: serverId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/dashboard',
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: '/vms',
            builder: (BuildContext context, GoRouterState state) {
              return const VmListScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: ':node/:vmid',
                builder: (BuildContext context, GoRouterState state) {
                  final node = Uri.decodeComponent(
                    state.pathParameters['node']!,
                  );
                  final vmid = Uri.decodeComponent(
                    state.pathParameters['vmid']!,
                  );
                  return VmDetailScreen(node: node, vmid: vmid);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/containers',
            builder: (BuildContext context, GoRouterState state) {
              return const ContainerListScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: ':node/:ctid',
                builder: (BuildContext context, GoRouterState state) {
                  final node = Uri.decodeComponent(
                    state.pathParameters['node']!,
                  );
                  final ctid = Uri.decodeComponent(
                    state.pathParameters['ctid']!,
                  );
                  return ContainerDetailScreen(node: node, ctid: ctid);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/storage',
            builder: (BuildContext context, GoRouterState state) {
              return const StorageListScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: ':node/:storage',
                builder: (BuildContext context, GoRouterState state) {
                  final node = Uri.decodeComponent(
                    state.pathParameters['node']!,
                  );
                  final storage = Uri.decodeComponent(
                    state.pathParameters['storage']!,
                  );
                  return StorageDetailScreen(node: node, storage: storage);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/backups',
            builder: (BuildContext context, GoRouterState state) {
              return const BackupListScreen();
            },
          ),
          GoRoute(
            path: '/tasks',
            builder: (BuildContext context, GoRouterState state) {
              return const TaskListScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                path: ':node/:upid',
                builder: (BuildContext context, GoRouterState state) {
                  final node = Uri.decodeComponent(
                    state.pathParameters['node']!,
                  );
                  final upidParam = state.pathParameters['upid']!;
                  final upid = Uri.decodeComponent(upidParam);
                  return TaskDetailScreen(node: node, upid: upid);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
          ),
        ],
      ),
    ],
  );

  ref.onDispose(goRouter.dispose);
  return goRouter;
}
