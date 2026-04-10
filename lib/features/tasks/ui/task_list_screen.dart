import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  static const String _sampleUpid =
      'UPID:pve:0000ABCD:00000001:5F3E45A2:qmstart:100:root@pam:';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionTasks),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.debugScreenBody(l10n.sectionTasks),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed:
                    () => context.push(
                      '/tasks/pve/${Uri.encodeComponent(_sampleUpid)}',
                    ),
                child: Text(l10n.entityTask),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
