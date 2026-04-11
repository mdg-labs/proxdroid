import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';

/// How the app authenticates to this Proxmox server.
///
/// API tokens and passwords are stored in `flutter_secure_storage` only,
/// keyed by [Server.id] — they are never fields on [Server].
enum ServerAuthType { apiToken, usernamePassword }

@freezed
sealed class Server with _$Server {
  const factory Server({
    required String id,
    required String name,
    required String host,
    required int port,
    required ServerAuthType authType,
    required bool allowSelfSigned,

    /// SHA-256 (hex) of the leaf TLS certificate DER when [allowSelfSigned] is true.
    String? pinnedTlsSha256,
  }) = _Server;
}
