import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/secure_storage_backend.dart';

part 'server_storage.g.dart';

/// Hive box name for persisted [Server] metadata (no credentials).
const String kServersHiveBoxName = 'servers';

String _apiTokenKey(String serverId) => 'apiToken_$serverId';

String _usernameKey(String serverId) => 'username_$serverId';

String _passwordKey(String serverId) => 'password_$serverId';

/// Server metadata in Hive; API tokens and passwords in [SecureStorage] only.
class ServerStorage {
  ServerStorage({
    required Box<Server> box,
    required SecureStorage secureStorage,
  }) : _box = box,
       _secure = secureStorage;

  final Box<Server> _box;
  final SecureStorage _secure;

  Future<List<Server>> getAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => a.id.compareTo(b.id));
    return list;
  }

  Future<Server?> get(String id) async => _box.get(id);

  /// Persists [server] metadata to Hive. Credentials are optional and only
  /// updated when the corresponding argument is non-null.
  ///
  /// Clears credential keys that do not apply to [server.authType].
  Future<void> save(
    Server server, {
    String? apiToken,
    String? password,
    String? username,
  }) async {
    await _box.put(server.id, server);

    switch (server.authType) {
      case ServerAuthType.apiToken:
        await _secure.delete(key: _usernameKey(server.id));
        await _secure.delete(key: _passwordKey(server.id));
        if (apiToken != null) {
          await _secure.write(key: _apiTokenKey(server.id), value: apiToken);
        }
      case ServerAuthType.usernamePassword:
        await _secure.delete(key: _apiTokenKey(server.id));
        if (username != null) {
          await _secure.write(key: _usernameKey(server.id), value: username);
        }
        if (password != null) {
          await _secure.write(key: _passwordKey(server.id), value: password);
        }
    }
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
    await _secure.delete(key: _apiTokenKey(id));
    await _secure.delete(key: _usernameKey(id));
    await _secure.delete(key: _passwordKey(id));
  }

  Future<String?> readApiToken(String serverId) =>
      _secure.read(key: _apiTokenKey(serverId));

  Future<({String username, String password})?> readUsernamePassword(
    String serverId,
  ) async {
    final u = await _secure.read(key: _usernameKey(serverId));
    final p = await _secure.read(key: _passwordKey(serverId));
    if (u == null || p == null) return null;
    return (username: u, password: p);
  }
}

/// Must be overridden in [main] after the Hive box is opened.
@Riverpod(keepAlive: true)
ServerStorage serverStorage(Ref ref) {
  throw UnsupportedError(
    'serverStorageProvider must be overridden after Hive is initialized in '
    'main.dart (ProviderScope.overrides).',
  );
}
