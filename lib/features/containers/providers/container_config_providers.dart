import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/vm_lxc_config_delta.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';

part 'container_config_providers.g.dart';

/// Parsed LXC config from `GET …/lxc/{vmid}/config` ([vmid] is CT id).
@riverpod
Future<LxcContainerConfig> lxcContainerConfig(
  Ref ref,
  String node,
  int vmid,
) async {
  final repo = await ref.watch(containerRepositoryProvider.future);
  if (repo == null) {
    throw const AuthException();
  }
  return repo.getLxcConfig(node, vmid);
}

@immutable
final class LxcContainerConfigEditState {
  const LxcContainerConfigEditState({
    required this.original,
    required this.draft,
    required this.bindKey,
  });

  final LxcContainerConfig original;
  final LxcContainerConfig draft;
  final int bindKey;

  LxcContainerConfigEditState copyWith({
    LxcContainerConfig? original,
    LxcContainerConfig? draft,
    int? bindKey,
  }) => LxcContainerConfigEditState(
    original: original ?? this.original,
    draft: draft ?? this.draft,
    bindKey: bindKey ?? this.bindKey,
  );
}

@riverpod
class LxcContainerConfigEditor extends _$LxcContainerConfigEditor {
  int _bindSeq = 0;

  @override
  Future<LxcContainerConfigEditState> build(String node, int vmid) async {
    final c = await ref.watch(lxcContainerConfigProvider(node, vmid).future);
    _bindSeq++;
    return LxcContainerConfigEditState(
      original: c,
      draft: c,
      bindKey: _bindSeq,
    );
  }

  void updateDraft(LxcContainerConfig draft) {
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
      LxcContainerConfigEditState(
        original: v.original,
        draft: v.original,
        bindKey: _bindSeq,
      ),
    );
  }

  Future<void> save() async {
    final v = state.valueOrNull;
    if (v == null) {
      return;
    }
    final delta = lxcContainerConfigDeltaResult(v.original, v.draft);
    if (delta.isEmpty) {
      return;
    }
    final repo = await ref.read(containerRepositoryProvider.future);
    if (repo == null) {
      throw const AuthException();
    }
    await repo.updateLxcConfig(
      node,
      vmid,
      Map<String, dynamic>.from(delta.body),
      deleteKeys: delta.deleteKeys.isEmpty ? null : delta.deleteKeys,
    );
    ref.invalidate(allContainersProvider);
    ref.invalidate(lxcContainerConfigProvider(node, vmid));
  }
}
