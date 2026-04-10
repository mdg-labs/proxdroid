import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_storage.dart';
import 'package:proxdroid/features/servers/data/server_repository.dart';

part 'server_providers.g.dart';

@Riverpod(keepAlive: true)
ServerRepository serverRepository(Ref ref) {
  final storage = ref.watch(serverStorageProvider);
  return ServerRepository(storage);
}

@riverpod
Future<Server?> serverById(Ref ref, String id) =>
    ref.watch(serverRepositoryProvider).getById(id);

@riverpod
class ServerListNotifier extends _$ServerListNotifier {
  @override
  Future<List<Server>> build() => ref.watch(serverRepositoryProvider).getAll();

  Future<void> addOrUpdate(
    Server server, {
    String? apiToken,
    String? password,
    String? username,
  }) async {
    await ref
        .read(serverRepositoryProvider)
        .save(
          server,
          apiToken: apiToken,
          password: password,
          username: username,
        );
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    await ref.read(serverRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// MVP: selection tracks the first server in the persisted list whenever the list
/// changes (same drawback as a [StateProvider] that resets on rebuild). For
/// production, persist the **selected server id** in hive_ce and resolve it in
/// [build] so the user's explicit choice survives list edits.
@Riverpod(keepAlive: true)
class SelectedServer extends _$SelectedServer {
  @override
  Server? build() {
    final listAsync = ref.watch(serverListNotifierProvider);
    return listAsync.when(
      data: (servers) => servers.isEmpty ? null : servers.first,
      loading: () => null,
      error: (_, _) => null,
    );
  }
}

@riverpod
Future<ProxmoxApiClient?> apiClient(Ref ref) async {
  final server = ref.watch(selectedServerProvider);
  if (server == null) return null;

  final storage = ref.watch(serverStorageProvider);
  switch (server.authType) {
    case ServerAuthType.apiToken:
      final token = await storage.readApiToken(server.id);
      if (token == null) return null;
      return ProxmoxApiClient(server: server, apiToken: token);
    case ServerAuthType.usernamePassword:
      final creds = await storage.readUsernamePassword(server.id);
      if (creds == null) return null;
      return ProxmoxApiClient(
        server: server,
        username: creds.username,
        password: creds.password,
      );
  }
}
