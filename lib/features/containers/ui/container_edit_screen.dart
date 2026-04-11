import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';
import 'package:proxdroid/features/containers/providers/container_config_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
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
  }

  LxcContainerConfig _draftFromForm(LxcContainerConfig template) {
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
      rootfs: template.rootfs,
    );
  }

  Future<void> _save(AppLocalizations l10n, String node, int ctid) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final cur =
        ref.read(lxcContainerConfigEditorProvider(node, ctid)).requireValue;
    final edited = _draftFromForm(cur.draft);
    final delta = lxcContainerConfigDelta(cur.original, edited);
    if (delta.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.guestConfigSaveNothingChanged)),
      );
      return;
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
                            TextFormField(
                              controller: _ostype,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldGuestOs,
                                border: const OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
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
                            TextFormField(
                              controller: _rootfs,
                              decoration: InputDecoration(
                                labelText: l10n.guestConfigFieldRootfs,
                                helperText: l10n.guestConfigRootfsReadOnlyHint,
                                border: const OutlineInputBorder(),
                              ),
                              readOnly: true,
                              maxLines: 2,
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
