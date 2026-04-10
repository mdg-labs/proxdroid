import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';

part 'vm_providers.g.dart';

@riverpod
Future<VmRepository?> vmRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return VmRepository(client);
}

/// All cluster VMs (`allVmsProvider`). Pull-to-refresh:
/// `ref.read(allVmsProvider.notifier).refresh()`.
@riverpod
class AllVms extends _$AllVms {
  @override
  Future<List<Vm>> build() async {
    final repo = await ref.watch(vmRepositoryProvider.future);
    if (repo == null) return const [];
    return repo.getAllVms();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
