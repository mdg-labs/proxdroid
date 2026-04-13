import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/features/backups/providers/backup_providers.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';

/// Target guest for a manual vzdump (VM or LXC).
class BackupGuestTarget {
  const BackupGuestTarget({
    required this.node,
    required this.vmid,
    required this.isLxc,
    required this.displayLabel,
  });

  final String node;
  final int vmid;
  final bool isLxc;
  final String displayLabel;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupGuestTarget && other.node == node && other.vmid == vmid;

  @override
  int get hashCode => Object.hash(node, vmid);
}

enum _BackupCompress { zstd, lzo, gzip, none }

enum _BackupMode { snapshot, suspend, stop }

String _compressApiValue(_BackupCompress c) => switch (c) {
  _BackupCompress.none => '0',
  _BackupCompress.zstd => 'zstd',
  _BackupCompress.lzo => 'lzo',
  _BackupCompress.gzip => 'gzip',
};

String _modeApiValue(_BackupMode m) => switch (m) {
  _BackupMode.snapshot => 'snapshot',
  _BackupMode.suspend => 'suspend',
  _BackupMode.stop => 'stop',
};

/// Opens the vzdump bottom sheet. [initialGuest] pre-fills VM/LXC when non-null.
Future<void> showTriggerBackupSheet(
  BuildContext context,
  WidgetRef ref, {
  BackupGuestTarget? initialGuest,
}) {
  return showPremiumModalBottomSheet<void>(
    context: context,
    builder:
        (ctx) => PremiumBottomSheet(
          child: TriggerBackupSheet(initialGuest: initialGuest),
        ),
  );
}

class TriggerBackupSheet extends ConsumerStatefulWidget {
  const TriggerBackupSheet({this.initialGuest, super.key});

  final BackupGuestTarget? initialGuest;

  @override
  ConsumerState<TriggerBackupSheet> createState() => _TriggerBackupSheetState();
}

class _TriggerBackupSheetState extends ConsumerState<TriggerBackupSheet> {
  BackupGuestTarget? _guest;
  Storage? _storage;
  _BackupCompress _compress = _BackupCompress.zstd;
  _BackupMode _mode = _BackupMode.snapshot;
  bool _busy = false;

  Widget _labeledDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                borderRadius: BorderRadius.circular(12),
                items: items,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<ProxmoxGuestTag> _tagsForGuestTarget(
    BackupGuestTarget t,
    List<Vm> vms,
    List<px.Container> cts,
  ) {
    if (t.isLxc) {
      for (final c in cts) {
        if (c.node == t.node && c.vmid == t.vmid) return c.tags;
      }
    } else {
      for (final v in vms) {
        if (v.node == t.node && v.vmid == t.vmid) return v.tags;
      }
    }
    return const [];
  }

  List<BackupGuestTarget> _buildGuests(List<Vm> vms, List<px.Container> cts) {
    final l10n = AppLocalizations.of(context)!;
    final out = <BackupGuestTarget>[];
    for (final v in vms) {
      final name =
          v.name.isEmpty ? '${l10n.entityVirtualMachine} ${v.vmid}' : v.name;
      out.add(
        BackupGuestTarget(
          node: v.node,
          vmid: v.vmid,
          isLxc: false,
          displayLabel: '$name (${l10n.entityVirtualMachine})',
        ),
      );
    }
    for (final c in cts) {
      final name =
          c.name.isEmpty ? '${l10n.entityContainer} ${c.vmid}' : c.name;
      out.add(
        BackupGuestTarget(
          node: c.node,
          vmid: c.vmid,
          isLxc: true,
          displayLabel: '$name (${l10n.entityContainer})',
        ),
      );
    }
    out.sort((a, b) => a.displayLabel.compareTo(b.displayLabel));
    return out;
  }

  BackupGuestTarget? _effectiveGuest(List<BackupGuestTarget> guests) {
    final want = _guest ?? widget.initialGuest;
    if (want != null) {
      for (final x in guests) {
        if (x == want) {
          return x;
        }
      }
    }
    return guests.isNotEmpty ? guests.first : null;
  }

  List<Storage> _backupStorages(List<Storage> all) {
    return all
        .where((s) => s.content.any((c) => c.toLowerCase() == 'backup'))
        .toList();
  }

  Storage? _effectiveStorage(List<Storage> targets, BackupGuestTarget? guest) {
    if (_storage != null) {
      for (final s in targets) {
        if (s.id == _storage!.id && s.node == _storage!.node) {
          return s;
        }
      }
    }
    if (guest != null) {
      for (final s in targets) {
        if (s.node == guest.node) {
          return s;
        }
      }
    }
    return targets.isNotEmpty ? targets.first : null;
  }

