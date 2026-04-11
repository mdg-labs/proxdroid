import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/grouped_section.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

/// Minimal create-LXC flow (`/containers/create`, optional `?node=` query).
class ContainerCreateScreen extends ConsumerStatefulWidget {
  const ContainerCreateScreen({this.initialNode, super.key});

  final String? initialNode;

  @override
  ConsumerState<ContainerCreateScreen> createState() =>
      _ContainerCreateScreenState();
}

class _ContainerCreateScreenState extends ConsumerState<ContainerCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _nextIdLoaded = false;
  bool _scheduledNextIdFetch = false;
  String? _selectedNode;
  bool _unprivileged = true;

  late final TextEditingController _vmid = TextEditingController();
  late final TextEditingController _hostname = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  late final TextEditingController _memory = TextEditingController(text: '512');
  late final TextEditingController _ostype = TextEditingController(
    text: 'debian',
  );
  late final TextEditingController _rootfs = TextEditingController();
  late final TextEditingController _net0 = TextEditingController(
    text: 'name=eth0,bridge=vmbr0,ip=dhcp',
  );

  @override
  void dispose() {
    _vmid.dispose();
    _hostname.dispose();
    _password.dispose();
    _memory.dispose();
    _ostype.dispose();
    _rootfs.dispose();
    _net0.dispose();
    super.dispose();
  }

  String _resolvedNode(List<Node> nodes) {
    if (nodes.isEmpty) {
      return '';
    }
    if (_selectedNode != null && nodes.any((n) => n.name == _selectedNode)) {
      return _selectedNode!;
    }
    final q = widget.initialNode;
    if (q != null && nodes.any((n) => n.name == q)) {
      return q;
    }
    return nodes.first.name;
  }

  Future<void> _loadNextId(ContainerRepository repo) async {
    if (_nextIdLoaded) {
      return;
    }
    _nextIdLoaded = true;
    try {
      final id = await repo.fetchNextGuestId();
      if (mounted && _vmid.text.trim().isEmpty) {
        setState(() => _vmid.text = id.toString());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _nextIdLoaded = false);
      }
    }
  }

  String? _required(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) {
      return l10n.validationFieldRequired;
    }
    return null;
  }

  String? _positiveInt(String? v, AppLocalizations l10n) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) {
      return l10n.validationFieldRequired;
    }
    final n = int.tryParse(t);
    if (n == null || n < 1) {
      return l10n.validationIntegerPositive;
    }
    return null;
  }

  String? _vmidValidator(String? v, AppLocalizations l10n) {
    final err = _positiveInt(v, l10n);
    if (err != null) {
      return err;
    }
    final n = int.parse(v!.trim());
    if (n < 100) {
      return l10n.validationVmidMin;
    }
    return null;
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final nodes = await ref.read(nodeListProvider.future);
    if (!mounted) {
      return;
    }
    if (nodes.isEmpty) {
      return;
    }
    final node = _resolvedNode(nodes);
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = await ref.read(containerRepositoryProvider.future);
      if (repo == null) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.errorProxmoxUnknown)),
          );
        }
        return;
      }
      final vmid = int.parse(_vmid.text.trim());
      final mem = int.parse(_memory.text.trim());
      final body = <String, dynamic>{
        'vmid': vmid,
        'hostname': _hostname.text.trim(),
        'password': _password.text,
        'ostype': _ostype.text.trim(),
        'rootfs': _rootfs.text.trim(),
        'memory': mem,
        'net0': _net0.text.trim(),
        'unprivileged': _unprivileged ? 1 : 0,
      };
      final result = await repo.createContainer(node, body);
      if (!mounted) {
        return;
      }
      if (result.upid != null) {
        final status = await ref.read(
          taskStatusProvider(node, result.upid!).future,
        );
        if (!mounted) {
          return;
        }
        ref.invalidate(allContainersProvider);
        ref.invalidate(taskListProvider);
        await ref.read(allContainersProvider.future);
        if (!mounted) {
          return;
        }
        switch (status) {
          case pve.TaskStatus.ok:
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  l10n.powerActionCompleted(l10n.guestCreateCtActionName),
                ),
              ),
            );
            if (mounted) {
              context.pop();
            }
            break;
          case pve.TaskStatus.error:
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.powerActionTaskFailed)),
            );
            break;
          case pve.TaskStatus.running:
          case pve.TaskStatus.unknown:
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.powerActionTaskUnknown)),
            );
            break;
        }
      } else {
        ref.invalidate(allContainersProvider);
        ref.invalidate(taskListProvider);
        await ref.read(allContainersProvider.future);
        if (!mounted) {
          return;
        }
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.powerActionCompleted(l10n.guestCreateCtActionName),
            ),
          ),
        );
        if (mounted) {
          context.pop();
        }
      }
    } catch (e, _) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final nodesAsync = ref.watch(nodeListProvider);

    return ShellSectionBody(
      title: Text(l10n.guestCreateCtTitle),
      leading: shellAppBarLeading(context),
      body: nodesAsync.when(
        loading: () => const LoadingShimmer(),
        error:
            (e, _) => ErrorView(
              message: proxmoxExceptionMessage(e, l10n),
              onRetry: () => ref.read(nodeListProvider.notifier).refresh(),
            ),
        data: (nodes) {
          if (nodes.isEmpty) {
            return Center(child: Text(l10n.guestCreateNoNodes));
          }
          if (!_scheduledNextIdFetch) {
            _scheduledNextIdFetch = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final repo = await ref.read(containerRepositoryProvider.future);
              if (repo != null && mounted) {
                await _loadNextId(repo);
              }
            });
          }
          final resolved = _resolvedNode(nodes);
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                GroupedSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(title: l10n.guestCreateSectionTarget),
                      DropdownButtonFormField<String>(
                        // Controlled selection; `initialValue` only applies on first build.
                        // ignore: deprecated_member_use
                        value: resolved,
                        decoration: InputDecoration(
                          labelText: l10n.entityNode,
                          filled: true,
                        ),
                        items:
                            nodes
                                .map(
                                  (n) => DropdownMenuItem(
                                    value: n.name,
                                    child: Text(n.name),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            _submitting
                                ? null
                                : (v) {
                                  if (v != null) {
                                    setState(() => _selectedNode = v);
                                  }
                                },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _vmid,
                        decoration: InputDecoration(
                          labelText: l10n.labelCtid,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => _vmidValidator(v, l10n),
                        readOnly: _submitting,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GroupedSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(title: l10n.guestConfigSectionIdentity),
                      TextFormField(
                        controller: _hostname,
                        decoration: InputDecoration(
                          labelText: l10n.guestConfigFieldHostname,
                          filled: true,
                        ),
                        validator: (v) => _required(v, l10n),
                        readOnly: _submitting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: l10n.guestCreateFieldRootPassword,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (v) => _required(v, l10n),
                        readOnly: _submitting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.guestConfigFieldUnprivileged),
                        value: _unprivileged,
                        onChanged:
                            _submitting
                                ? null
                                : (v) => setState(() => _unprivileged = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GroupedSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(title: l10n.guestConfigSectionResources),
                      TextFormField(
                        controller: _memory,
                        decoration: InputDecoration(
                          labelText: l10n.guestConfigFieldMemory,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => _positiveInt(v, l10n),
                        readOnly: _submitting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _ostype,
                        decoration: InputDecoration(
                          labelText: l10n.guestConfigFieldGuestOs,
                          filled: true,
                          helperText: l10n.guestCreateCtOstypeHint,
                        ),
                        validator: (v) => _required(v, l10n),
                        readOnly: _submitting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _rootfs,
                        decoration: InputDecoration(
                          labelText: l10n.guestConfigFieldRootfs,
                          filled: true,
                          helperText: l10n.guestCreateFieldRootfsHint,
                        ),
                        validator: (v) => _required(v, l10n),
                        readOnly: _submitting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _net0,
                        decoration: InputDecoration(
                          labelText: l10n.guestCreateFieldNet0,
                          filled: true,
                          helperText: l10n.guestCreateFieldNet0HintCt,
                        ),
                        validator: (v) => _required(v, l10n),
                        readOnly: _submitting,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _submitting ? null : () => _submit(l10n),
                  child:
                      _submitting
                          ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                          : Text(l10n.guestCreateSubmit),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.guestCreateCtDisclaimer,
                  style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
