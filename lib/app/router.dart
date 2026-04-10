import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/app_shell.dart';
import 'package:proxdroid/features/backups/ui/backup_list_screen.dart';
import 'package:proxdroid/features/containers/ui/container_detail_screen.dart';
import 'package:proxdroid/features/containers/ui/container_list_screen.dart';
import 'package:proxdroid/features/dashboard/ui/dashboard_screen.dart';
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

/// Global go_router instance (Phase 0 — no [selectedServerProvider] redirect).
final GoRouter goRouter = GoRouter(
  initialLocation: '/servers',
  redirect: (BuildContext context, GoRouterState state) {
    if (state.uri.path == '/') {
      return '/servers';
    }
    return null;
  },
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
                final node = state.pathParameters['node']!;
                final vmid = state.pathParameters['vmid']!;
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
                final node = state.pathParameters['node']!;
                final ctid = state.pathParameters['ctid']!;
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
                final node = state.pathParameters['node']!;
                final storage = state.pathParameters['storage']!;
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
                final node = state.pathParameters['node']!;
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