  Future<void> _submit(
    AppLocalizations l10n,
    BackupGuestTarget guest,
    Storage store,
  ) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final repo = await ref.read(backupRepositoryProvider.future);
      if (repo == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.errorProxmoxUnknown)),
        );
        return;
      }
      final upid = await repo.triggerVzdump(
        guest.node,
        vmid: guest.vmid,
        storage: store.id,
        mode: _modeApiValue(_mode),
        compress: _compressApiValue(_compress),
      );
      if (!mounted) return;
      router.pop();
      router.push(
        '/tasks/${Uri.encodeComponent(guest.node)}/${Uri.encodeComponent(upid)}',
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final tagColorMap =
        ref.watch(proxmoxTagColorsProvider).valueOrNull ??
        const <String, String>{};
    final vmsAsync = ref.watch(allVmsProvider);
    final ctsAsync = ref.watch(allContainersProvider);
    final storageAsync = ref.watch(allClusterStorageProvider);

    Widget inner;

    if (vmsAsync.hasError) {
      inner = Text(
        proxmoxExceptionMessage(vmsAsync.error!, l10n),
        style: TextStyle(color: scheme.error),
      );
    } else if (ctsAsync.hasError) {
      inner = Text(
        proxmoxExceptionMessage(ctsAsync.error!, l10n),
        style: TextStyle(color: scheme.error),
      );
    } else if (!vmsAsync.hasValue || !ctsAsync.hasValue) {
      inner = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const LinearProgressIndicator(minHeight: 4),
      );
    } else {
      final vms = vmsAsync.requireValue;
      final cts = ctsAsync.requireValue;
      final guests = _buildGuests(vms, cts);
      final guestVal = _effectiveGuest(guests);

      inner = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (guests.isEmpty)
            Text(l10n.backupListEmptyMessage)
          else
            _labeledDropdown<BackupGuestTarget>(
              label: l10n.backupFieldGuest,
              value: guestVal,
              items:
                  guests.map((x) {
                    final tags = _tagsForGuestTarget(x, vms, cts);
                    return DropdownMenuItem<BackupGuestTarget>(
                      value: x,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(x.displayLabel, overflow: TextOverflow.ellipsis),
                          if (tags.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            ProxmoxTagRow(
                              tags: tags,
                              clusterTagHexByLabel: tagColorMap,
                              density: ProxmoxTagDensity.compact,
                              spacing: 4,
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
              onChanged:
                  _busy
                      ? null
                      : (x) => setState(() {
                        _guest = x;
                        _storage = null;
                      }),
            ),
          const SizedBox(height: AppSpacing.lg),
          storageAsync.when(
            loading:
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(minHeight: 4),
                ),
            error:
                (e, _) => Text(
                  proxmoxExceptionMessage(e, l10n),
                  style: TextStyle(color: scheme.error),
                ),
            data: (all) {
              final targets = _backupStorages(all);
              if (targets.isEmpty) {
                return Text(l10n.backupNoDestinationStorage);
              }
              final storeVal = _effectiveStorage(targets, guestVal);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _labeledDropdown<Storage>(
                    label: l10n.backupFieldStorage,
                    value: storeVal,
                    items:
                        targets
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(
                                  l10n.storagePoolOnNode(s.id, s.node),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        _busy ? null : (s) => setState(() => _storage = s),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _labeledDropdown<_BackupCompress>(
                    label: l10n.backupFieldCompress,
                    value: _compress,
                    items: [
                      DropdownMenuItem(
                        value: _BackupCompress.zstd,
                        child: Text(l10n.backupCompressZstd),
                      ),
                      DropdownMenuItem(
                        value: _BackupCompress.lzo,
                        child: Text(l10n.backupCompressLzo),
                      ),
                      DropdownMenuItem(
                        value: _BackupCompress.gzip,
                        child: Text(l10n.backupCompressGzip),
                      ),
                      DropdownMenuItem(
                        value: _BackupCompress.none,
                        child: Text(l10n.backupCompressNone),
                      ),
                    ],
                    onChanged:
                        _busy
                            ? null
                            : (v) => setState(() => _compress = v ?? _compress),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _labeledDropdown<_BackupMode>(
                    label: l10n.backupFieldMode,
                    value: _mode,
                    items: [
                      DropdownMenuItem(
                        value: _BackupMode.snapshot,
                        child: Text(l10n.backupModeSnapshot),
                      ),
                      DropdownMenuItem(
                        value: _BackupMode.suspend,
                        child: Text(l10n.backupModeSuspend),
                      ),
                      DropdownMenuItem(
                        value: _BackupMode.stop,
                        child: Text(l10n.backupModeStop),
                      ),
                    ],
                    onChanged:
                        _busy
                            ? null
                            : (v) => setState(() => _mode = v ?? _mode),
                  ),
                ],
              );
            },
          ),
        ],
      );
    }

    var canSubmit = false;
    if (!_busy &&
        vmsAsync.hasValue &&
        ctsAsync.hasValue &&
        storageAsync.hasValue) {
      final guests = _buildGuests(vmsAsync.requireValue, ctsAsync.requireValue);
      final g = _effectiveGuest(guests);
      final targets = _backupStorages(storageAsync.requireValue);
      final s = _effectiveStorage(targets, g);
      canSubmit =
          guests.isNotEmpty && targets.isNotEmpty && g != null && s != null;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.backupTriggerTitle,
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.lg),
          Material(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: inner,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed:
                !canSubmit
                    ? null
                    : () {
                      final v = vmsAsync.asData?.value;
                      final c = ctsAsync.asData?.value;
                      final st = storageAsync.asData?.value;
                      if (v == null || c == null || st == null) {
                        return;
                      }
                      final guests = _buildGuests(v, c);
                      final g = _effectiveGuest(guests);
                      final targets = _backupStorages(st);
                      final s = _effectiveStorage(targets, g);
                      if (g == null || s == null) {
                        return;
                      }
                      _submit(l10n, g, s);
                    },
            child:
                _busy
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(l10n.backupTriggerStart),
          ),
        ],
      ),
    );
  }
}
