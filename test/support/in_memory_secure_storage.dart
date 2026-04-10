import 'package:proxdroid/core/storage/secure_storage_backend.dart';

/// Hermetic [SecureStorage] for VM tests (no platform keystore).
class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> delete({required String key}) async {
    _data.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => _data[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _data[key] = value;
  }
}
