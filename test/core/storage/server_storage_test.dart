import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/storage/server_adapter.dart';
import 'package:proxdroid/core/storage/server_storage.dart';

import '../../support/in_memory_secure_storage.dart';

void main() {
  late Directory tempDir;
  late Box<Server> box;
  late InMemorySecureStorage secure;
  late ServerStorage storage;

  setUp(() async {
    secure = InMemorySecureStorage();
    tempDir = Directory.systemTemp.createTempSync(
      'proxdroid_server_storage_test',
    );
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(ServerAdapter().typeId)) {
      Hive.registerAdapter(ServerAdapter());
    }
    final uniqueName = 'servers_${tempDir.path.hashCode.abs()}';
    box = await Hive.openBox<Server>(uniqueName);
    storage = ServerStorage(box: box, secureStorage: secure);
  });

  tearDown(() async {
    final name = box.name;
    await box.close();
    await Hive.deleteBoxFromDisk(name);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('getAll returns empty then sorted servers', () async {
    expect(await storage.getAll(), isEmpty);

    final b = Server(
      id: 'b',
      name: 'B',
      host: 'b.example',
      port: 8006,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: false,
    );
    final a = Server(
      id: 'a',
      name: 'A',
      host: 'a.example',
      port: 8006,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: true,
    );
    await storage.save(b);
    await storage.save(a);

    final all = await storage.getAll();
    expect(all.map((e) => e.id).toList(), ['a', 'b']);
  });

  test('save apiToken stores token in secure storage only', () async {
    final server = Server(
      id: 's1',
      name: 'Homelab',
      host: 'pve.local',
      port: 8006,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: true,
    );
    await storage.save(server, apiToken: 'secret-token');

    final loaded = await storage.get('s1');
    expect(loaded, server);
    expect(await storage.readApiToken('s1'), 'secret-token');
    expect(await storage.readUsernamePassword('s1'), isNull);
  });

  test('save usernamePassword stores username and password', () async {
    final server = Server(
      id: 's2',
      name: 'Node',
      host: '10.0.0.1',
      port: 443,
      authType: ServerAuthType.usernamePassword,
      allowSelfSigned: false,
    );
    await storage.save(server, username: 'root@pam', password: 'hunter2');

    expect(await storage.get('s2'), server);
    expect(await storage.readApiToken('s2'), isNull);
    final creds = await storage.readUsernamePassword('s2');
    expect(creds?.username, 'root@pam');
    expect(creds?.password, 'hunter2');
  });

  test('switching auth type clears incompatible credentials', () async {
    final id = 's3';
    var server = Server(
      id: id,
      name: 'X',
      host: 'x',
      port: 443,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: false,
    );
    await storage.save(server, apiToken: 'tok');
    expect(await storage.readApiToken(id), 'tok');

    server = server.copyWith(authType: ServerAuthType.usernamePassword);
    await storage.save(server, username: 'u', password: 'p');
    expect(await storage.readApiToken(id), isNull);
    expect((await storage.readUsernamePassword(id))?.username, 'u');

    server = server.copyWith(authType: ServerAuthType.apiToken);
    await storage.save(server, apiToken: 'newtok');
    expect(await storage.readApiToken(id), 'newtok');
    expect(await storage.readUsernamePassword(id), isNull);
  });

  test('delete removes server and all credential keys', () async {
    final server = Server(
      id: 'gone',
      name: 'G',
      host: 'g',
      port: 443,
      authType: ServerAuthType.usernamePassword,
      allowSelfSigned: true,
    );
    await storage.save(server, username: 'u', password: 'p');
    await storage.delete('gone');

    expect(await storage.get('gone'), isNull);
    expect(await storage.getAll(), isEmpty);
    expect(await storage.readUsernamePassword('gone'), isNull);
    expect(await storage.readApiToken('gone'), isNull);
  });

  test('save without credential args keeps previous secrets', () async {
    final server = Server(
      id: 'keep',
      name: 'K',
      host: 'k',
      port: 443,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: false,
    );
    await storage.save(server, apiToken: 'first');
    await storage.save(server.copyWith(name: 'Renamed'));

    expect(await storage.readApiToken('keep'), 'first');
  });
}
