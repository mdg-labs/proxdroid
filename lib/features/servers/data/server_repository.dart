import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_storage.dart';

/// Typed facade over [ServerStorage] for the servers feature (no UI).
class ServerRepository {
  ServerRepository(this._storage);

  final ServerStorage _storage;

  Future<List<Server>> getAll() => _storage.getAll();

  Future<Server?> getById(String id) => _storage.get(id);

  /// Persists server metadata; optional credential args are passed through to storage.
  Future<void> save(
    Server server, {
    String? apiToken,
    String? password,
    String? username,
  }) => _storage.save(
    server,
    apiToken: apiToken,
    password: password,
    username: username,
  );

  Future<void> delete(String id) => _storage.delete(id);
}
