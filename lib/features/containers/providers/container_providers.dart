import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';

part 'container_providers.g.dart';

@riverpod
Future<ContainerRepository?> containerRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return ContainerRepository(client);
}

/// All cluster LXCs (`allContainersProvider`). Pull-to-refresh:
/// `ref.read(allContainersProvider.notifier).refresh()`.
@riverpod
class AllContainers extends _$AllContainers {
  @override
  Future<List<Container>> build() async {
    final repo = await ref.watch(containerRepositoryProvider.future);
    if (repo == null) return const [];
    return repo.getAllContainers();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
