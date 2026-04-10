import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_storage.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_list_row.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

class ServerListScreen extends ConsumerWidget {
  const ServerListScreen({super.key});

  Future<bool> _confirmDismiss(
    BuildContext context,
    WidgetRef ref,
    Server server,
    AppLocalizations l10n,
  ) async {
    final storage = ref.read(serverStorageProvider);
    String? apiToken;
    String? username;
    String? password;

    switch (server.authType) {
      case ServerAuthType.apiToken:
        apiToken = await storage.readApiToken(server.id);
      case ServerAuthType.usernamePassword:
        final creds = await storage.readUsernamePassword(server.id);
        username = creds?.username;
        password = creds?.password;
    }

    await ref.read(serverListNotifierProvider.notifier).remove(server.id);

    if (!context.mounted) return true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.serverDeletedSnackbar),
        action: SnackBarAction(
          label: l10n.actionUndo,
          onPressed: () {
            ref
                .read(serverListNotifierProvider.notifier)
                .addOrUpdate(
                  server,
                  apiToken: apiToken,
                  username: username,
                  password: password,
                );
          },
        ),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(serverListNotifierProvider);

    Future<void> onPullRefresh() async {
      ref.invalidate(serverListNotifierProvider);
      await ref.read(serverListNotifierProvider.future);
    }

    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Widget body = RefreshIndicator(
      onRefresh: onPullRefresh,
      child: async.when(
        loading:
            () => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: const LoadingShimmer(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
        error:
            (Object error, StackTrace stackTrace) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: ErrorView(
                    message: l10n.serversLoadError,
                    onRetry: () => ref.invalidate(serverListNotifierProvider),
                  ),
                ),
              ],
            ),
        data: (servers) {
          if (servers.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: EmptyState(
                    icon: Icons.dns_outlined,
                    title: l10n.serversEmptyTitle,
                    message: l10n.serversEmptyMessage,
                    action: FilledButton.icon(
                      onPressed: () => context.push('/servers/add'),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.serversEmptyCta),
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              return Dismissible(
                key: ValueKey<String>(server.id),
                direction: DismissDirection.endToStart,
                confirmDismiss:
                    (_) => _confirmDismiss(context, ref, server, l10n),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: scheme.onErrorContainer,
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: PremiumListRow(
                    title: Text(server.name),
                    subtitle: Text(
                      l10n.serverListHostPortSubtitle(server.host, server.port),
                    ),
                    showChevron: true,
                    showDividerBelow: false,
                    onTap: () => context.push('/servers/edit/${server.id}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );

    return ShellSectionBody(
      title: Text(l10n.sectionServers),
      body: body,
      floatingActionButton: FloatingActionButton(
        heroTag: 'servers_list_fab',
        tooltip: l10n.serversFabAddTooltip,
        onPressed: () => context.push('/servers/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
