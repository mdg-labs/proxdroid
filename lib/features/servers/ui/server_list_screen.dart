import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionServers),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.debugScreenBody(l10n.sectionServers),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.screenAddServer),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/servers/add'),
              ),
              ListTile(
                title: Text(l10n.screenEditServer),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/servers/edit/demo-server-id'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
