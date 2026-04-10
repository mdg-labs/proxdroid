import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction for credential storage so tests can use an in-memory backend.
abstract class SecureStorage {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

/// Stores secrets via [FlutterSecureStorage] (Android Keystore on device).
class FlutterSecureStorageAdapter implements SecureStorage {
  FlutterSecureStorageAdapter(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
}
