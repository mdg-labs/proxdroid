import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/servers/ui/server_editor_page.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class EditServerScreen extends ConsumerWidget {
  const EditServerScreen({required this.serverId, super.key});

  final String serverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncServer = ref.watch(serverByIdProvider(serverId));

    return asyncServer.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditServer),
              ),
              const Expanded(child: LoadingShimmer()),
            ],
          ),
      error:
          (Object error, StackTrace stackTrace) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditServer),
              ),
              Expanded(
                child: ErrorView(
                  message: l10n.serverEditLoadError,
                  onRetry: () => ref.invalidate(serverByIdProvider(serverId)),
                ),
              ),
            ],
          ),
      data: (server) {
        if (server == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditServer),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.serverNotFound,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => context.pop(),
                          child: Text(l10n.actionGoBack),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return ServerEditorPage(existingServer: server);
      },
    );
  }
}
