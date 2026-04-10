import 'package:flutter/material.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class VmDetailScreen extends StatelessWidget {
  const VmDetailScreen({required this.node, required this.vmid, super.key});

  final String node;
  final String vmid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.entityVirtualMachine),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '${l10n.debugScreenBody(l10n.entityVirtualMachine)}\n$node / $vmid',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
