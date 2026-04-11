import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/core/models/guest_config_indexed_line.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';
import 'package:proxdroid/features/containers/providers/container_config_providers.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/constants/pve_guest_enums.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/guest_config/guest_disk_volume_editor.dart';
import 'package:proxdroid/shared/widgets/guest_config/guest_net_line_editor.dart';
import 'package:proxdroid/shared/widgets/guest_config/guest_string_dropdown.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

String? _nullableTrim(String text) {
  final s = text.trim();
  return s.isEmpty ? null : s;
}

bool _truthyString(String? value) {
  if (value == null) {
    return false;
  }
  final s = value.trim().toLowerCase();
  return s == '1' || s == 'yes' || s == 'true' || s == 'on';
}

String _boolToPve(bool on) => on ? '1' : '0';

/// Tier-A LXC config editor (`/containers/:node/:ctid/edit`).
class ContainerEditScreen extends ConsumerStatefulWidget {
  const ContainerEditScreen({
    required this.node,
    required this.ctid,
    super.key,
  });

  final String node;
  final String ctid;

  @override
  ConsumerState<ContainerEditScreen> createState() =>
      _ContainerEditScreenState();
}

class _ContainerEditScreenState extends ConsumerState<ContainerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _appliedBindKey;
  bool _onBoot = false;
  bool _unprivileged = false;
  bool _saving = false;

  late final TextEditingController _hostname = TextEditingController();
  late final TextEditingController _description = TextEditingController();
  late final TextEditingController _tags = TextEditingController();
  late final TextEditingController _memory = TextEditingController();
  late final TextEditingController _swap = TextEditingController();
  late final TextEditingController _cores = TextEditingController();
  late final TextEditingController _cpulimit = TextEditingController();
  late final TextEditingController _cpuunits = TextEditingController();
  late final TextEditingController _ostype = TextEditingController();
  late final TextEditingController _arch = TextEditingController();
  late final TextEditingController _startup = TextEditingController();
  late final TextEditingController _features = TextEditingController();
  late final TextEditingController _rootfs = TextEditingController();

  final List<String> _netApiKeys = <String>[];
  final List<TextEditingController> _netControllers = <TextEditingController>[];
  final List<String> _mpApiKeys = <String>[];
  final List<TextEditingController> _mpControllers = <TextEditingController>[];

  @override
  void dispose() {
    _hostname.dispose();
    _description.dispose();
    _tags.dispose();
    _memory.dispose();
    _swap.dispose();
    _cores.dispose();
    _cpulimit.dispose();
    _cpuunits.dispose();
    _ostype.dispose();
    _arch.dispose();
    _startup.dispose();
    _features.dispose();
    _rootfs.dispose();
    for (final c in _netControllers) {
      c.dispose();
    }
    for (final c in _mpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _bindFromDraft(LxcContainerConfig draft, int bindKey) {
    if (_appliedBindKey == bindKey) {
      return;
    }
    _appliedBindKey = bindKey;
    _hostname.text = draft.hostname ?? '';
    _description.text = draft.description ?? '';
    _tags.text = draft.tags ?? '';
    _memory.text = draft.memory ?? '';
    _swap.text = draft.swap ?? '';
    _cores.text = draft.cores ?? '';
    _cpulimit.text = draft.cpulimit ?? '';
    _cpuunits.text = draft.cpuunits ?? '';
    _ostype.text = draft.ostype ?? '';
    _arch.text = draft.arch ?? '';
    _startup.text = draft.startup ?? '';
    _features.text = draft.features ?? '';
    _rootfs.text = draft.rootfs ?? '';
    _onBoot = _truthyString(draft.onboot);
    _unprivileged = _truthyString(draft.unprivileged);
    _syncIndexedLines(draft.netLines, _netApiKeys, _netControllers);
    _syncIndexedLines(draft.mpLines, _mpApiKeys, _mpControllers);
  }

  void _syncIndexedLines(
    List<GuestConfigIndexedLine> lines,
    List<String> keys,
    List<TextEditingController> ctrls,
  ) {
    while (ctrls.length < lines.length) {
      ctrls.add(TextEditingController());
    }
    while (ctrls.length > lines.length) {
      ctrls.removeLast().dispose();
    }
    keys
      ..clear()
      ..addAll(lines.map((e) => e.apiKey));
    for (var i = 0; i < lines.length; i++) {
      if (ctrls[i].text != lines[i].value) {
        ctrls[i].text = lines[i].value;
      }
    }
  }

  Widget _lxcOstypeField(AppLocalizations l10n) {
    final t = _ostype.text.trim();
    if (t.isNotEmpty && !pveLxcOstypeIds.contains(t)) {
      return TextFormField(
        controller: _ostype,
        decoration: InputDecoration(
          labelText: l10n.guestConfigFieldGuestOs,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
      );
    }
    return GuestStringDropdown(
      label: l10n.guestConfigFieldGuestOs,
      ids: pveLxcOstypeIds,
      value: t.isEmpty ? 'debian' : t,
      enabled: !_saving,
      onChanged: (v) {
        if (v != null) {
          setState(() => _ostype.text = v);
        }
      },
    );
  }

  bool _lxcGuestIsLive() {
    final id = int.tryParse(widget.ctid);
    if (id == null) {
      return false;
    }
    final cts = ref.watch(allContainersProvider).valueOrNull;
    if (cts == null) {
      return false;
    }
    for (final c in cts) {
      if (c.node == widget.node && c.vmid == id) {
        return c.status == ContainerStatus.running;
      }
    }
    return false;
  }

  void _onReorderNet(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final k = _netApiKeys.removeAt(oldIndex);
      _netApiKeys.insert(newIndex, k);
      final c = _netControllers.removeAt(oldIndex);
      _netControllers.insert(newIndex, c);
    });
  }

  void _onReorderMp(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final k = _mpApiKeys.removeAt(oldIndex);
      _mpApiKeys.insert(newIndex, k);
      final c = _mpControllers.removeAt(oldIndex);
      _mpControllers.insert(newIndex, c);
    });
  }

  void _addNetLine() {
    setState(() {
      var maxN = -1;
      for (final k in _netApiKeys) {
        final n = guestConfigNetSuffix(k);
        if (n != null) {
          maxN = maxN > n ? maxN : n;
        }
      }
      final n = (maxN + 1).clamp(0, 31);
      _netApiKeys.add('net$n');
      _netControllers.add(
        TextEditingController(text: 'name=eth0,bridge=vmbr0,ip=dhcp'),
      );
    });
  }

  void _removeNetAt(int i) {
    setState(() {
      _netControllers.removeAt(i).dispose();
      _netApiKeys.removeAt(i);
    });
  }

  void _addMpLine() {
    setState(() {
      var maxM = -1;
      for (final k in _mpApiKeys) {
        final m = RegExp(r'^mp(\d+)$').firstMatch(k);
        if (m != null) {
          final v = int.parse(m.group(1)!);
          maxM = maxM > v ? maxM : v;
        }
      }
      final n = maxM + 1;
      _mpApiKeys.add('mp$n');
      _mpControllers.add(TextEditingController());
    });
  }

  void _removeMpAt(int i) {
    setState(() {
      _mpControllers.removeAt(i).dispose();
      _mpApiKeys.removeAt(i);
    });
  }

  LxcContainerConfig _draftFromForm(
    LxcContainerConfig template, {
    required bool lockGuestLinks,
  }) {
    final onboot =
        _onBoot == _truthyString(template.onboot)
            ? template.onboot
            : _boolToPve(_onBoot);
    final unprivileged =
        _unprivileged == _truthyString(template.unprivileged)
            ? template.unprivileged
            : _boolToPve(_unprivileged);
    return template.copyWith(
      hostname: _nullableTrim(_hostname.text),
      description: _nullableTrim(_description.text),
      tags: _nullableTrim(_tags.text),
      memory: _nullableTrim(_memory.text),
      swap: _nullableTrim(_swap.text),
      cores: _nullableTrim(_cores.text),
      cpulimit: _nullableTrim(_cpulimit.text),
      cpuunits: _nullableTrim(_cpuunits.text),
      ostype: _nullableTrim(_ostype.text),
      arch: _nullableTrim(_arch.text),
      onboot: onboot,
      startup: _nullableTrim(_startup.text),
      unprivileged: unprivileged,
      features: _nullableTrim(_features.text),
      rootfs: lockGuestLinks ? template.rootfs : _nullableTrim(_rootfs.text),
      netLines:
          lockGuestLinks
              ? List<GuestConfigIndexedLine>.from(template.netLines)
              : List<GuestConfigIndexedLine>.generate(
                _netApiKeys.length,
                (i) => GuestConfigIndexedLine(
                  apiKey: _netApiKeys[i],
                  value: _netControllers[i].text.trim(),
                ),
              ),
      mpLines:
          lockGuestLinks
              ? List<GuestConfigIndexedLine>.from(template.mpLines)
              : List<GuestConfigIndexedLine>.generate(
                _mpApiKeys.length,
                (i) => GuestConfigIndexedLine(
                  apiKey: _mpApiKeys[i],
                  value: _mpControllers[i].text.trim(),
                ),
              ),
    );
  }

  Future<void> _save(AppLocalizations l10n, String node, int ctid) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final cur =
        ref.read(lxcContainerConfigEditorProvider(node, ctid)).requireValue;
    final guestLive = _lxcGuestIsLive();
    final edited = _draftFromForm(cur.draft, lockGuestLinks: guestLive);
    final delta = lxcContainerConfigDeltaResult(cur.original, edited);
    if (delta.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.guestConfigSaveNothingChanged)),
      );
      return;
    }
    if (!guestLive && delta.needsRiskConfirmation) {
      final ok = await showPremiumDialog<bool>(
        context: context,
        title: Text(l10n.guestConfigRiskConfirmTitle),
        content: Text(
          l10n.guestConfigRiskConfirmBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.guestConfigRiskConfirmAction),
          ),
        ],
      );
      if (ok != true || !mounted) {
        return;
      }
    }
    setState(() => _saving = true);
    try {
      ref
          .read(lxcContainerConfigEditorProvider(node, ctid).notifier)
          .updateDraft(edited);
      await ref
          .read(lxcContainerConfigEditorProvider(node, ctid).notifier)
          .save();
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.guestConfigSaveSuccess)),
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final id = int.tryParse(widget.ctid);
    if (id == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.screenEditContainerConfig),
          ),
          Expanded(
            child: ErrorView(
              message: l10n.containerNotFoundMessage,
              onRetry: () => context.pop(),
            ),
          ),
        ],
      );
    }

    final node = widget.node;
    final ctid = id;
    final async = ref.watch(lxcContainerConfigEditorProvider(node, ctid));

    return async.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditContainerConfig),
              ),
              const Expanded(child: LoadingShimmer(itemCount: 6)),
            ],
          ),
      error:
          (e, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditContainerConfig),
              ),
              Expanded(
                child: ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry:
                      () => ref.invalidate(
                        lxcContainerConfigEditorProvider(node, ctid),
                      ),
                ),
              ),
            ],
          ),
      data: (state) {
        final guestLive = _lxcGuestIsLive();
        if (_appliedBindKey != state.bindKey) {
          final bk = state.bindKey;
          final draft = state.draft;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _appliedBindKey == bk) {
              return;
            }
            setState(() => _bindFromDraft(draft, bk));
          });
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              leading: shellAppBarLeading(context),
              title: Text(l10n.screenEditContainerConfig),
              actions: [
                TextButton(
                  onPressed:
                      _saving
                          ? null
                          : () {
                            ref
                                .read(
                                  lxcContainerConfigEditorProvider(
                                    node,
                                    ctid,
                                  ).notifier,
                                )
                                .resetFromServer();
                          },
                  child: Text(l10n.guestConfigActionDiscard),
                ),
                TextButton(
                  onPressed: _saving ? null : () => _save(l10n, node, ctid),
                  child:
                      _saving
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.primary,
                            ),
                          )
                          : Text(l10n.actionSave),
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(
                        title: l10n.guestConfigSectionIdentity,
                      ),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _hostname,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldHostname,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _description,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldDescription,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _tags,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldTags,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(
                        title: l10n.guestConfigSectionResources,
                      ),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _memory,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldMemory,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _swap,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldSwap,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(title: l10n.guestConfigSectionCpu),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _cores,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldCores,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cpulimit,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldCpuLimit,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cpuunits,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldCpuUnits,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(
                        title: l10n.guestConfigSectionNetworks,
                      ),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (guestLive)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  l10n.guestConfigNetworksLockedWhileRunning,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ReorderableListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              onReorder:
                                  guestLive || _saving
                                      ? (int _, int _) {}
                                      : _onReorderNet,
                              children: [
                                for (var i = 0; i < _netApiKeys.length; i++)
                                  Material(
                                    key: ValueKey<String>(_netApiKeys[i]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReorderableDragStartListener(
                                            index: i,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                right: 8,
                                              ),
                                              child: Icon(
                                                Icons.drag_handle,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.outline,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GuestNetLineEditor(
                                              key: ValueKey<String>(
                                                '${state.bindKey}_net_${_netApiKeys[i]}',
                                              ),
                                              node: node,
                                              isQemu: false,
                                              value: _netControllers[i].text,
                                              enabled: !guestLive && !_saving,
                                              onChanged:
                                                  (s) => setState(
                                                    () =>
                                                        _netControllers[i]
                                                            .text = s,
                                                  ),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip:
                                                l10n.guestConfigRemoveInterface,
                                            onPressed:
                                                guestLive || _saving
                                                    ? null
                                                    : () => _removeNetAt(i),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed:
                                    guestLive || _saving ? null : _addNetLine,
                                icon: const Icon(Icons.add),
                                label: Text(l10n.guestConfigAddNetwork),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(
                        title: l10n.guestConfigSectionMounts,
                      ),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (guestLive)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  l10n.guestConfigMountsLockedWhileRunning,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ReorderableListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              onReorder:
                                  guestLive || _saving
                                      ? (int _, int _) {}
                                      : _onReorderMp,
                              children: [
                                for (var i = 0; i < _mpApiKeys.length; i++)
                                  Material(
                                    key: ValueKey<String>(_mpApiKeys[i]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReorderableDragStartListener(
                                            index: i,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                right: 8,
                                              ),
                                              child: Icon(
                                                Icons.drag_handle,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.outline,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  _mpApiKeys[i],
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.titleSmall,
                                                ),
                                                const SizedBox(height: 8),
                                                GuestDiskVolumeEditor(
                                                  key: ValueKey<String>(
                                                    '${state.bindKey}_mp_${_mpApiKeys[i]}',
                                                  ),
                                                  node: node,
                                                  contentKind: 'rootdir',
                                                  value: _mpControllers[i].text,
                                                  enabled:
                                                      !guestLive && !_saving,
                                                  onChanged:
                                                      (s) => setState(
                                                        () =>
                                                            _mpControllers[i]
                                                                .text = s,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            tooltip:
                                                l10n.guestConfigRemoveMountPoint,
                                            onPressed:
                                                guestLive || _saving
                                                    ? null
                                                    : () => _removeMpAt(i),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed:
                                    guestLive || _saving ? null : _addMpLine,
                                icon: const Icon(Icons.add),
                                label: Text(l10n.guestConfigAddMountPoint),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(title: l10n.guestConfigSectionBoot),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.guestConfigFieldOnBoot),
                              value: _onBoot,
                              onChanged:
                                  _saving
                                      ? null
                                      : (v) => setState(() => _onBoot = v),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _startup,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldStartupOrder,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    GroupedSection(
                      topSpacing: 0,
                      header: SectionHeader(
                        title: l10n.guestConfigSectionOptions,
                      ),
                      gapAfterHeader: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.guestConfigFieldUnprivileged),
                              value: _unprivileged,
                              onChanged:
                                  _saving
                                      ? null
                                      : (v) =>
                                          setState(() => _unprivileged = v),
                            ),
                            const SizedBox(height: 16),
                            _lxcOstypeField(l10n),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _arch,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldArchitecture,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _features,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldFeatures,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            if (guestLive)
                              TextFormField(
                                controller: _rootfs,
                                decoration: InputDecoration(
                                  labelText: l10n.guestConfigFieldRootfs,
                                  helperText:
                                      l10n.guestConfigRootfsLockedWhileRunning,
                                  border: const OutlineInputBorder(),
                                ),
                                readOnly: true,
                                maxLines: 2,
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.guestConfigFieldRootfs,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.guestConfigRootfsEditHint,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  GuestDiskVolumeEditor(
                                    key: ValueKey<String>(
                                      '${state.bindKey}_rootfs',
                                    ),
                                    node: node,
                                    contentKind: 'rootdir',
                                    value: _rootfs.text,
                                    enabled: !_saving,
                                    onChanged:
                                        (s) => setState(() => _rootfs.text = s),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
