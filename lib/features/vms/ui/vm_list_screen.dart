import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class VmListScreen extends StatelessWidget {
  const VmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionVms),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.debugScreenBody(l10n.sectionVms),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.push('/vms/pve/100'),
                child: Text(l10n.entityVirtualMachine),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
