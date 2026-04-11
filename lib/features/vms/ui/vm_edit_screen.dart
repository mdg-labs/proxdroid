import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_config_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
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

/// Tier-A QEMU config editor (`/vms/:node/:vmid/edit`).
class VmEditScreen extends ConsumerStatefulWidget {
  const VmEditScreen({required this.node, required this.vmid, super.key});

  final String node;
  final String vmid;

  @override
  ConsumerState<VmEditScreen> createState() => _VmEditScreenState();
}

class _VmEditScreenState extends ConsumerState<VmEditScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _appliedBindKey;
  bool _onBoot = false;
  bool _saving = false;

  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _description = TextEditingController();
  late final TextEditingController _tags = TextEditingController();
  late final TextEditingController _memory = TextEditingController();
  late final TextEditingController _sockets = TextEditingController();
  late final TextEditingController _cores = TextEditingController();
  late final TextEditingController _vcpus = TextEditingController();
  late final TextEditingController _cpu = TextEditingController();
  late final TextEditingController _ostype = TextEditingController();
  late final TextEditingController _startup = TextEditingController();
  late final TextEditingController _agent = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _tags.dispose();
    _memory.dispose();
    _sockets.dispose();
    _cores.dispose();
    _vcpus.dispose();
    _cpu.dispose();
    _ostype.dispose();
    _startup.dispose();
    _agent.dispose();
    super.dispose();
  }

  void _bindFromDraft(QemuVmConfig draft, int bindKey) {
    if (_appliedBindKey == bindKey) {
      return;
    }
    _appliedBindKey = bindKey;
    _name.text = draft.name ?? '';
    _description.text = draft.description ?? '';
    _tags.text = draft.tags ?? '';
    _memory.text = draft.memory ?? '';
    _sockets.text = draft.sockets ?? '';
    _cores.text = draft.cores ?? '';
    _vcpus.text = draft.vcpus ?? '';
    _cpu.text = draft.cpu ?? '';
    _ostype.text = draft.ostype ?? '';
    _startup.text = draft.startup ?? '';
    _agent.text = draft.agent ?? '';
    _onBoot = _truthyString(draft.onboot);
  }

  QemuVmConfig _draftFromForm(QemuVmConfig template) {
    final onboot =
        _onBoot == _truthyString(template.onboot)
            ? template.onboot
            : _boolToPve(_onBoot);
    return template.copyWith(
      name: _nullableTrim(_name.text),
      description: _nullableTrim(_description.text),
      tags: _nullableTrim(_tags.text),
      memory: _nullableTrim(_memory.text),
      sockets: _nullableTrim(_sockets.text),
      cores: _nullableTrim(_cores.text),
      vcpus: _nullableTrim(_vcpus.text),
      cpu: _nullableTrim(_cpu.text),
      ostype: _nullableTrim(_ostype.text),
      onboot: onboot,
      startup: _nullableTrim(_startup.text),
      agent: _nullableTrim(_agent.text),
    );
  }

  Future<void> _save(AppLocalizations l10n, String node, int vmid) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final cur = ref.read(qemuVmConfigEditorProvider(node, vmid)).requireValue;
    final edited = _draftFromForm(cur.draft);
    final delta = qemuVmConfigDelta(cur.original, edited);
    if (delta.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.guestConfigSaveNothingChanged)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      ref
          .read(qemuVmConfigEditorProvider(node, vmid).notifier)
          .updateDraft(edited);
      await ref.read(qemuVmConfigEditorProvider(node, vmid).notifier).save();
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
    final id = int.tryParse(widget.vmid);
    if (id == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.screenEditVmConfig),
          ),
          Expanded(
            child: ErrorView(
              message: l10n.vmNotFoundMessage,
              onRetry: () => context.pop(),
            ),
          ),
        ],
      );
    }

    final node = widget.node;
    final vmid = id;
    final async = ref.watch(qemuVmConfigEditorProvider(node, vmid));

    return async.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.screenEditVmConfig),
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
                title: Text(l10n.screenEditVmConfig),
              ),
              Expanded(
                child: ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry:
                      () => ref.invalidate(
                        qemuVmConfigEditorProvider(node, vmid),
                      ),
                ),
              ),
            ],
          ),
      data: (state) {
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
              title: Text(l10n.screenEditVmConfig),
              actions: [
                TextButton(
                  onPressed:
                      _saving
                          ? null
                          : () {
                            ref
                                .read(
                                  qemuVmConfigEditorProvider(
                                    node,
                                    vmid,
                                  ).notifier,
                                )
                                .resetFromServer();
                          },
                  child: Text(l10n.guestConfigActionDiscard),
                ),
                TextButton(
                  onPressed: _saving ? null : () => _save(l10n, node, vmid),
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
                              controller: _name,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldVmName,
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
                        child: TextFormField(
                          controller: _memory,
                          decoration: InputDecoration(
                            labelText: l10n.guestConfigFieldMemory,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
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
                              controller: _sockets,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldSockets,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
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
                              controller: _vcpus,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldVcpus,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _cpu,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldCpuType,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _ostype,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldGuestOs,
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
                        child: TextFormField(
                          controller: _agent,
                          decoration: InputDecoration(
                            labelText: l10n.guestConfigFieldQemuAgent,
                            border: const OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.done,
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
