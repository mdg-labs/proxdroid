import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/server.dart';

/// [TypeAdapter] for [Server] (metadata only — no credentials).
///
/// **typeId 42** — reserved for ProxDroid; use a stable id in the custom range
/// (Hive CE reserves built-in type ids 0–21; pick a unique id below 224 for
/// compatibility with single-byte encoding where applicable).
class ServerAdapter extends TypeAdapter<Server> {
  @override
  final int typeId = 42;

  static const int _authApiToken = 0;
  static const int _authUsernamePassword = 1;

  @override
  Server read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final host = reader.readString();
    final port = reader.readInt();
    final authCode = reader.readByte();
    final allowSelfSigned = reader.readBool();
    final authType = switch (authCode) {
      _authApiToken => ServerAuthType.apiToken,
      _authUsernamePassword => ServerAuthType.usernamePassword,
      _ => ServerAuthType.apiToken,
    };
    String? pinnedTlsSha256;
    if (reader.availableBytes > 0) {
      final s = reader.readString();
      if (s.isNotEmpty) {
        pinnedTlsSha256 = s;
      }
    }
    return Server(
      id: id,
      name: name,
      host: host,
      port: port,
      authType: authType,
      allowSelfSigned: allowSelfSigned,
      pinnedTlsSha256: pinnedTlsSha256,
    );
  }

  @override
  void write(BinaryWriter writer, Server obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.host);
    writer.writeInt(obj.port);
    writer.writeByte(switch (obj.authType) {
      ServerAuthType.apiToken => _authApiToken,
      ServerAuthType.usernamePassword => _authUsernamePassword,
    });
    writer.writeBool(obj.allowSelfSigned);
    writer.writeString(obj.pinnedTlsSha256 ?? '');
  }
}
