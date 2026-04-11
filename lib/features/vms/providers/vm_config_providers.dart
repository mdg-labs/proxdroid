import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';

part 'vm_config_providers.g.dart';

/// Parsed QEMU config from `GET …/qemu/{vmid}/config` for [node] + [vmid].
@riverpod
Future<QemuVmConfig> qemuVmConfig(Ref ref, String node, int vmid) async {
  final repo = await ref.watch(vmRepositoryProvider.future);
  if (repo == null) {
    throw const AuthException();
  }
  return repo.getQemuConfig(node, vmid);
}

/// Immutable editing bundle: server [original], editable [draft], [bindKey] for
/// UI controller sync after fetch / reset / successful save.
@immutable
final class QemuVmConfigEditState {
  const QemuVmConfigEditState({
    required this.original,
    required this.draft,
    required this.bindKey,
  });

  final QemuVmConfig original;
  final QemuVmConfig draft;
  final int bindKey;

  QemuVmConfigEditState copyWith({
    QemuVmConfig? original,
    QemuVmConfig? draft,
    int? bindKey,
  }) => QemuVmConfigEditState(
    original: original ?? this.original,
    draft: draft ?? this.draft,
    bindKey: bindKey ?? this.bindKey,
  );
}

/// Loads config, holds [QemuVmConfigEditState], saves via delta PUT.
@riverpod
class QemuVmConfigEditor extends _$QemuVmConfigEditor {
  int _bindSeq = 0;

  @override
  Future<QemuVmConfigEditState> build(String node, int vmid) async {
    final c = await ref.watch(qemuVmConfigProvider(node, vmid).future);
    _bindSeq++;
    return QemuVmConfigEditState(original: c, draft: c, bindKey: _bindSeq);
  }

  void updateDraft(QemuVmConfig draft) {
    final v = state.valueOrNull;
    if (v == null) {
      return;
    }
    state = AsyncData(v.copyWith(draft: draft));
  }

  void resetFromServer() {
    final v = state.valueOrNull;
    if (v == null) {
      return;
    }
    _bindSeq++;
    state = AsyncData(
      QemuVmConfigEditState(
        original: v.original,
        draft: v.original,
        bindKey: _bindSeq,
      ),
    );
  }

  /// Persists [draft] vs [original]; no-op when delta is empty.
  /// On success invalidates VM list and [qemuVmConfigProvider] (this notifier
  /// rebuilds from fresh GET).
  Future<void> save() async {
    final v = state.valueOrNull;
    if (v == null) {
      return;
    }
    final delta = qemuVmConfigDeltaResult(v.original, v.draft);
    if (delta.isEmpty) {
      return;
    }
    final repo = await ref.read(vmRepositoryProvider.future);
    if (repo == null) {
      throw const AuthException();
    }
    await repo.updateQemuConfig(
      node,
      vmid,
      Map<String, dynamic>.from(delta.body),
      deleteKeys: delta.deleteKeys.isEmpty ? null : delta.deleteKeys,
    );
    ref.invalidate(allVmsProvider);
    ref.invalidate(qemuVmConfigProvider(node, vmid));
  }
}
